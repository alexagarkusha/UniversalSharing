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
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "InternetConnectionManager.h"
#import "NetworkPost.h"
#import "NSString+MUSCurrentDate.h"
#import "MUSPostManager.h"

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
            self.isLogin = YES;
            //[self updatePost];
            [self startTimerForUpdatePosts];
            self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUserWithNetworkType:self.networkType]]firstObject];
            // self.icon = self.currentUser.photoURL;
            self.icon = MUSTwitterIconName;
            self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
//            self.isVisible = self.currentUser.isVisible;
//            NSInteger indexPosition = self.currentUser.indexPosition;
            
            //////////////////////////////////////////////////////////
            
            if ([[InternetConnectionManager connectionManager] isInternetConnection]){
                
                NSString *deleteImageFromFolder = self.currentUser.photoURL;
                
                [self obtainUserInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
                    [[NSFileManager defaultManager] removeItemAtPath: [deleteImageFromFolder obtainPathToDocumentsFolder:deleteImageFromFolder] error: nil];
//                    result.currentUser.indexPosition = indexPosition;
//                    result.currentUser.isVisible = self.isVisible;
                    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUpdateUser:result.currentUser]];
                }];
            }
            
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
    self.isVisible = YES;
    self.currentUser = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void) startTimerForUpdatePosts {
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:600.0f
    //                                                  target:self
    //                                                selector:@selector(updatePost)
    //                                                userInfo:nil
    //                                                 repeats:YES];
}

#pragma mark - loginInNetwork

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
                weakSell.isVisible = YES;
                
                
                [weakSell obtainUserInfoFromNetworkWithComplition:block];
            } else {
                block(nil, error);
            }
            weakSell.doubleTouchFlag = NO;
        }];
    }
}

#pragma mark - loginOut

/*!
 Deletes the local Twitter user session from this app. This will not remove the system Twitter account and make a network request to invalidate the session.
 Current user for social network become nil
 And initiation properties of VKNetwork without session
 */

- (void) logout {
    //[TwitterKit logOut];
    //[TwitterKit logOutGuest];
    
    [[Twitter sharedInstance] logOut];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    [[MUSPostManager manager] deleteNetworkPostForNetworkType: self.networkType];
    [MUSPostManager manager].needToRefreshPosts = YES;
    
    //[[Twitter sharedInstance] logOutGuest];
    [self removeUserFromDataBaseAndImageFromDocumentsFolder:self.currentUser];
    
    [self initiationPropertiesWithoutSession];
}


#pragma mark - obtainUserFromNetwork

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSell = self;
    
    [[TwitterKit APIClient] loadUserWithID : [[[Twitter sharedInstance ]session] userID]
                                 completion:^(TWTRUser *user, NSError *error)
     {
         if (user) {
             weakSell.currentUser = [User createFromDictionary:user andNetworkType : weakSell.networkType];
             weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
             //dispatch_async(dispatch_get_main_queue(), ^{
             //weakSell.icon = [weakSell.currentUser.photoURL saveImageOfUserToDocumentsFolder:weakSell.currentUser.photoURL];
             //});
             
             weakSell.currentUser.photoURL = [weakSell.currentUser.photoURL saveImageOfUserToDocumentsFolder:weakSell.currentUser.photoURL];
             //weakSell.currentUser.photoURL = weakSell.icon;
             //weakSell.currentUser.indexPosition = 0;
             //weakSell.icon = weakSell.currentUser.photoURL;////
             if (!weakSell.isLogin)
                 [[DataBaseManager sharedManager] insertObjectIntoTable:weakSell.currentUser];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 weakSell.isLogin = YES;
                 [weakSell startTimerForUpdatePosts];
                 block(weakSell,nil);
             });
             //             weakSell.currentUser = [User createFromDictionary : user
             //                                                andNetworkType : weakSell.networkType];
             //
             //             weakSell.title = [NSString stringWithFormat:@"%@  %@",
             //                                        weakSell.currentUser.firstName, weakSell.currentUser.lastName];
             //
             //             weakSell.icon = weakSell.currentUser.photoURL;
             //             dispatch_async(dispatch_get_main_queue(), ^{
             //                 block (weakSell, nil);
             //             });
         } else {
             block (nil, [self errorTwitter]);
         }
     }];
}

- (void) updateNetworkPostWithComplition: (UpdateNetworkPostsComplition) block {
    NSArray * networksPostsIDs = [[DataBaseManager sharedManager] obtainNetworkPostsFromDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForNetworkPostWithReason: MUSConnect andNetworkType: MUSTwitters]];
    
    if (![[InternetConnectionManager connectionManager] isInternetConnection] || !networksPostsIDs.count || (![[InternetConnectionManager connectionManager] isInternetConnection] && networksPostsIDs.count)) {
        block (@"Twitter, Error update network posts");
        return;
    }
    
    __block NSUInteger counterOfNetworkPosts = 0;
    __block NSUInteger numberOfNetworkPosts = networksPostsIDs.count;
    
    [networksPostsIDs enumerateObjectsUsingBlock:^(NetworkPost *networkPost, NSUInteger idx, BOOL *stop) {
        [self obtainCountOfLikesAndCommentsFromPost: networkPost withComplition:^(id result, NSError *error) {
            counterOfNetworkPosts++;
            if (counterOfNetworkPosts == numberOfNetworkPosts) {
                block (@"Twitter update all network posts");
            }
        }];
    }];
    
    
}

- (void) obtainCountOfLikesAndCommentsFromPost :(NetworkPost*) networkPost withComplition : (Complition) block {
    NSString *statusesShowEndpoint = MUSTwitterURL_Statuses_Show;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:networkPost.postID,@"id",@"true",@"include_my_retweet",nil];//,@"100",@"count"
    NSError *clientError;
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    __block NetworkPost *networkPostCopy = networkPost;
    
    if (request) {
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSDictionary *arrayJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (!arrayJson.count) {
                    block (@"Error data post update", nil);
                    return;
                }
                if (networkPostCopy.likesCount == [[arrayJson  objectForKey:@"favorite_count"] integerValue] &&  networkPostCopy.commentsCount == [[arrayJson  objectForKey:@"retweet_count"] integerValue] ) {
                    block (@"Post is already updated", nil);
                    return;
                }
                
                networkPostCopy.likesCount = [[arrayJson  objectForKey:@"favorite_count"] integerValue];
                networkPostCopy.commentsCount = [[arrayJson objectForKey:@"retweet_count"] integerValue];
                // NSLog(@"TW post.id = %@, post.like = %ld, post.comments = %d", networkPost.postID, (long)networkPost.likesCount, networkPost.commentsCount);
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForUpdateNetworkPost : networkPostCopy]];
                block (@"Post updated", nil);
            }
            else {
                block (connectionError, nil);
            }
        }];
    }
    else {
        block (@"Error update network posts", nil);
    }
}


#pragma mark - obtainArrayOfPlacesFromNetwork

- (void) obtainPlacesArrayForLocation : (Location*) location withComplition : (Complition) block {
    self.copyComplition = block;
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
                             
                             NSDictionary *resultSearcLocation = [locationJSON objectForKey: @"result"];
                             NSArray *places = [resultSearcLocation objectForKey: @"places"];
                             NSMutableArray *placesArray = [[NSMutableArray alloc] init];
                             
                             for (int i = 0; i < [places count]; i++) {
                                 Place *place = [Place createFromDictionary: [places objectAtIndex: i] andNetworkType:self.networkType];
                                 [placesArray addObject:place];
                             }
                             
                             if ([placesArray count] != 0) {
                                 block (placesArray, nil);
                             }   else {
                                 NSError *error = [NSError errorWithMessage: MUSLocationDistanceError andCodeError: MUSLocationDistanceErrorCode];
                                 block (nil, error);
                             }
                         }else{
                             block (nil, [self errorTwitter]);
                         }
                         
                     }];
}



#pragma mark - sharePostToNetwork

- (void) sharePost:(Post *)post withComplition:(Complition)block progressLoadingBlock:(ProgressLoading)blockLoading {
        if (![[InternetConnectionManager connectionManager] isInternetConnection]){
            NetworkPost *networkPost = [NetworkPost create];
            networkPost.reason = MUSOffline;
            networkPost.networkType = MUSTwitters;
            block(networkPost,[self errorConnection]);
            blockLoading ([NSNumber numberWithInteger: self.networkType], 1.0f);
            return;
        }
    self.copyProgressLoading = blockLoading;
    self.copyComplition = block;
    if ([post.arrayImages count] > 0) {
        [self postImagesToTwitter: post];
    } else {
        [self postMessageToTwitter: post];
    }
}

#pragma mark - postMessageAndLocationWithoutImage

/*!
 @abstract upload message and user location (optional)
 @param current post of @class Post
 */

- (void) postMessageToTwitter : (Post*) post {
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    NSString *url = MUSTwitterURL_Statuses_Update;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString* messageText = post.postDescription;
    
    if (post.postDescription.length > 117) {
        messageText = [post.postDescription substringToIndex: 117];
    }
    
    params [MUSTwitterParameter_Status] = messageText;
    if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
        params [MUSTwitterLocationParameter_Latitude] = post.latitude;
        params [MUSTwitterLocationParameter_Longituge] = post.longitude;
    }
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod : MUSPOST
                                                             URL : url
                                                      parameters : params
                                                           error : &error];
    //[preparedRequest setTimeoutInterval:10] ;
    
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = MUSTwitters;
    __block NetworkPost* networkPostCopy = networkPost;
    
    [client sendTwitterRequest:preparedRequest
                    completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
                        //self.copyComplitionProgressLoading(1);
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

- (void) postImagesToTwitter : (Post*) post {
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
            
            
            NSString* messageText = post.postDescription;
            
            if (post.postDescription.length > 117) {
                messageText = [post.postDescription substringToIndex: 117];
            }

            if (post.postDescription) {
                params [MUSTwitterParameter_Status] = messageText;
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
    __block int numberOfIds = post.arrayImages.count;
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
                                //block (nil, jsonError);
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

/*!
 @abstract returned Twitter network error
 */
- (NSError*) errorTwitter {
    return [NSError errorWithMessage: MUSTwitterError andCodeError: MUSTwitterErrorCode];
}

@end
