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

@interface TwitterNetwork () //<TWTRCoreOAuthSigning>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;
@property (assign, nonatomic) BOOL doubleTouchFlag;
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

/*!
 Initiation TwitterNetwork.
 @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */

- (instancetype) init {
    self = [super init];
    self.doubleTouchFlag = NO;
    [TwitterKit startWithConsumerKey:musTwitterConsumerKey consumerSecret:musTwitterConsumerSecret];
    [Fabric with : @[TwitterKit]];
    if (self) {
        self.networkType = Twitters;
        self.name = musTwitterName;
        if (![[Twitter sharedInstance ]session]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
            //[self updatePost];
            [self startTimerForUpdatePosts];
            self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForUsersWithNetworkType:self.networkType]]firstObject];
            self.icon = self.currentUser.photoURL;
            self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
            self.isVisible = self.currentUser.isVisible;
            //////////////////////////////////////////////////////////
            
            if ([self obtainCurrentConnection]){
                
                
                NSString *deleteImageFromFolder = self.currentUser.photoURL;
                
                [self obtainInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
                    [[NSFileManager defaultManager] removeItemAtPath: [deleteImageFromFolder obtainPathToDocumentsFolder:deleteImageFromFolder] error: nil];
                    result.currentUser.isVisible = self.isVisible;
                    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringUsersForUpdateWithObjectUser:result.currentUser]];
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
    self.title = musTwitterTitle;
    self.icon = musTwitterIconName;
    self.isLogin = NO;
    self.isVisible = YES;
    self.currentUser = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void) startTimerForUpdatePosts {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:600.0f
                                                  target:self
                                                selector:@selector(updatePost)
                                                userInfo:nil
                                                 repeats:YES];
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
                
                
                [weakSell obtainInfoFromNetworkWithComplition:block];
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

- (void) loginOut {
    //[TwitterKit logOut];
    //[TwitterKit logOutGuest];
    
    [[Twitter sharedInstance] logOut];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    
    
    
    //[[Twitter sharedInstance] logOutGuest];
    [self removeUserFromDataBaseAndImageFromDocumentsFolder:self.currentUser];
    
    [self initiationPropertiesWithoutSession];
}


#pragma mark - obtainUserFromNetwork

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSell = self;
    
    [[TwitterKit APIClient] loadUserWithID : [[[Twitter sharedInstance ]session] userID]
                                 completion:^(TWTRUser *user, NSError *error)
     {
         if (user) {
             weakSell.currentUser = [User createFromDictionary:user andNetworkType : weakSell.networkType];
             weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
             //dispatch_async(dispatch_get_main_queue(), ^{
             weakSell.icon = [weakSell.currentUser.photoURL saveImageOfUserToDocumentsFolder:weakSell.currentUser.photoURL];
             //});
             
             
             weakSell.currentUser.photoURL = weakSell.icon;
             //weakSell.icon = weakSell.currentUser.photoURL;////
             if (!weakSell.isLogin)
                 [[DataBaseManager sharedManager] insertIntoTable:weakSell.currentUser];
             
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

- (void) updatePost {
    NSArray * posts = [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForPostWithReason:Connect andNetworkType:Twitters]];
    if (![self obtainCurrentConnection] || !posts.count || (![self obtainCurrentConnection] && posts.count)) {
        [self updatePostInfoNotification];
        return;
    }
    //    Post *post = posts[2];
//    [self obtainCountOfLikesAndCommentsFromPost:post];
    [posts enumerateObjectsUsingBlock:^(Post *post, NSUInteger idx, BOOL *stop) {
        [self obtainCountOfLikesAndCommentsFromPost:post];
    }];
    
    
}

- (void) obtainCountOfLikesAndCommentsFromPost :(Post*) post {
     //https://api.twitter.com/1.1/statuses/retweets/509457288717819904.json
    NSString *statusesShowEndpoint = musTwitterURL_Statuses_Show;
    
    //[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweets/%@.json",post.postID];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:post.postID,@"id",@"true",@"include_my_retweet",nil];//,@"100",@"count"
    NSError *clientError;
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    __weak TwitterNetwork *weakSelf = self;

    if (request) {
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSDictionary *arrayJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (!arrayJson.count) {
                    [weakSelf updatePostInfoNotification];
                    return;
                }
                if (post.likesCount == [[arrayJson  objectForKey:@"favorite_count"] integerValue] &&  post.commentsCount == [[arrayJson  objectForKey:@"retweet_count"] integerValue] ) {
                    [weakSelf updatePostInfoNotification];
                    return;
                }
                post.likesCount = [[arrayJson  objectForKey:@"favorite_count"] integerValue];
                post.commentsCount = [[arrayJson objectForKey:@"retweet_count"] integerValue];
                
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringPostsForUpdateWithObjectPost:post]];
                [weakSelf updatePostInfoNotification];
            }
            else {
                [weakSelf updatePostInfoNotification];
                NSLog(@"Error: %@", connectionError);
            }
        }];
    }
    else {
        [weakSelf updatePostInfoNotification];
        NSLog(@"Error: %@", clientError);
    }
}


#pragma mark - obtainArrayOfPlacesFromNetwork

- (void) obtainArrayOfPlaces : (Location*) location withComplition : (Complition) block {
    self.copyComplition = block;
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (!location.latitude || !location.longitude || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        
        NSError *error = [NSError errorWithMessage: musErrorLocationProperties
                                      andCodeError: musErrorLocationPropertiesCode];
        return block (nil, error);
    } else {
        params [musTwitterLocationParameter_Latitude] = location.latitude;
        params [musTwitterLocationParameter_Longituge] = location.longitude;
    }
    
    NSString *url = musTwitterURL_Geo_Search;
    
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod : musGET
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
                                 NSError *error = [NSError errorWithMessage: musErrorLocationDistance andCodeError: musErrorLocationDistanceCode];
                                 block (nil, error);
                             }
                         }else{
                             block (nil, [self errorTwitter]);
                         }
                         
                     }];
}



#pragma mark - sharePostToNetwork

- (void) sharePost:(Post *)post withComplition:(Complition)block {
    if (![self obtainCurrentConnection]){
        [self saveOrUpdatePost: post withReason: Offline];
        block(nil,[self errorConnection]);
        [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
        return;
    }
    
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
    
    NSString *url = musTwitterURL_Statuses_Update;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params [musTwitterParameter_Status] = post.postDescription;
    if (post.place.placeID) {
        params [musTwitterParameter_PlaceID] = post.place.placeID;
    }
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod : musPOST
                                                             URL : url
                                                      parameters : params
                                                           error : &error];
    
    [client sendTwitterRequest:preparedRequest
                    completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
                        if(!error){
                            NSError *jsonError = nil;

                            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                       options:NSJSONReadingMutableContainers
                                                                                         error:&jsonError];
                            if (jsonError) {
                                //[self errorTwitter];
                                self.copyComplition (nil, [self errorTwitter]);
                                [self saveOrUpdatePost: post withReason: ErrorConnection];
                                [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                                return;
                            }
                            post.postID = [[jsonData objectForKey:@"id"]stringValue];
                            self.copyComplition (musPostSuccess, nil);
                            [self saveOrUpdatePost: post withReason: Connect];
                            [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                        }else{
                            self.copyComplition (nil, [self errorTwitter]);
                            [self saveOrUpdatePost: post withReason: ErrorConnection];
                            [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                        }
                    }];
}

#pragma mark - postMessageWithImageAndLocation

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */

- (void) postImagesToTwitter : (Post*) post {
    
    [self mediaIdsForTwitter : post withComplition:^(id result, NSError *error) {
        
        if (!error) {
            NSArray *mediaIdsArray = (NSArray*) result;
            NSString *mediaIdsString = [mediaIdsArray componentsJoinedByString:@","];
            
            NSString *endpoint = musTwitterURL_Statuses_Update;
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            params [musTwitterParameter_MediaID] = mediaIdsString;
            if (post.postDescription) {
                params [musTwitterParameter_Status] = post.postDescription;
            }
            if (post.place.placeID) {
                params [musTwitterParameter_PlaceID] = post.place.placeID;
            }
            NSError *error = nil;
            
            TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
            NSURLRequest *request = [client URLRequestWithMethod: musPOST
                                                             URL: endpoint
                                                      parameters: params
                                                           error: &error];
            if (error) {
                self.copyComplition (nil, [self errorTwitter]);
                [self saveOrUpdatePost: post withReason: ErrorConnection];
                [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                return;
            }
            [client sendTwitterRequest : request
                            completion : ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                if (!connectionError) {
                                    
                                     NSError *jsonError = nil;

                                     NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                     options:NSJSONReadingMutableContainers
                                     error:&jsonError];
                                     if (jsonError) {
                                         self.copyComplition (nil, [self errorTwitter]);
                                         [self saveOrUpdatePost: post withReason: ErrorConnection];
                                         [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                                     return;
                                     }
                                    post.postID = [[jsonData objectForKey:@"id"] stringValue];
                                    self.copyComplition (musPostSuccess, nil);
                                    [self saveOrUpdatePost: post withReason: Connect];
                                    [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                                } else {
                                    NSError *connectionError = [NSError errorWithMessage: musErrorConnection
                                                                            andCodeError: musErrorConnectionCode];
                                    self.copyComplition (nil, connectionError);
                                    [self saveOrUpdatePost: post withReason: ErrorConnection];
                                    [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                                    return;
                                }
                            }];
        } else {
            self.copyComplition (nil, error);
            [self saveOrUpdatePost: post withReason: ErrorConnection];
            [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
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
    NSString *endpoint = musTwitterURL_Media_Upload;
    
    NSData* imageData = UIImageJPEGRepresentation(imageToPost.image, imageToPost.quality);
    
    NSDictionary *parameters = @{ musTwitterParameter_Media : [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed ]};
    NSError *error = nil;
    
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSURLRequest *request = [client URLRequestWithMethod : musPOST
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
                            NSString *mediaId = jsonData [musTwitterJSONParameterForMediaID];
                            block (mediaId, nil);
                        } else {
                            NSError *connectionError = [NSError errorWithMessage : musErrorConnection
                                                                    andCodeError : musErrorConnectionCode];
                            block (nil, connectionError);
                            return;
                        }
                    }];
}

/*!
 @abstract returned Twitter network error
 */
- (NSError*) errorTwitter {
    return [NSError errorWithMessage: musTwitterError andCodeError: musTwitterErrorCode];
}

- (void) updatePostInfoNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationPostsInfoWereUpDated object:nil];
}

@end
