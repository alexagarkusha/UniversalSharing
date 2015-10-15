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
#import "MUSPlace.h"
#import "NSError+MUSError.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "MUSInternetConnectionManager.h"
#import "MUSNetworkPost.h"
#import "NSString+MUSCurrentDate.h"
#import "MUSPostManager.h"
#import <FBSDKCoreKit/FBSDKMacros.h>
#import "MUSConstantsForParseSocialNetworkObjects.h"
#import "MUSConstantsForSocialNetworks.h"
#import "MUSPostManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "MUSDataBaseManager.h"

@interface FacebookNetwork()<FBSDKGraphRequestConnectionDelegate>

@property (copy, nonatomic) Complition copyComplition;
@property (copy, nonatomic) UpdateNetworkPostsBlock updateNetworkPostsBlock;
@property (copy, nonatomic) LoadingBlock loadingBlock;

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

/*
 Getters
 */

- (NSString *)icon {
    return MUSFacebookIconName;
}

- (NSString *)title {
    return self.isLogin ? [NSString stringWithFormat:@"%@ %@", self.currentUser.firstName, self.currentUser.lastName] : MUSFacebookTitle;
}

/*!
 Initiation FacebookNetwork.
 */
- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkType = MUSFacebook;
        self.name = MUSFacebookName;
        if (![FBSDKAccessToken currentAccessToken]) {
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
 Initiation properties of FacebookNetwork with session
 */
- (void) initiationPropertiesWithSession {
    self.isLogin = YES;
    //self.currentUser = [[[MUSDataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUserWithNetworkType: self.networkType]]firstObject];
    //self.title = [NSString stringWithFormat:@"%@ %@", self.currentUser.firstName, self.currentUser.lastName];
}

/*!
 Initiation properties of FacebookNetwork without session
 */
- (void) initiationPropertiesWithoutSession {
    //self.title = MUSFacebookTitle;
    self.isLogin = NO;
    //self.currentUser = nil;
}

#pragma mark - login

- (void) loginWithComplition :(Complition) block {
    __weak FacebookNetwork *weakSelf = self;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];    
    [login logInWithReadPermissions: @[MUSFacebookPermission_Email] fromViewController: nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            block(nil, [weakSelf errorFacebook]);
        } else if (result.isCancelled) {
            NSError *accessError = [NSError errorWithMessage: MUSAccessError andCodeError:MUSAccessErrorCode];
            block(nil, accessError);
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject: MUSFacebookPermission_Email]) {
                [weakSelf obtainUserInfoFromNetworkWithComplition:block];
            }
        }
    }];
}

#pragma mark - logout

- (void) logout {
    [[MUSPostManager manager] deleteNetworkPostForNetworkType: self.networkType];
    [self.currentUser removeUser];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [self initiationPropertiesWithoutSession];
}


#pragma mark - obtainUserInfoFromNetwork

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
    __weak FacebookNetwork *weakSelf = self;
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath: MUSFacebookGraphPath_Me
                                                                  parameters: @{ MUSFacebookParameter_Fields: MUSFacebookParametrsRequest}
                                                                  HTTPMethod: MUSGET];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        [weakSelf createUser: result];
        weakSelf.title = [NSString stringWithFormat:@"%@  %@", weakSelf.currentUser.firstName, weakSelf.currentUser.lastName];
        if (!weakSelf.isLogin) {            
            [weakSelf.currentUser insertIntoDataBase];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isLogin = YES;
            block(weakSelf, nil);
        });
    }];
}


#pragma mark - sharePost

- (void) sharePost: (MUSPost *)post withComplition:(Complition)block loadingBlock:(LoadingBlock)loadingBlock {
    
    if (![[MUSInternetConnectionManager connectionManager] isInternetConnection]){
        MUSNetworkPost *networkPost = [MUSNetworkPost create];
        networkPost.networkType = MUSFacebook;
        block(networkPost,[self errorConnection]);
        return;
    }
    self.copyComplition = block;
    self.loadingBlock = loadingBlock;
    if ([[FBSDKAccessToken currentAccessToken] hasGranted: MUSFacebookPermission_Publish_Actions]) {
        [self sharePostToFacebookNetwork: post];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions: @[MUSFacebookPermission_Publish_Actions] fromViewController: nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                [self sharePostToFacebookNetwork: post];
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

- (void) sharePostToFacebookNetwork : (MUSPost*) post  {
    __block MUSPost *postCopy = post;
    __weak FacebookNetwork *weakSelf = self;
    
    if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
        MUSLocation *location = [self createLocationForPost: post];
        [self obtainPlacesArrayForLocation: location withComplition:^(id result, NSError *error) {
            if (!error) {
                MUSPlace *firstPlace = (MUSPlace*) [result firstObject];
                if (firstPlace) {
                    postCopy.place = firstPlace;
                }
            }
            [weakSelf sharePost: postCopy];
        }];
    } else {
        [self sharePost: post];
    }
}

- (void) sharePost : (MUSPost*) post {
    if (post.imagesArray.count) {
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

- (void) sharePostOnlyWithPostDescription : (MUSPost*) post {
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    connection.delegate = self;
    MUSNetworkPost *networkPost = [MUSNetworkPost create];
    networkPost.networkType = MUSFacebook;
    __block MUSNetworkPost *networkPostCopy = networkPost;
    __weak FacebookNetwork *weakSelf = self;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[MUSFacebookParameter_Message] = post.postDescription;
    
    if (post.place.placeID) {
        params[MUSFacebookParameter_Place] = post.place.placeID;
    }
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath: MUSFacebookGraphPath_Me_Feed
                                  parameters: params
                                  HTTPMethod: MUSPOST];
    
    [connection addRequest:request completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            networkPostCopy.reason = MUSConnect;
            networkPostCopy.dateCreate = [NSString currentDate];
            networkPostCopy.postID = [result objectForKey: MUSFacebookParseNetworkPost_ID];
            weakSelf.copyComplition (networkPostCopy, nil);
        } else {
            networkPostCopy.reason = MUSErrorConnection;
            if ([error code] != 8){
                weakSelf.copyComplition (networkPostCopy, [self errorFacebook]);
            } else {
                weakSelf.copyComplition (networkPostCopy, [self errorFacebook]);
            }
        }
        
    }];
    [connection start];
}

#pragma mark - sharePostWithPictures

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */
-(void) sharePostWithPictures: (MUSPost *) post {
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    connection.delegate = self;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[MUSFacebookParameter_Message] = post.postDescription;
    if (post.place.placeID)  {
        params[MUSFacebookParameter_Place] = post.place.placeID;
    }
    __block NSInteger numberOfPostImagesArray = post.imagesArray.count;
    __block int counterOfImages = 0;
    __weak FacebookNetwork *weakSelf = self;

    MUSNetworkPost *networkPost = [MUSNetworkPost create];
    networkPost.networkType = MUSFacebook;
    __block MUSNetworkPost *networkPostCopy = networkPost;
    
    for (int i = 0; i < post.imagesArray.count; i++) {
        MUSImageToPost *imageToPost = [post.imagesArray objectAtIndex: i];
        params[MUSFacebookParameter_Picture] = imageToPost.image;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: MUSFacebookGraphPath_Me_Photos
                                      parameters: params
                                      HTTPMethod: MUSPOST];
        [connection addRequest: request
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 counterOfImages ++;
                 
                 if (!error) {
                     networkPostCopy.postID = [networkPostCopy.postID stringByAppendingString:[result objectForKey:@"id"]];
                     
                     if (counterOfImages == numberOfPostImagesArray) {
                         networkPostCopy.reason = MUSConnect;
                         networkPostCopy.dateCreate = [NSString currentDate];
                         weakSelf.copyComplition (networkPostCopy, nil);
                     }
                     networkPostCopy.postID = [networkPostCopy.postID stringByAppendingString: @","];
                 } else {
                     if (counterOfImages == numberOfPostImagesArray) {
                         networkPostCopy.reason = MUSErrorConnection;
                         weakSelf.copyComplition (networkPostCopy, [self errorFacebook]);
                     }
                 }
             }];
    }
    [connection start];
}

#pragma mark - obtainPlacesArrayForLocation

- (void) obtainPlacesArrayForLocation: (MUSLocation *)location withComplition: (Complition) block {
    if (!location.q || !location.latitude || !location.longitude || !location.distance || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        NSError *error = [NSError errorWithMessage: MUSLocationPropertiesError andCodeError: MUSLocationPropertiesErrorCode];
        return block (nil, error);
    }
    
    NSString *currentLocation = [NSString stringWithFormat:@"%@,%@", location.latitude, location.longitude];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[MUSFacebookLocationParameter_Q] = location.q;
    params[MUSFacebookLocationParameter_Type] = location.type;
    params[MUSFacebookLocationParameter_Center] = currentLocation;
    params[MUSFacebookLocationParameter_Distance] = location.distance;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:  MUSFacebookGraphPath_Search
                                                                   parameters:  params
                                                                   HTTPMethod:  MUSGET];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (result) {
            NSDictionary *placesDictionary = result;
            NSArray *places = [placesDictionary objectForKey: MUSFacebookKeyOfPlaceDictionary];
            NSMutableArray *placesArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < places.count; i++) {
                MUSPlace *place = [self createPlace: [places objectAtIndex: i]];
                [placesArray addObject:place];
            }
            
            if (placesArray.count != 0) {
                block (placesArray, nil);
            }   else {
                NSError *error = [NSError errorWithMessage: MUSLocationDistanceError andCodeError: MUSLocationDistanceErrorCode];
                block (nil, error);
            }
        } else {
            block (nil, [self errorFacebook]);
        }
    }];
}

#pragma mark - UpdateNetworkPost

- (void) updateNetworkPostWithComplition : (UpdateNetworkPostsBlock) updateNetworkPostsBlock {
    self.updateNetworkPostsBlock = updateNetworkPostsBlock;
    NSArray * networksPostsIDs = [[MUSPostManager manager] networkPostsArrayForNetworkType: self.networkType];
    
    if (![[MUSInternetConnectionManager connectionManager] isInternetConnection] || !networksPostsIDs.count  || (![[MUSInternetConnectionManager connectionManager] isInternetConnection] && networksPostsIDs.count)) {
        updateNetworkPostsBlock (MUSFacebookError);
        return;
    }
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [networksPostsIDs enumerateObjectsUsingBlock:^(MUSNetworkPost *networkPost, NSUInteger index, BOOL *stop) {
        
        NSArray *arrayOfIdPost = [networkPost.postID componentsSeparatedByString: @","];
        [self obtainNumberOfLikesForPostIdsArray: arrayOfIdPost andConnection : connection withComplition:^(id result, NSError *error) {
            if (!error) {
                if (networkPost.likesCount == [result integerValue]) {
                    return;
                }
                networkPost.likesCount = [result integerValue];
                [networkPost update];
            } else {
                NSLog(@"ERROR");
            }
            
        }];
        
        [self obtainNumberOfCommentsForPostIdsArray: arrayOfIdPost andConnection : connection withComplition:^(id result, NSError *error) {
            if (!error) {
                if (networkPost.commentsCount == [result integerValue]) {
                    return;
                }
                networkPost.commentsCount = [result integerValue];
                [networkPost update];
            } else {
                NSLog(@"ERROR");
            }
        }];
    }];
    if (networksPostsIDs.count) {
        connection.delegate = self;
        [connection start];
    }
}

#pragma mark - obtainNumberOfLikesForArrayOfPostId

- (void) obtainNumberOfLikesForPostIdsArray : (NSArray*) arrayOfIdPost andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
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

#pragma mark - obtainCountOfLikesFromPost

- (void) obtainCountOfLikesFromPost :(NSString*) postID andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: postID, MUSFacebookParameter_ObjectId, MUSFacebookParameter_True, MUSFacebookParameter_Summary,nil];
    NSString *stringPath = [NSString stringWithFormat:@"/%@/%@", postID, MUSFacebookParameter_Likes];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath: stringPath
                                                                  parameters: params
                                                                  HTTPMethod: MUSGET];
    [connection addRequest:request
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {
    
             block ([[result objectForKey:MUSFacebookParameter_Summary]objectForKey:MUSFacebookParameter_Total_Count], nil);
    }];
}

#pragma mark - obtainNumberOfCommentsForPostIdsArray

- (void) obtainNumberOfCommentsForPostIdsArray : (NSArray*) arrayOfIdPost andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    
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

#pragma mark - obtainCountOfCommentsFromPost

- (void) obtainCountOfCommentsFromPost :(NSString*) postID andConnection:(FBSDKGraphRequestConnection*)connection withComplition : (Complition) block {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: postID, MUSFacebookParameter_ObjectId, MUSFacebookParameter_True, MUSFacebookParameter_Summary,nil];
    NSString *stringPath = [NSString stringWithFormat:@"/%@/%@", postID, MUSFacebookParameter_Comments];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath: stringPath
                                                                  parameters: params
                                                                  HTTPMethod: MUSGET];
    
    [connection addRequest:request
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {
             
             block ([[result objectForKey:MUSFacebookParameter_Summary]objectForKey:MUSFacebookParameter_Total_Count], nil);
             
         }];
}

#pragma mark - FBSDKGraphRequestConnectionDelegate

- (void) requestConnection:	(FBSDKGraphRequestConnection *)connection didSendBodyData:	(NSInteger)bytesWritten totalBytesWritten:	(NSInteger)totalBytesWritten totalBytesExpectedToWrite:	(NSInteger)totalBytesExpectedToWrite {

    if (self.loadingBlock) {
        self.loadingBlock ([NSNumber numberWithInteger: self.networkType], (float)totalBytesWritten / totalBytesExpectedToWrite);
    }
}

- (void) requestConnectionWillBeginLoading:(FBSDKGraphRequestConnection *)connection {
    
}

- (void)requestConnectionDidFinishLoading:(FBSDKGraphRequestConnection *)connection {
    if (self.updateNetworkPostsBlock) {
        self.updateNetworkPostsBlock (MUSFacebookSuccessUpdateNetworkPost);
    }
}

#pragma mark - errorFacebook

/*!
 @abstract returned Facebook network error
 */

- (NSError*) errorFacebook {
    return [NSError errorWithMessage: MUSFacebookError andCodeError: MUSFacebookErrorCode];
}

#pragma mark - createUser

/*!
 @abstract an instance of the User for facebook network.
 @param dictionary takes dictionary from facebook network.
 */
- (void) createUser : (NSDictionary*) result {
    self.currentUser = [MUSUser create];
    
    if ([result isKindOfClass: [NSDictionary class]]) {
        self.currentUser.clientID = [result objectForKey : MUSFacebookParseUser_ID];
        self.currentUser.username = [result objectForKey : MUSFacebookParseUser_Name];
        self.currentUser.firstName = [result objectForKey: MUSFacebookParseUser_First_Name];
        self.currentUser.lastName = [result objectForKey : MUSFacebookParseUser_Last_Name];
        self.currentUser.networkType = MUSFacebook;
        NSDictionary *pictureDictionary = [result objectForKey : MUSFacebookParseUser_Picture];
        NSDictionary *pictureDataDictionary = [pictureDictionary objectForKey : MUSFacebookParseUser_Data];
        self.currentUser.photoURL = [pictureDataDictionary objectForKey : MUSFacebookParseUser_Photo_Url];
        self.currentUser.photoURL = [self.currentUser.photoURL saveImageOfUserToDocumentsFolder: self.currentUser.photoURL];
    }
}

#pragma mark - createPlace

/*!
 @abstract an instance of the Place for facebook network.
 @param dictionary takes dictionary from facebook network.
 */
- (MUSPlace*) createPlace : (NSDictionary *) result {
    MUSPlace *currentPlace = [MUSPlace create];
    currentPlace.placeID = [result objectForKey: MUSFacebookParsePlace_ID];
    currentPlace.fullName = [result objectForKey: MUSFacebookParsePlace_Name];
    currentPlace.placeType = [result objectForKey: MUSFacebookParsePlace_Category];
    
    NSDictionary *locationFBDictionary = [result objectForKey: MUSFacebookParsePlace_Location];
    currentPlace.country = [locationFBDictionary objectForKey: MUSFacebookParsePlace_Country];
    currentPlace.city = [locationFBDictionary objectForKey: MUSFacebookParsePlace_City];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [locationFBDictionary objectForKey: MUSFacebookParsePlace_Longitude]];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [locationFBDictionary objectForKey: MUSFacebookParsePlace_Latitude]];
    
    return currentPlace;
}

#pragma mark - createLocation

- (MUSLocation*) createLocationForPost : (MUSPost*) post {
    MUSLocation *location = [MUSLocation create];
    location.latitude = post.latitude;
    location.longitude = post.longitude;
    location.type = MUSFacebookLocation_Parameter_Type_Place;
    location.distance = MUSFacebookLocation_Parameter_Type_Distance;
    return location;
}


@end