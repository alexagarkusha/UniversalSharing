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
#import "MUSDatabaseRequestStringsHelper.h"
#import "InternetConnectionManager.h"
#import "NetworkPost.h"

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
            //[self updatePost];/////////////////////////////////////////////////////////////////////////////////////////////

            [self startTimerForUpdatePosts];
            self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForUsersWithNetworkType:self.networkType]]firstObject]; // obtainUsersWithNetworkType:self.networkType];
            self.icon = self.currentUser.photoURL;
            self.title = [NSString stringWithFormat:@"%@ %@", self.currentUser.firstName, self.currentUser.lastName];
            self.isVisible = self.currentUser.isVisible;
            NSInteger indexPosition = self.currentUser.indexPosition;
            //////////////////////////////////////////////////////////
            
            if ([[InternetConnectionManager manager] isInternetConnection]){
               
                NSString *deleteImageFromFolder = self.currentUser.photoURL;
                               
                [self obtainInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
                    [[NSFileManager defaultManager] removeItemAtPath: [deleteImageFromFolder obtainPathToDocumentsFolder:deleteImageFromFolder] error: nil];
                      result.currentUser.isVisible = self.isVisible;
                    result.currentUser.indexPosition = indexPosition;
                    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringUsersForUpdateWithObjectUser:result.currentUser]];//editUser:result.currentUser];
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
                [self startTimerForUpdatePosts];
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
        //weakSell.currentUser.indexPosition = 0;
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
                //place.latitude = location.latitude;
                //place.longitude = location.longitude;
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
    // Create object NETWORKPOST
    
    
    if (![[InternetConnectionManager manager] isInternetConnection]){
        NetworkPost *networkPost = [[NetworkPost alloc] init];
        networkPost.networkType = Facebook;
        networkPost.reason = Offline;
        // Return Result - object NetworkPost with reason = offline, Error - internet Connection
        block(networkPost,[self errorConnection]);
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
    NetworkPost *networkPost = [[NetworkPost alloc] init];
    networkPost.networkType = Facebook;
    __block NetworkPost *networkPostCopy = networkPost;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[musFacebookParameter_Message] = post.postDescription;
    
    if (post.place.placeID) {
        params[ musFacebookParameter_Place ] = post.place.placeID;
    }
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath: musFacebookGraphPath_Me_Feed
                                       parameters: params
                                       HTTPMethod: musPOST]
     startWithCompletionHandler:
     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             networkPostCopy.reason = Connect;
             networkPostCopy.postID = [result objectForKey: @"id" ];
             self.copyComplition (networkPostCopy, nil);
         } else {
             networkPostCopy.reason = ErrorConnection;
             if ([error code] != 8){
                 self.copyComplition (networkPostCopy, [self errorFacebook]);
             } else {
                 self.copyComplition (networkPostCopy, [self errorFacebook]);
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
    if (post.place.placeID)  {
        params[musFacebookParameter_Place] = post.place.placeID;
    }
    
    __block int numberOfPostImagesArray = post.arrayImages.count;
    __block int counterOfImages = 0;
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = Facebook;
    __block NetworkPost *networkPostCopy = networkPost;

    for (int i = 0; i < post.arrayImages.count; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];
        params[musFacebookParameter_Picture] = imageToPost.image;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: musFacebookGraphPath_Me_Photos
                                             parameters: params
                                             HTTPMethod: musPOST];
        [connection addRequest: request
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 counterOfImages ++;
                 
                 if (!error) {
                     networkPostCopy.postID = [networkPostCopy.postID stringByAppendingString:[result objectForKey:@"id"]];
                     
                     if (counterOfImages == numberOfPostImagesArray) {
                         networkPostCopy.reason = Connect;
                         self.copyComplition (networkPostCopy, nil);
                     }
                     networkPostCopy.postID = [networkPostCopy.postID stringByAppendingString: @","];
                 } else {
                     if (counterOfImages == numberOfPostImagesArray) {
                         networkPostCopy.reason = ErrorConnection;
                         self.copyComplition (networkPostCopy, [self errorFacebook]);
                     }
                 }
        }];
    }
    [connection start];
}

- (void) updatePost {
#warning NEED TO GET ARRAY OF NETWORKPOSTS AND THEN UPDATE;
    //NSArray * posts = [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForPostWithReason:Connect andNetworkType:Facebook]];
    
    NSArray * networksPostsIDs = [[DataBaseManager sharedManager] obtainNetworkPostsFromDataBaseWithRequestStrings: [MUSDatabaseRequestStringsHelper createStringForNetworkPostWithReason: Connect andNetworkType: Facebook]];
                                  
    if (![[InternetConnectionManager manager] isInternetConnection] || !networksPostsIDs.count  || (![[InternetConnectionManager manager] isInternetConnection] && networksPostsIDs.count)) {
        [self updatePostInfoNotification];
        return;
    }
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];

    [networksPostsIDs enumerateObjectsUsingBlock:^(NetworkPost *networkPost, NSUInteger index, BOOL *stop) {
        
        NSArray *arrayOfIdPost = [networkPost.postID componentsSeparatedByString: @","];

        [self obtainNumberOfLikesForArrayOfPostId: arrayOfIdPost andConnection : connection withComplition:^(id result, NSError *error) {
            
            if (!error) {
                if (networkPost.likesCount == [result integerValue]) {
                    return;
                }
                networkPost.likesCount = [result integerValue];
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringNetworkPostsForUpdateWithObjectPost : networkPost]];
            }
        }];
        
        [self obtainNumberOfCommentsForArrayOfPostId: arrayOfIdPost andConnection : connection withComplition:^(id result, NSError *error) {
            NSLog (@"result = %ld", (long)[result integerValue]);
            if (!error) {
                if (networkPost.commentsCount == [result integerValue]) {
                    return;
                }
                networkPost.commentsCount = [result integerValue];
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringNetworkPostsForUpdateWithObjectPost : networkPost]];
            }
        }];
    }];
    if (networksPostsIDs.count) {
        connection.delegate = self;
        [connection start];
    }
}


- (void) obtainNumberOfLikesForArrayOfPostId : (NSArray*) arrayOfIdPost andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    __block int numberOfLikes;
    __block int sumOfLikes = 0;
    __block int counterOfLikes = 0;
    __block long numberOfIds = arrayOfIdPost.count;
    
    for (int i = 0; i < arrayOfIdPost.count; i++) {
        [self obtainCountOfLikesFromPost: [arrayOfIdPost objectAtIndex: i] andConnection:connection withComplition:^(id result, NSError *error) {
            counterOfLikes++;
            numberOfLikes = [result intValue];
            sumOfLikes += numberOfLikes;
            if (counterOfLikes == numberOfIds) {
                if (!error) {
                    block ([NSNumber numberWithInt: sumOfLikes], nil);
                }
            }
        }];
    }
}

- (void) obtainNumberOfCommentsForArrayOfPostId : (NSArray*) arrayOfIdPost andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    
    __block int numberOfComments;
    __block int sumOfComments = 0;
    __block int counterOfComments = 0;
    __block long numberOfIds = arrayOfIdPost.count;
    
    for (int i = 0; i < arrayOfIdPost.count; i++) {
        [self obtainCountOfCommentsFromPost: [arrayOfIdPost objectAtIndex: i] andConnection:connection withComplition:^(id result, NSError *error) {
            counterOfComments ++;
            numberOfComments = [result intValue];
            sumOfComments += numberOfComments;
            if (counterOfComments == numberOfIds) {
                if (!error) {
                    block ([NSNumber numberWithInt: sumOfComments], nil);
                }
            }
        }];
    }
}

- (void) obtainCountOfLikesFromPost :(NSString*) postID andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: postID,@"ObjectId",@"true",@"summary",nil];
    NSString *stringPath = [NSString stringWithFormat:@"/%@/likes",postID];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath: stringPath
                                                                  parameters: params
                                                                  HTTPMethod: musGET];
    [connection addRequest:request
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {
            
             block ([[result objectForKey:@"summary"]objectForKey:@"total_count"], nil);
             
         }];
    
}
- (void)requestConnectionDidFinishLoading:(FBSDKGraphRequestConnection *)connection {
    [self updatePostInfoNotification];
}

- (void) obtainCountOfCommentsFromPost :(NSString*) postID andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: postID,@"ObjectId",@"true",@"summary",nil];
    NSString *stringPath = [NSString stringWithFormat:@"/%@/comments", postID];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath: stringPath
                                                                   parameters: params
                                                                   HTTPMethod: musGET];
    [connection addRequest:request
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {

            block ([[result objectForKey:@"summary"]objectForKey:@"total_count"], nil);
             
         }];
}

/*!
 @abstract returned Facebook network error
 */

- (NSError*) errorFacebook {
    return [NSError errorWithMessage: musFacebookError andCodeError: musFacebookErrorCode];
}


- (void) updatePostInfoNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationPostsInfoWereUpDated object:nil];
}

/*
-(void) postPhotosToAlbum:(Post *) post {
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[musFacebookParameter_Message] = post.postDescription;
    if (post.place.placeID)  {
        params[musFacebookParameter_Place] = post.place.placeID;
    }
    
    // __weak NSArray *copyPostImagesArray = post.arrayImages;
    __block int numberOfPostImagesArray = post.arrayImages.count;
    __block int counterOfImages = 0;
    for (int i = 0; i < post.arrayImages.count; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];
        params[musFacebookParameter_Picture] = imageToPost.image;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: musFacebookGraphPath_Me_Photos
                                      parameters: params
                                      HTTPMethod: musPOST];
        
        post.postID = @"";
        
        NetworkPost *networkPost = [NetworkPost create];
        __block NetworkPost *networkPostCopy = networkPost;
        
        
        
        [connection addRequest: request
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 counterOfImages ++;
                 
                 if (!error) {
                     post.postID = [post.postID stringByAppendingString:[result objectForKey:@"id"]];
                     
                     if (counterOfImages == numberOfPostImagesArray) {
                         networkPost.reason = Connect;
                         networkPost.postID = post.postID;
                         
                         self.copyComplition (musPostSuccess, nil);
                         [self saveOrUpdatePost: post withReason: Connect];
                         [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                     }
                     post.postID = [post.postID stringByAppendingString: @","];
                 } else {
                     if (counterOfImages == numberOfPostImagesArray) {
                         [self saveOrUpdatePost: post withReason: ErrorConnection];
                         self.copyComplition (nil, [self errorFacebook]);
                         [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
                     }
                 }
             }];
    }
    [connection start];
}
*/

@end
