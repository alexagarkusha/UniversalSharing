//
//  TwitterNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/23/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "TwitterNetwork.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "Place.h"
#import "Location.h"
#import "NSError+MUSError.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "InternetConnectionManager.h"
#import "NetworkPost.h"
#import "NSString+MUSCurrentDate.h"
#import "MUSPostManager.h"
#import "ConstantsApp.h"
#import "MUSSocialNetworkLibraryConstantsForParseObjects.h"

@interface TwitterNetwork () //<TWTRCoreOAuthSigning>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;
@property (assign, nonatomic) BOOL doubleTouchFlag;
@property (copy, nonatomic) ProgressLoading copyProgressLoading;

@end

static TwitterNetwork *model = nil;

#pragma mark Singleton Method

@implementation TwitterNetwork
+ (TwitterNetwork*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[TwitterNetwork alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    self.doubleTouchFlag = NO;
    [TwitterKit startWithConsumerKey:MUSTwitterConsumerKey consumerSecret:MUSTwitterConsumerSecret];
    [Fabric with : @[TwitterKit]];
    if (self) {
        self.networkType = MUSTwitters;
        self.name = MUSTwitterName;
        if (![[Twitter sharedInstance ]session]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            [self initiationPropertiesWithSession];
            [self updateUserInSocialNetwork];
        }
    }
    return self;
}

/*!
 Initiation properties of TwitterNetwork without session
 */
- (void) initiationPropertiesWithoutSession {
    self.title = MUSTwitterTitle;
    self.icon = MUSTwitterIconName;
    self.isLogin = NO;
    self.currentUser = nil;
}

/*!
 Initiation properties of TwitterNetwork with session
 */
- (void) initiationPropertiesWithSession {
    self.isLogin = YES;
    self.icon = MUSTwitterIconName;
    self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
}

#pragma mark - login
/*!
 Triggers user authentication with Twitter.
 This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
 @param completion The completion block will be called after authentication is successful or if there is an error.
 */

- (void) loginWithComplition :(Complition) block {
    if (!self.doubleTouchFlag) {
        self.doubleTouchFlag = YES;
        __weak TwitterNetwork *weakSell = self;
        
        [TwitterKit logInWithCompletion:^(TWTRSession* session, NSError* error) {
            if (session) {
                [weakSell obtainUserInfoFromNetworkWithComplition:block];
            } else {
                block(nil, error);
            }
            weakSell.doubleTouchFlag = NO;
        }];
    }
}

#pragma mark - logout

/*!
 Deletes the local Twitter user session from this app. This will not remove the system Twitter account and make a network request to invalidate the session.
 Current user for social network become nil
 And initiation properties of VKNetwork without session
 */

- (void) logout {
    
    [[Twitter sharedInstance] logOut];
    NSURL *url = [NSURL URLWithString: MUSTwitterURL_Api_Url];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [[MUSPostManager manager] deleteNetworkPostForNetworkType: self.networkType];
    [self.currentUser removeUser];
    [self initiationPropertiesWithoutSession];
}


#pragma mark - obtainUserInfoFromNetwork

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSelf = self;
    
    [[TwitterKit APIClient] loadUserWithID : [[[Twitter sharedInstance ]session] userID]
                                 completion:^(TWTRUser *user, NSError *error)
     {
         if (user) {
             [weakSelf createUser: user];
             weakSelf.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
             if (!weakSelf.isLogin)
                 [weakSelf.currentUser insertToDataBase];
             dispatch_async(dispatch_get_main_queue(), ^{
                 weakSelf.isLogin = YES;
                 block(weakSelf,nil);
             });
        } else {
             block (nil, [self errorTwitter]);
         }
     }];
}

#pragma mark - sharePost

- (void) sharePost:(Post *)post withComplition:(Complition)block progressLoadingBlock:(ProgressLoading)blockLoading {
    if (![[InternetConnectionManager connectionManager] isInternetConnection]){
        NetworkPost *networkPost = [NetworkPost create];
        networkPost.networkType = MUSTwitters;
        block(networkPost,[self errorConnection]);
        blockLoading ([NSNumber numberWithInteger: self.networkType], 1.0f);
        return;
    }
    self.copyProgressLoading = blockLoading;
    self.copyComplition = block;
    if ([post.arrayImages count]) {
        [self sharePostWithPictures: post];
    } else {
        [self sharePostOnlyWithPostDescription: post];
    }
}

#pragma mark - sharePostOnlyWithPostDescription

/*!
 @abstract upload message and user location (optional)
 @param current post of @class Post
 */

- (void) sharePostOnlyWithPostDescription : (Post*) post {
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    NSString *url = MUSTwitterURL_Statuses_Update;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params [MUSTwitterParameter_Status] = [self checkPostsDescriptionOnTheMaximumNumberOfAllowedCharacters: post];
    if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
        params [MUSTwitterLocationParameter_Latitude] = post.latitude;
        params [MUSTwitterLocationParameter_Longituge] = post.longitude;
    }
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod : MUSPOST
                                                             URL : url
                                                      parameters : params
                                                           error : &error];
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = MUSTwitters;
    __block NetworkPost* networkPostCopy = networkPost;
    
    [client sendTwitterRequest:preparedRequest
                    completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
            self.copyProgressLoading ([NSNumber numberWithInteger: self.networkType], 1.0f);
            
                if(!error){
                    NSError *jsonError = nil;
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&jsonError];
                    if (jsonError) {
                        //[self errorTwitter];
                        networkPostCopy.reason = MUSErrorConnection;
                        self.copyComplition (networkPostCopy, [self errorTwitter]);
                        return;
                    }
                    
                    networkPostCopy.postID = [[jsonData objectForKey:@"id"]stringValue];
                    networkPostCopy.reason = MUSConnect;
                    networkPostCopy.dateCreate = [NSString currentDate];
                    self.copyComplition (networkPostCopy, nil);
                }else{
                    networkPostCopy.reason = MUSErrorConnection;
                    self.copyComplition (networkPostCopy, [self errorTwitter]);
            }
    }];
}

#pragma mark - postMessageWithImageAndLocation

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */

- (void) sharePostWithPictures : (Post*) post {
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = MUSTwitters;
    __block NetworkPost *networkPostCopy = networkPost;
    [self mediaIdsForTwitter : post withComplition:^(id result, NSError *error) {
        
        if (!error) {
            NSArray *mediaIdsArray = (NSArray*) result;
            NSString *mediaIdsString = [mediaIdsArray componentsJoinedByString:@","];
            NSString *endpoint = MUSTwitterURL_Statuses_Update;
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            params [MUSTwitterParameter_MediaID] = mediaIdsString;
        
            if (post.postDescription) {
                params [MUSTwitterParameter_Status] = [self checkPostsDescriptionOnTheMaximumNumberOfAllowedCharacters: post];
            }
            if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
                params [MUSTwitterLocationParameter_Latitude] = post.latitude;
                params [MUSTwitterLocationParameter_Longituge] = post.longitude;
            }
            NSError *error = nil;
            
            TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
            NSURLRequest *request = [client URLRequestWithMethod: MUSPOST
                                                             URL: endpoint
                                                      parameters: params
                                                           error: &error];
            if (error) {
                networkPostCopy.reason = MUSErrorConnection;
                self.copyComplition (networkPostCopy, [self errorTwitter]);
                return;
            }
            [client sendTwitterRequest : request
                            completion : ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                self.copyProgressLoading ([NSNumber numberWithInteger: self.networkType], 1.0f);
                    if (!connectionError) {
                        NSError *jsonError = nil;
                        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:&jsonError];
                        if (jsonError) {
                            networkPostCopy.reason = MUSErrorConnection;
                            self.copyComplition (networkPostCopy, [self errorTwitter]);
                            return;
                        }
                        
                        networkPostCopy.postID = [[jsonData objectForKey:@"id"] stringValue];
                        networkPostCopy.reason = MUSConnect;
                        networkPost.dateCreate = [NSString currentDate];
                        self.copyComplition (networkPostCopy, nil);
                    } else {
                        NSError *connectionError = [NSError errorWithMessage: MUSConnectionError
                                                                andCodeError: MUSConnectionErrorCode];
                        networkPostCopy.reason = MUSErrorConnection;
                        self.copyComplition (networkPostCopy, connectionError);
                        return;
                                }
                            }];
        } else {
            networkPostCopy.reason = MUSErrorConnection;
            self.copyComplition (networkPostCopy, error);
        }
    }];
}

/*!
 @abstract return a list of media IDs for Twitter Network to upload photos to social network
 @param current post of @class Post
 */

- (void) mediaIdsForTwitter : (Post*) post withComplition : (Complition) block {
    NSMutableArray *mediaIdsArray = [[NSMutableArray alloc] init];
    __weak NSMutableArray *array = mediaIdsArray;
    __block NSInteger numberOfIds = post.arrayImages.count;
    __block int counterOfIds = 0;
    
    for (int i = 0; i < post.arrayImages.count; i++) {
        [self mediaIDForTwitter : [post.arrayImages objectAtIndex: i] withComplition:^(id result, NSError *error) {
            counterOfIds ++;
            if (!error) {
                [array addObject: result];
            }
            if (counterOfIds == numberOfIds) {
                if (!error) {
                    block (mediaIdsArray, nil);
                } else {
                    block (nil, [self errorTwitter]);
                }
            }
        }];
    }
}

/*!
 @abstract return the media IDs for each image is loaded into a social network
 @param current ImageToPost of @class ImageToPost
 */

- (void) mediaIDForTwitter : (ImageToPost*) imageToPost withComplition : (Complition) block {
    NSString *endpoint = MUSTwitterURL_Media_Upload;
    NSData* imageData = UIImageJPEGRepresentation(imageToPost.image, imageToPost.quality);
    NSDictionary *parameters = @{ MUSTwitterParameter_Media : [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed ]};
    NSError *error = nil;
    
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSURLRequest *request = [client URLRequestWithMethod : MUSPOST
                                                     URL : endpoint
                                              parameters : parameters
                                                   error : &error];
    if (error) {
        block (nil, [self errorTwitter]);
        return;
    }
    [client sendTwitterRequest : request
                    completion : ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *jsonError = nil;
            id jsonData = [NSJSONSerialization JSONObjectWithData : data
                                                          options : NSJSONReadingMutableContainers
                                                            error : &jsonError];
            if (jsonError) {
                block (nil, [self errorTwitter]);
                return;
            }
            
            NSString *mediaId = jsonData [MUSTwitterJSONParameterForMediaID];
            block (mediaId, nil);
        } else {
            NSError *connectionError = [NSError errorWithMessage : MUSConnectionError
                                                    andCodeError : MUSConnectionErrorCode];
            block (nil, connectionError);
            return;
        }
    }];
}


#pragma mark - obtainPlacesArrayForLocation

- (void) obtainPlacesArrayForLocation : (Location*) location withComplition : (Complition) block {
    self.copyComplition = block;
    __weak TwitterNetwork *weakSelf = self;
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (!location.latitude || !location.longitude || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        
        NSError *error = [NSError errorWithMessage: MUSLocationPropertiesError
                                      andCodeError: MUSLocationPropertiesErrorCode];
        return block (nil, error);
    } else {
        params [MUSTwitterLocationParameter_Latitude] = location.latitude;
        params [MUSTwitterLocationParameter_Longituge] = location.longitude;
    }
    
    NSString *url = MUSTwitterURL_Geo_Search;
    NSURLRequest *preparedRequest = [client URLRequestWithMethod : MUSGET
                                                             URL : url
                                                      parameters : params
                                                           error : &error];
    
    [client sendTwitterRequest : preparedRequest
                     completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
                         
        if(!error){
            NSError *jsonError;
            NSDictionary *locationJSON = [NSJSONSerialization JSONObjectWithData : responseData
                                                                         options : 0
                                                                           error : &jsonError];
                             
            NSDictionary *resultSearcLocation = [locationJSON objectForKey: MUSTwitterParseLocation_Result];
            NSArray *places = [resultSearcLocation objectForKey: MUSTwitterParseLocation_Places];
            NSMutableArray *placesArray = [[NSMutableArray alloc] init];
                             
            for (int i = 0; i < [places count]; i++) {
                Place *place = [weakSelf createPlaceFromTwitter: [places objectAtIndex: i]];
                [placesArray addObject:place];
            }
                             
            if ([placesArray count] != 0) {
                block (placesArray, nil);
            } else {
                NSError *error = [NSError errorWithMessage: MUSLocationDistanceError andCodeError: MUSLocationDistanceErrorCode];
                block (nil, error);
            }
        }else{
            block (nil, [weakSelf errorTwitter]);
        }
    }];
}

#pragma mark - updateNetworkPostWithComplition

- (void) updateNetworkPostWithComplition: (UpdateNetworkPostsComplition) block {
    NSArray * networksPostsIDs = [[MUSPostManager manager] networkPostsArrayForNetworkType: self.networkType];
    
    if (![[InternetConnectionManager connectionManager] isInternetConnection] || !networksPostsIDs.count || (![[InternetConnectionManager connectionManager] isInternetConnection] && networksPostsIDs.count)) {
        block (MUSTwitterError);
        return;
    }

    __block NSUInteger counterOfNetworkPosts = 0;
    __block NSUInteger numberOfNetworkPosts = networksPostsIDs.count;
    
    [networksPostsIDs enumerateObjectsUsingBlock:^(NetworkPost *networkPost, NSUInteger idx, BOOL *stop) {
        [self obtainCountOfLikesAndCommentsFromPost: networkPost withComplition:^(id result, NSError *error) {
            counterOfNetworkPosts++;
            if (counterOfNetworkPosts == numberOfNetworkPosts) {
                block (MUSTwitterSuccessUpdateNetworkPost);
            }
        }];
    }];
}

- (void) obtainCountOfLikesAndCommentsFromPost :(NetworkPost*) networkPost withComplition : (Complition) block {
    NSString *statusesShowEndpoint = MUSTwitterURL_Statuses_Show;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys : networkPost.postID, MUSTwitterParameter_ID, MUSTwitterParameter_True, MUSTwitterParameter_Include_My_Retweet, nil];
    
    NSError *clientError;
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod: MUSGET
                                                                                   URL:statusesShowEndpoint
                                                                            parameters:params
                                                                                 error:&clientError];
    __block NetworkPost *networkPostCopy = networkPost;
    
    if (request) {
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSDictionary *arrayJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (!arrayJson.count) {
                    block (MUSNetworkPost_Update_Error_Data, nil);
                    return;
                }
                if (networkPostCopy.likesCount == [[arrayJson  objectForKey:MUSTwitterParameter_Favorite_Count] integerValue] &&  networkPostCopy.commentsCount == [[arrayJson  objectForKey:MUSTwitterParameter_Retweet_Count] integerValue] ) {
                    block (MUSNetworkPost_Update_Already_Update, nil);
                    return;
                }
                
                networkPostCopy.likesCount = [[arrayJson  objectForKey:MUSTwitterParameter_Favorite_Count] integerValue];
                networkPostCopy.commentsCount = [[arrayJson objectForKey:MUSTwitterParameter_Retweet_Count] integerValue];
                [networkPostCopy update];
                block (MUSNetworkPost_Update_Updated, nil);
            }
            else {
                block (connectionError, nil);
            }
        }];
    }
    else {
        block (MUSNetworkPost_Update_Error_Update, nil);
    }
}

/*!
 @abstract returned Twitter network error
 */
- (NSError*) errorTwitter {
    return [NSError errorWithMessage: MUSTwitterError andCodeError: MUSTwitterErrorCode];
}

#pragma mark - createUser
/*!
 @abstract an instance of the User for facebook network.
 @param dictionary takes dictionary from facebook network.
 */
- (void) createUser : (TWTRUser*) userDictionary {
    self.currentUser = [User create];
    self.currentUser.clientID = userDictionary.userID;
    self.currentUser.lastName = userDictionary.screenName;
    self.currentUser.firstName = userDictionary.name;
    self.currentUser.networkType = MUSTwitters;
    NSString *photoURL_max = userDictionary.profileImageURL;
    photoURL_max = [photoURL_max stringByReplacingOccurrencesOfString:@"_normal"
                                                           withString:@""];
    self.currentUser.photoURL = photoURL_max;
    self.currentUser.photoURL = [self.currentUser.photoURL saveImageOfUserToDocumentsFolder: self.currentUser.photoURL];
}

- (NSString*) checkPostsDescriptionOnTheMaximumNumberOfAllowedCharacters : (Post*) post {
    NSString* messageText = post.postDescription;
    
    if (post.postDescription.length > MUSApp_TextView_Twitter_NumberOfAllowedLetters) {
        messageText = [post.postDescription substringToIndex: MUSApp_TextView_Twitter_NumberOfAllowedLetters];
    }
    return messageText;
}

- (Place*) createPlaceFromTwitter : (NSDictionary *) dictionary {
    Place *currentPlace = [Place create];
    
    currentPlace.placeID   = [dictionary objectForKey: MUSTwitterParsePlace_ID];
    currentPlace.placeType = [dictionary objectForKey: MUSTwitterParsePlace_Place_Type];
    currentPlace.country   = [dictionary objectForKey: MUSTwitterParsePlace_Country];
    currentPlace.fullName  = [dictionary objectForKey: MUSTwitterParsePlace_Full_Name];
    
    NSArray *centroid = [dictionary objectForKey: MUSTwitterParsePlace_Centroid];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [centroid lastObject]];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [centroid firstObject]];
    
    NSArray *containedWithinArray = [dictionary objectForKey: MUSTwitterParsePlace_Contained_Within];
    NSDictionary *locationTwitterDictionary = [containedWithinArray firstObject];
    currentPlace.city = [locationTwitterDictionary objectForKey: MUSTwitterParsePlace_Name];
    
    return currentPlace;
}


@end
