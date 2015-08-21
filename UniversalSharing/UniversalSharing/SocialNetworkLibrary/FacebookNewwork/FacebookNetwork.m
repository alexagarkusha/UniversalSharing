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
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"

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
        self.name = musFacebookName;
        if (![FBSDKAccessToken currentAccessToken]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
            
            self.currentUser = [[DataBaseManager sharedManager]obtainRowsFromTableNamedUsersWithNetworkType:self.networkType];
            self.icon = self.currentUser.photoURL;
            self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
            self.isVisible = self.currentUser.isVisible;
            //////////////////////////////////////////////////////////
            
            if ([self obtainCurrentConnection]){
               
                NSString *deleteImageFromFolder = self.currentUser.photoURL;
                               
                [self obtainInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
                    [[NSFileManager defaultManager] removeItemAtPath: [deleteImageFromFolder obtainPathToDocumentsFolder:deleteImageFromFolder] error: nil];
                      result.currentUser.isVisible = self.isVisible;
                    [[DataBaseManager sharedManager] editUserByClientIdAndNetworkType:result.currentUser];
                }];
            }
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
    self.isVisible = YES;
    self.currentUser = nil;
}

#pragma mark - loginInNetwork

- (void) loginWithComplition :(Complition) block {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    
    __weak FacebookNetwork *weakSell = self;
    [login logInWithReadPermissions:@[musFacebookPermission_Email] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            block(nil, [self errorFacebook]);
        } else if (result.isCancelled) {
            NSError *accessError = [NSError errorWithMessage: musErrorAccesDenied andCodeError:musErrorAccesDeniedCode];
            block(nil, accessError);
        } else {
           
            weakSell.isVisible = YES;
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject: musFacebookPermission_Email]) {
                [weakSell obtainInfoFromNetworkWithComplition:block];
            }
        }
    }];
}


- (void) loginOut {
    [self removeUserFromDataBaseAndImageFromDocumentsFolder:self.currentUser];
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
        //dispatch_async(dispatch_get_main_queue(), ^{
        weakSell.icon = [weakSell.currentUser.photoURL saveImageOfUserToDocumentsFolder:weakSell.currentUser.photoURL];
        //});
        
        
        weakSell.currentUser.photoURL = weakSell.icon;
        //weakSell.icon = weakSell.currentUser.photoURL;////
        if (!weakSell.isLogin) {
             [[DataBaseManager sharedManager] insertIntoTable:weakSell.currentUser];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
             weakSell.isLogin = YES;
            block(weakSell,nil);
        });
    }];
}

#pragma mark - obtainArrayOfPlacesFromNetwork

- (void) obtainArrayOfPlaces: (Location *)location withComplition: (Complition) block {
    if (!location.q || !location.latitude || !location.longitude || !location.distance || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        
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
    
    if (![self obtainCurrentConnection]){
        [self savePostDataBaseWithReason:Offline andPost:post];
        block(nil,[self errorConnection]);
        return;
    }
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
             [self savePostDataBaseWithReason:Connect andPost:post];

         } else {
             if ([error code] != 8){
                 [self savePostDataBaseWithReason:ErrorConnection andPost:post];
                 self.copyComplition (nil, [self errorFacebook]);
             }
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
    
    __weak NSArray *copyPostImagesArray = post.arrayImages;
    __block int counterOfImages = 0;
    for (int i = 0; i < post.arrayImages.count; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];
        params[musFacebookParameter_Picture] = imageToPost.image;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath: musFacebookGraphPath_Me_Photos
                                                                       parameters: params
                                                                       HTTPMethod: musPOST];
        //counterOfImages ++;
        [connection addRequest: request
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 counterOfImages ++;
                 if (counterOfImages == copyPostImagesArray.count) {
                     if (!error) {
                         self.copyComplition (musPostSuccess, nil);
                         [self savePostDataBaseWithReason:Connect andPost:post];
                     } else {
                         [self savePostDataBaseWithReason:ErrorConnection andPost:post];
                         self.copyComplition (nil, [self errorFacebook]);
                     }
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
