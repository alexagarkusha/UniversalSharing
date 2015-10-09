//
//  VKNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/22/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "VKNetwork.h"
#import "Location.h"
#import "Place.h"
#import <VKSdk.h>
#import "NSError+MUSError.h"
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "InternetConnectionManager.h"
#import "NetworkPost.h"
#import "NSString+MUSCurrentDate.h"
#import "MUSPostManager.h"
#import "VKOperation.h"
#import "VKUploadImage.h"

@interface VKNetwork () <VKSdkDelegate>
@property (strong, nonatomic) UINavigationController *navigationController;
@property (copy, nonatomic) Complition copyComplition;
@property (copy, nonatomic) ProgressLoading copyProgressLoading;

@end

static VKNetwork *model = nil;

//#warning "Use isLoggedIn method to check is login"

@implementation VKNetwork

#pragma mark Singleton Method

+ (VKNetwork*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[VKNetwork alloc] init];
    });
    return  model;
}

#pragma mark - initiation VKNetwork
/*!
 Initiation VKNetwork.
 */

- (instancetype) init {
    self = [super init];
    [VKSdk initializeWithDelegate:self andAppId:MUSVKAppID];
    
    if (self) {
        self.networkType = MUSVKontakt;
        self.name = MUSVKName;
        if (![VKNetwork isLoggedIn]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
            [self startTimerForUpdatePosts];
            //[self updatePost];////////////////////////////////////////////////////////////
            self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUserWithNetworkType:self.networkType]]firstObject];
            //self.icon = self.currentUser.photoURL;
            self.icon = MUSVKIconName;
            self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
//            self.isVisible = self.currentUser.isVisible;
//            NSInteger indexPosition = self.currentUser.indexPosition;
            
            if ([[InternetConnectionManager connectionManager] isInternetConnection]){
                
                NSString *deleteImageFromFolder = self.currentUser.photoURL;
                
                [self obtainUserInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
                    if (!error) {
                        [[NSFileManager defaultManager] removeItemAtPath: [deleteImageFromFolder obtainPathToDocumentsFolder:deleteImageFromFolder] error: nil];
//                        result.currentUser.isVisible = self.isVisible;
//                        result.currentUser.indexPosition = indexPosition;
                        [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUpdateUser:result.currentUser]];
                    }
                }];
            }
        }
    }
    return self;
}

/*!
 Checks if somebody logged in with SDK
 */
//#warning "check VK method +isLoggedIn"
+ (BOOL) isLoggedIn {
    return [VKSdk wakeUpSession];
}

/*!
 Initiation properties of VKNetwork without session
 */
- (void) initiationPropertiesWithoutSession {
    self.title = MUSVKTitle;
    self.icon = MUSVKIconName;
    self.isLogin = NO;
    self.isVisible = YES;
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
 Starts authorization process. If VKapp is available in system, it will opens and requests access from user.
 Otherwise Mobile Safari will be opened for access request.
 */

- (void) loginWithComplition :(Complition) block {
    self.copyComplition = block;
    if (![VKNetwork isLoggedIn])
    {
        [VKSdk authorize:@[VK_PER_NOHTTPS, VK_PER_OFFLINE, VK_PER_PHOTOS, VK_PER_WALL, VK_PER_EMAIL]];
    }
}

#pragma mark - logoutInNetwork

/*!
 Forces logout using OAuth (with VKAuthorizeController). Removes all cookies for *.vk.com.
 Has no effect for logout in VK app
 */

- (void) logout {
    [VKSdk forceLogout];
    [[MUSPostManager manager] deleteNetworkPostForNetworkType: self.networkType];
    [MUSPostManager manager].needToRefreshPosts = YES;
    [self removeUserFromDataBaseAndImageFromDocumentsFolder:self.currentUser];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

#pragma mark - obtainUserFromNetwork

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
    
    __weak VKNetwork *weakSell = self;
    
    VKRequest * request = [[VKApi users] get:@{ VK_API_FIELDS : MUSVKAllUserFields }];
    [request executeWithResultBlock:^(VKResponse * response)
     {
         weakSell.currentUser = [User createFromDictionary:(NSDictionary*)[response.json firstObject] andNetworkType : weakSell.networkType];
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
             //[weakSell startTimerForUpdatePosts];
             weakSell.isLogin = YES;
             block(weakSell,nil);
         });
         //         weakSell.currentUser = [User createFromDictionary:(NSDictionary*)[response.json firstObject] andNetworkType:weakSell.networkType];
         //         weakSell.title = [NSString stringWithFormat:@"%@ %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
         //         weakSell.icon = weakSell.currentUser.photoURL;
         //             block(weakSell, nil);
         
     } errorBlock:^(NSError * error) {
         if (error.code != VK_API_ERROR) {
             [error.vkError.request repeat];
         }
         else {
             block (nil, [self errorVkontakte]);
         }
     }];
}


- (void) updateNetworkPostWithComplition: (UpdateNetworkPostsComplition) block {
    NSArray * networksPostsIDs = [[DataBaseManager sharedManager] obtainNetworkPostsFromDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForNetworkPostWithReason: MUSConnect andNetworkType: MUSVKontakt]];
    
    if (![[InternetConnectionManager connectionManager] isInternetConnection] || !networksPostsIDs.count  || (![[InternetConnectionManager connectionManager] isInternetConnection] && networksPostsIDs.count)) {
        block (@"Vkontakte, Error update network posts");
        return;
    }
    __block NSString *stringPostsWithUserIdAndPostId = @"";
    [networksPostsIDs enumerateObjectsUsingBlock:^(NetworkPost *networkPost, NSUInteger index, BOOL *stop) {
        stringPostsWithUserIdAndPostId = [stringPostsWithUserIdAndPostId stringByAppendingString:[NSString stringWithFormat:@"%@_%@", [VKSdk getAccessToken].userId, networkPost.postID]];
        if (networksPostsIDs.count != ++index) {
            stringPostsWithUserIdAndPostId = [stringPostsWithUserIdAndPostId stringByAppendingString:@","];
            
        }
    }];
    
    VKBatchRequest *batch = [[VKBatchRequest alloc] initWithRequests:[self createRequestForCountOfLikesAndCountOfComments:stringPostsWithUserIdAndPostId],nil];
    
    [batch executeWithResultBlock: ^(NSArray *responses) {
        VKResponse * response = [responses firstObject];
        NSArray *arrayCount = response.json;
        //for (VKResponse * response in responses) {
        for (int i = 0; i < arrayCount.count;  i++) {
            NetworkPost *networkPost = [NetworkPost create];
            networkPost.postID = [response.json[i] objectForKey:@"id"];
            networkPost.reason = MUSConnect;
            networkPost.networkType = MUSVKontakt;
            networkPost.likesCount = [[[response.json[i] objectForKey:@"likes"] objectForKey:@"count"] integerValue];
            networkPost.commentsCount = [[[response.json[i] objectForKey:@"comments"] objectForKey:@"count"] integerValue];
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForVKUpdateNetworkPost: networkPost]];
        }
        block (@"Vkontakte update all network posts");
    } errorBlock: ^(NSError *error) {
        //self.copyComplition (nil, [self errorVkontakte]);
        block (@"Error update network posts");
    }];
}

- (VKRequest*) createRequestForCountOfLikesAndCountOfComments :(NSString*) stringPostsWithUserIdAndPostId {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:stringPostsWithUserIdAndPostId,@"posts",nil];
    
    VKRequest * request = [VKApi requestWithMethod : @"wall.getById"
                                     andParameters : params
                                     andHttpMethod : MUSGET];
    return request;
}

#pragma mark - obtainArrayOfPlacesFromNetwork


- (void) obtainPlacesArrayForLocation: (Location *) location withComplition: (Complition) block {
    self.copyComplition = block;
    
    if (!location.q || !location.latitude || !location.longitude || !location.distance || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        
        NSError *error = [NSError errorWithMessage: MUSLocationPropertiesError andCodeError: MUSLocationPropertiesErrorCode];
        return block (nil, error);
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    params[MUSVKLocationParameter_Q] = location.q;
    params[MUSVKLocationParameter_Latitude] = location.latitude;
    params[MUSVKLocationParameter_Longitude] = location.longitude;
    params[MUSVKLocationParameter_Radius] = [NSString stringWithFormat:@"%ld",
                                             (long)[self radiusForVKLocation: location.distance]];
    
    VKRequest * locationRequest = [VKApi requestWithMethod : MUSVKMethodPlacesSearch
                                             andParameters : params
                                             andHttpMethod : MUSGET];
    
    [locationRequest executeWithResultBlock:^(VKResponse * response)
     {
         NSDictionary *resultDictionary = (NSDictionary*) response.json;
         NSArray *places = [resultDictionary objectForKey: MUSVKKeyOfPlaceDictionary];
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
     } errorBlock:^(NSError * error) {
         if (error.code != VK_API_ERROR) {
             [error.vkError.request repeat];
         }
         else {
             block (nil, [self errorVkontakte]);
         }
     }];
}

/*!
 @abstract return type radius search area (DistanceType 1..4)
 @param current distance of @class Location
 */

- (DistanceType) radiusForVKLocation : (NSString*) distanceString {
    NSInteger distance = [distanceString floatValue];
    if (distance <= MUSVKDistanceEqual300) {
        return MUSDistanceType1;
    } else if (distance > MUSVKDistanceEqual300 && distance <= MUSVKDistanceEqual2400) {
        return MUSDistanceType2;
    } else if (distance > MUSVKDistanceEqual2400 && distance <= MUSVKDistanceEqual18000) {
        return MUSDistanceType3;
    } else {
        return MUSDistanceType4;
    }
}


#pragma mark - sharePostToNetwork

- (void) sharePost : (Post*) post withComplition : (Complition) block progressLoadingBlock:(ProgressLoading) blockLoading{
    if (![[InternetConnectionManager connectionManager] isInternetConnection]){
        NetworkPost *networkPost = [NetworkPost create];
        networkPost.networkType = MUSVKontakt;
        networkPost.reason = MUSOffline;
        blockLoading ([NSNumber numberWithInteger: self.networkType], 1.0f);
        block(networkPost,[self errorConnection]);
        return;
    }
    
    self.copyComplition = block;
    self.copyProgressLoading = blockLoading;

    if ([post.arrayImages count] > 0) {
        __block NSUInteger numberOfImagesInPost = [post.arrayImages count];
        __block NSMutableArray *arrayOfLoadingObjects = [[NSMutableArray alloc] init];
        for (int i = 0; i < [post.arrayImages count]; i++) {
            NSNumber *loadingObject = [[NSNumber alloc] init];
            loadingObject = [NSNumber numberWithFloat: 0.0000001];
            [arrayOfLoadingObjects addObject: loadingObject];
        }    
        [self postImagesToVK: post withProgressLoadingImagesToVK:^(int objectOfLoading, long long bytesLoaded, long long bytesTotal) {
            if (arrayOfLoadingObjects.count > objectOfLoading) {
                NSNumber *currentObject = [arrayOfLoadingObjects objectAtIndex:objectOfLoading];
                currentObject = [NSNumber numberWithFloat: (bytesLoaded * 1.0f / bytesTotal)];
                [arrayOfLoadingObjects replaceObjectAtIndex: objectOfLoading withObject:currentObject];
            }
            
            float totalProgress = 0;
            
            for (int i = 0; i < [arrayOfLoadingObjects count]; i ++) {
                NSNumber *currentObject = [arrayOfLoadingObjects objectAtIndex: i];
                totalProgress += [currentObject floatValue];
            }
            blockLoading ([NSNumber numberWithInteger: self.networkType], totalProgress / numberOfImagesInPost);
            //NSLog(@"total progress = %f", totalProgress / numberOfImagesInPost);
        }];
    } else {
        [self postMessageToVK: post];
    }
}

/*!
 @abstract upload message and user location (optional)
 @param current post of @class Post
 */

#pragma mark - postMessageToNetwork

- (void) postMessageToVK : (Post*) post {
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = MUSVKontakt;
    __block NetworkPost *networkPostCopy = networkPost;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    parameters [VK_API_OWNER_ID] = [VKSdk getAccessToken].userId;
    parameters [VK_API_MESSAGE] = post.postDescription;
    if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
        parameters [VK_API_LONG] = post.longitude;
        parameters [VK_API_LAT] = post.latitude;
    }
    
    
    VKRequest *request = [[VKApi wall] post: parameters];
//////<<<<<<< HEAD
//=======
    
    [request setProgressBlock:^(VKProgressType progressType, long long bytesLoaded, long long bytesTotal) {
        if (bytesTotal < 0) {
            return;
        }
        float totalProgress = (bytesLoaded * 1.0f / bytesTotal);
        self.copyProgressLoading ([NSNumber numberWithInteger: self.networkType], totalProgress);
    }];

//>>>>>>> b977834042062c2a59ebac2d636324646a88f47f
    [request executeWithResultBlock: ^(VKResponse *response) {
        networkPostCopy.reason = MUSConnect;
        networkPostCopy.dateCreate = [NSString currentDate];
        networkPostCopy.postID = [[response.json objectForKey:@"post_id"] stringValue];
        self.copyComplition (networkPostCopy, nil);
    } errorBlock: ^(NSError *error) {
        networkPostCopy.reason = MUSErrorConnection;
        self.copyComplition (networkPostCopy, [self errorVkontakte]);
    }];
    
}

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */

- (void) postImagesToVK : (Post*) post withProgressLoadingImagesToVK : (ProgressLoadingImagesToVK) progressLoadingImagesToVK {
    __block NSUInteger numberOfImagesInPost = [post.arrayImages count];
    __block int counterOfImages = 0;
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = MUSVKontakt;
    __block NetworkPost *networkPostCopy = networkPost;
    
    NSInteger userId = [self.currentUser.clientID integerValue];
    NSMutableArray *requestArray = [[NSMutableArray alloc] init]; //array of requests to add pictures in the social network
    for (int i = 0; i < [post.arrayImages count]; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];

        VKRequest * request = [VKApi uploadWallPhotoRequest: imageToPost.image
                                                 parameters: [self imageForVKNetwork: imageToPost]
                                                     userId: userId
                                                    groupId: 0];
        __block int object = i;
        [request setProgressBlock:^(VKProgressType progressType, long long bytesLoaded, long long bytesTotal) {
            if (bytesTotal < 0) {
                return;
            }
            progressLoadingImagesToVK (object, bytesLoaded, bytesTotal);
        }];
        [requestArray addObject: request];
    }
    
    VKBatchRequest *batch = [[VKBatchRequest alloc] initWithRequestsArray: requestArray];
    
    [batch executeWithResultBlock: ^(NSArray *responses) {
        
        NSMutableArray *photosAttachments = [[NSMutableArray alloc] init];
        
        for (VKResponse * resp in responses) {
            VKPhoto *photoInfo = [(VKPhotoArray*)resp.parsedModel objectAtIndex:0];
            [photosAttachments addObject:[NSString stringWithFormat:@"photo%@_%@",
                                          photoInfo.owner_id, photoInfo.id]];
        }
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        parameters [VK_API_OWNER_ID] = [VKSdk getAccessToken].userId;
        parameters [VK_API_ATTACHMENTS] = [photosAttachments componentsJoinedByString: @","];
        if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
            parameters [VK_API_LONG] = post.longitude;
            parameters [VK_API_LAT] = post.latitude;
        }
        if (post.postDescription) {
            parameters [VK_API_MESSAGE] = post.postDescription;
        }
        
        
        VKRequest *postRequest = [[VKApi wall] post: parameters];
                
        [postRequest executeWithResultBlock: ^(VKResponse *response) {
            
            
            networkPostCopy.postID = [[response.json objectForKey:@"post_id"] stringValue];
            networkPostCopy.reason = MUSConnect;
            networkPostCopy.dateCreate = [NSString currentDate];
            self.copyComplition (networkPostCopy, nil);
        } errorBlock: ^(NSError *error) {
            networkPostCopy.reason = MUSErrorConnection;
            self.copyComplition (networkPostCopy, [self errorVkontakte]);
        }];
    } errorBlock: ^(NSError *error) {
        counterOfImages++;
        if (counterOfImages == numberOfImagesInPost) {
            networkPostCopy.reason = MUSErrorConnection;
            self.copyComplition (networkPostCopy, [self errorVkontakte]);
        }
    }];
}

/*!
 @abstract settings parameters for image for uploading image into VK servers
 @param current ImageToPost of @class ImageToPost
 */

- (VKImageParameters*) imageForVKNetwork : (ImageToPost*) imageToPost {
    switch (imageToPost.imageType) {
        case MUSPNG:
            return [VKImageParameters pngImage];
            break;
        case MUSJPEG:
            if (imageToPost.quality > 0) {
                return [VKImageParameters jpegImageWithQuality: imageToPost.quality];
                break;
            }
            return [VKImageParameters jpegImageWithQuality: 1.f];
            break;
        default:
            break;
    }
}

/*!
 @abstract current root View Controller
 */

- (UIViewController*) vcForLoginVK {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = [window rootViewController];
    if(vc.presentedViewController)
        return vc.presentedViewController;
    else
        return vc;
}

#pragma mark - VK Delegate

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
    // [self authorize:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    [self startTimerForUpdatePosts];// check it later
    [self obtainUserInfoFromNetworkWithComplition:self.copyComplition];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [[self vcForLoginVK] presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token
{
    //[self obtainDataFromVK];
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    
    self.isLogin = NO;
    self.isVisible = YES;
    NSError *error = [NSError errorWithMessage: MUSAccessError andCodeError: MUSAccessErrorCode];
    self.copyComplition (nil, error);
    
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

/*!
 @abstract returned Vkontakte network error
 */
- (NSError*) errorVkontakte {
    return [NSError errorWithMessage: MUSVKError andCodeError: MUSVKErrorCode];
}

- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block {
    
    
    
    
}

- (void)setUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block {
    
}



@end

