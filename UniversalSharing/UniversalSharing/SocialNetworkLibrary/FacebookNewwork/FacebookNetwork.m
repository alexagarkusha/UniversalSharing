//
//  FacebookManager.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "FacebookNetwork.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "Place.h"
#import "NSError+MUSError.h"

@interface FacebookNetwork()<FBSDKGraphRequestConnectionDelegate>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) NSString *firstPlaceId;

@end

static FacebookNetwork *model = nil;

#pragma mark Singleton Method

@implementation FacebookNetwork
+ (FacebookNetwork*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[FacebookNetwork alloc] init];
    });
    return  model;
}

/*!
 Initiation FacebookNetwork.
*/

- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkType = Facebook;
        if (![FBSDKAccessToken currentAccessToken]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
        }
    }
    return self;
}

/*!
 Initiation properties of FacebookNetwork without session
 */

- (void) initiationPropertiesWithoutSession {
    self.title = musFacebookTitle;
    self.icon = musFacebookIconName;
    self.isLogin = NO;
    self.currentUser = nil;
}

#pragma mark - loginInNetwork

- (void) loginWithComplition :(Complition) block {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    self.isLogin = YES;
    
    __weak FacebookNetwork *weakSell = self;
    [login logInWithReadPermissions:@[musFacebookPermission_Email] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            block(nil, [self errorFacebook]);
        } else if (result.isCancelled) {
            NSError *accessError = [NSError errorWithMessage: musErrorAccesDenied andCodeError:musErrorAccesDeniedCode];
            block(nil, accessError);
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject: musFacebookPermission_Email]) {
                [weakSell obtainInfoFromNetworkWithComplition:block];
            }
        }
    }];
}


- (void) loginOut {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [self initiationPropertiesWithoutSession];
}




#pragma mark - obtainUserFromNetwork

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
    __weak FacebookNetwork *weakSell = self;
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath: musFacebookGraphPath_Me
                                                                  parameters: @{ musFacebookParameter_Fields: musFacebookParametrsRequest}
                                                                  HTTPMethod: musGET];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        weakSell.currentUser = [User createFromDictionary:result andNetworkType : weakSell.networkType];
        weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
        weakSell.icon = weakSell.currentUser.photoURL;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(weakSell,nil);
        });
    }];
}

#pragma mark - obtainArrayOfPlacesFromNetwork

- (void) obtainArrayOfPlaces: (Location *)location withComplition: (Complition) block {
    if (!location.q || !location.latitude || !location.longitude || !location.distance || [location.longitude floatValue] < -90.0f || [location.longitude floatValue] > 90.0f || [location.latitude floatValue] < -180.0f  || [location.latitude floatValue] > 180.0f) {
        
        NSError *error = [NSError errorWithMessage: musErrorLocationProperties andCodeError: musErrorLocationPropertiesCode];
        return block (nil, error);
    }
    
    NSString *currentLocation = [NSString stringWithFormat:@"%@,%@", location.latitude, location.longitude];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[musFacebookLoactionParameter_Q] = location.q;
    params[musFacebookLoactionParameter_Type] = location.type;
    params[musFacebookLoactionParameter_Center] = currentLocation;
    params[musFacebookLoactionParameter_Distance] = location.distance;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:  musFacebookGraphPath_Search
                                                                   parameters:  params
                                                                   HTTPMethod:  musGET];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (result) {
            NSDictionary *placesDictionary = result;
            NSArray *places = [placesDictionary objectForKey: musFacebookKeyOfPlaceDictionary];
            NSMutableArray *placesArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < places.count; i++) {
                Place *place = [Place createFromDictionary: [places objectAtIndex: i] andNetworkType:self.networkType];
                [placesArray addObject:place];
            }
            
            if (placesArray.count != 0) {
                block (placesArray, nil);
            }   else {
                NSError *error = [NSError errorWithMessage: musErrorLocationDistance andCodeError: musErrorLocationDistanceCode];
                block (nil, error);
            }
        } else {
            block (nil, [self errorFacebook]);
        }
    }];
}

#pragma mark - sharePost

- (void) sharePost:(Post *)post withComplition:(Complition)block {
    self.copyComplition = block;
    if ([[FBSDKAccessToken currentAccessToken] hasGranted: musFacebookPermission_Publish_Actions]) {
        [self sharePostToFacebook: post];
    } else {
        
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[musFacebookPermission_Publish_Actions] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                [self sharePostToFacebook: post];
            } else {
                self.copyComplition (nil, [self errorFacebook]);
            }
        }];
    }
}

/*!
 @abstract upload message or photos to social network
 @param current post of @class Post
 */

- (void) sharePostToFacebook : (Post*) post {
    if (post.arrayImages.count > 0) {
        [self postPhotosToAlbum: post];
    } else {
        [self postMessageToFB: post];
    }
}

#pragma mark - postMessageToFB

/*!
 @abstract upload message and user location (optional)
 @param current post of @class Post
 */

- (void) postMessageToFB : (Post*) post {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[musFacebookParameter_Message] = post.postDescription;
    
    if (post.placeID) params[ musFacebookParameter_Place ] = post.placeID;

    [[[FBSDKGraphRequest alloc] initWithGraphPath: musFacebookGraphPath_Me_Feed
                                       parameters: params
                                       HTTPMethod: musPOST]
                       startWithCompletionHandler:
     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.copyComplition (musPostSuccess, nil);
         } else {
             self.copyComplition (nil, [self errorFacebook]);
         }
     }];
}

#pragma mark - postPhotosToFBAlbum

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */

-(void) postPhotosToAlbum:(Post *) post {
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[musFacebookParameter_Message] = post.postDescription;
    if (post.placeID)  {
        params[musFacebookParameter_Place] = post.placeID;
    }
    
    for (int i = 0; i < post.arrayImages.count; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];
        params[musFacebookParameter_Picture] = imageToPost.image;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath: musFacebookGraphPath_Me_Photos
                                                                       parameters: params
                                                                       HTTPMethod: musPOST];
        [connection addRequest: request
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     self.copyComplition (musPostSuccess, nil);
                 } else {
                     self.copyComplition (nil, [self errorFacebook]);
                 }
             }];
    }
    [connection start];
}

/*!
 @abstract returned Facebook network error
 */

- (NSError*) errorFacebook {
    return [NSError errorWithMessage: musFacebookError andCodeError: musFacebookErrorCode];
}



@end
