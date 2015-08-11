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

@interface TwitterNetwork () //<TWTRCoreOAuthSigning>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;

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
    [TwitterKit startWithConsumerKey:musTwitterConsumerKey consumerSecret:musTwitterConsumerSecret];
    [Fabric with : @[TwitterKit] ];
    if (self) {
        self.networkType = Twitters;
        if (![[Twitter sharedInstance ]session]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
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
    self.currentUser = nil;
}

#pragma mark - loginInNetwork

/*!
 Triggers user authentication with Twitter.
 This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
 @param completion The completion block will be called after authentication is successful or if there is an error.
*/

- (void) loginWithComplition :(Complition) block {
    
    __weak TwitterNetwork *weakSell = self;
    
    [TwitterKit logInWithCompletion:^(TWTRSession* session, NSError* error) {
        if (session) {
            self.isLogin = YES;
            [weakSell obtainInfoFromNetworkWithComplition:block];
        } else {
            block(nil, error);
        }
    }];
}

#pragma mark - loginOut

/*!
 Deletes the local Twitter user session from this app. This will not remove the system Twitter account and make a network request to invalidate the session.
 Current user for social network become nil
 And initiation properties of VKNetwork without session
 */

- (void) loginOut {
    [[Twitter sharedInstance] logOut];
    [self initiationPropertiesWithoutSession];
}


#pragma mark - obtainUserFromNetwork

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSell = self;

    [[TwitterKit APIClient] loadUserWithID : [[[Twitter sharedInstance ]session] userID]
                                              completion:^(TWTRUser *user, NSError *error)
     {
         if (user) {
             weakSell.currentUser = [User createFromDictionary : user
                                                andNetworkType : weakSell.networkType];
             
             weakSell.title = [NSString stringWithFormat:@"%@  %@",
                                        weakSell.currentUser.firstName, weakSell.currentUser.lastName];
             
             weakSell.icon = weakSell.currentUser.photoURL;
             dispatch_async(dispatch_get_main_queue(), ^{
                 block (weakSell, nil);
             });
         } else {
             block (nil, [self errorTwitter]);
         }
    }];
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
    if (post.placeID) {
        params [musTwitterParameter_PlaceID] = post.placeID;
    }

    NSURLRequest *preparedRequest = [client URLRequestWithMethod : musPOST
                                                             URL : url
                                                      parameters : params
                                                           error : &error];
    
    [client sendTwitterRequest:preparedRequest
                    completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
        if(!error){
            self.copyComplition (musPostSuccess, nil);
        }else{
            self.copyComplition (nil, [self errorTwitter]);
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
            if (post.placeID) {
                params [musTwitterParameter_PlaceID] = post.placeID;
            }
            NSError *error = nil;
            
            TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
            NSURLRequest *request = [client URLRequestWithMethod: musPOST
                                                             URL: endpoint
                                                      parameters: params
                                                           error: &error];
            if (error) {
                self.copyComplition (nil, [self errorTwitter]);
                return;
            }
            [client sendTwitterRequest : request
                            completion : ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (!connectionError) {
                        /*
                         NSError *jsonError = nil;
                         id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:&jsonError];
                                if (jsonError) {
                                     [self errorTwitter];
                                     return;
                                }
                        */
                        self.copyComplition (musPostSuccess, nil);
                    } else {
                        NSError *connectionError = [NSError errorWithMessage: musErrorConnection
                                                                andCodeError: musErrorConnectionCode];
                        self.copyComplition (nil, connectionError);
                        return;
                    }
            }];
        } else {
            self.copyComplition (nil, error);
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
    for (int i = 0; i < post.arrayImages.count; i++) {
        [self mediaIDForTwitter : [post.arrayImages objectAtIndex: i] withComplition:^(id result, NSError *error) {
            if (!error) {
                [array addObject: result];
                if ([array count] == post.arrayImages.count) {
                    block (mediaIdsArray, nil);
                }
            } else {
                block (nil, [self errorTwitter]);
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
                self.copyComplition (nil, connectionError);
                return;
            }
     }];
}

/*!
 @abstract returnув Twitter network error
 */
- (NSError*) errorTwitter {
    return [NSError errorWithMessage: musFacebookError andCodeError: musFacebookErrorCode];
}

@end
