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
#import "MUSDatabaseRequestStringsHelper.h"
#import "DataBaseManager.h"
#import "MUSSocialNetworkLibraryConstantsForParseObjects.h"


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
            [self initiationPropertiesWithSession];
            [self updateUserInSocialNetwork];
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
}

/*!
 Initiation properties of VKNetwork with session
 */
- (void) initiationPropertiesWithSession {
    self.isLogin = YES;
    self.icon = MUSVKIconName;
    self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUserWithNetworkType: self.networkType]]firstObject];
    self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
}


#pragma mark - login

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

#pragma mark - logout

/*!
 Forces logout using OAuth (with VKAuthorizeController). Removes all cookies for *.vk.com.
 Has no effect for logout in VK app
 */

- (void) logout {
    [VKSdk forceLogout];
    [[MUSPostManager manager] deleteNetworkPostForNetworkType: self.networkType];
    [self.currentUser removeUser];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

#pragma mark - obtainUserInfoFromNetwork

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
    __weak VKNetwork *weakSelf = self;
    VKRequest * request = [[VKApi users] get:@{ VK_API_FIELDS : MUSVKAllUserFields }];
    [request executeWithResultBlock:^(VKResponse * response)
     {
         [weakSelf createUser: (NSDictionary*)[response.json firstObject]];
         weakSelf.title = [NSString stringWithFormat:@"%@  %@", weakSelf.currentUser.firstName, weakSelf.currentUser.lastName];
        
         if (!weakSelf.isLogin) {
             [weakSelf.currentUser insertIntoDataBase];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.isLogin = YES;
             block(weakSelf,nil);
         });
     } errorBlock:^(NSError * error) {
         if (error.code != VK_API_ERROR) {
             [error.vkError.request repeat];
         }
         else {
             block (nil, [self errorVkontakte]);
         }
     }];
}


#pragma mark - sharePost

- (void) sharePost : (Post*) post withComplition : (Complition) block progressLoadingBlock:(ProgressLoading) blockLoading{
    if (![[InternetConnectionManager connectionManager] isInternetConnection]){
        NetworkPost *networkPost = [NetworkPost create];
        networkPost.networkType = MUSVKontakt;
        blockLoading ([NSNumber numberWithInteger: self.networkType], 1.0f);
        block(networkPost,[self errorConnection]);
        return;
    }
    
    self.copyComplition = block;
    self.copyProgressLoading = blockLoading;
    
    if ([post.arrayImages count]) {
        __block NSUInteger numberOfImagesInPost = [post.arrayImages count];
        __block NSMutableArray *arrayOfLoadingObjects = [[NSMutableArray alloc] init];
        for (int i = 0; i < [post.arrayImages count]; i++) {
            NSNumber *loadingObject = [[NSNumber alloc] init];
            loadingObject = [NSNumber numberWithFloat: 0.0000001];
            [arrayOfLoadingObjects addObject: loadingObject];
        }
        [self sharePostWithPictures: post withProgressLoadingImagesToVK:^(int objectOfLoading, long long bytesLoaded, long long bytesTotal) {
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
        }];
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
    NetworkPost *networkPost = [NetworkPost create];
    networkPost.networkType = MUSVKontakt;
    __block NetworkPost *networkPostCopy = networkPost;
    __weak VKNetwork *weakSelf = self;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    parameters [VK_API_OWNER_ID] = [VKSdk getAccessToken].userId;
    parameters [VK_API_MESSAGE] = post.postDescription;
    if (post.longitude.length > 0 && ![post.longitude isEqualToString: @"(null)"] && post.latitude.length > 0 && ![post.latitude isEqualToString: @"(null)"]) {
        parameters [VK_API_LONG] = post.longitude;
        parameters [VK_API_LAT] = post.latitude;
    }

    VKRequest *request = [[VKApi wall] post: parameters];
    
    [request setProgressBlock:^(VKProgressType progressType, long long bytesLoaded, long long bytesTotal) {
        if (bytesTotal < 0) {
            return;
        }
        float totalProgress = (bytesLoaded * 1.0f / bytesTotal);
        weakSelf.copyProgressLoading ([NSNumber numberWithInteger: weakSelf.networkType], totalProgress);
    }];
    
    [request executeWithResultBlock: ^(VKResponse *response) {
        networkPostCopy.reason = MUSConnect;
        networkPostCopy.dateCreate = [NSString currentDate];
        networkPostCopy.postID = [[response.json objectForKey: MUSVKParsePost_ID] stringValue];
        weakSelf.copyComplition (networkPostCopy, nil);
    } errorBlock: ^(NSError *error) {
        networkPostCopy.reason = MUSErrorConnection;
        weakSelf.copyComplition (networkPostCopy, [weakSelf errorVkontakte]);
    }];
    
}

#pragma mark - sharePostWithPictures

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */

- (void) sharePostWithPictures : (Post*) post withProgressLoadingImagesToVK : (ProgressLoadingImagesToVK) progressLoadingImagesToVK {
    __weak VKNetwork *weakSelf = self;
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
            [photosAttachments addObject:[NSString stringWithFormat:@"%@%@_%@", MUSVKParameter_Photo,
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
            networkPostCopy.postID = [[response.json objectForKey: MUSVKParsePost_ID] stringValue];
            networkPostCopy.reason = MUSConnect;
            networkPostCopy.dateCreate = [NSString currentDate];
            weakSelf.copyComplition (networkPostCopy, nil);
        } errorBlock: ^(NSError *error) {
            networkPostCopy.reason = MUSErrorConnection;
            weakSelf.copyComplition (networkPostCopy, [weakSelf errorVkontakte]);
        }];
    } errorBlock: ^(NSError *error) {
        counterOfImages++;
        if (counterOfImages == numberOfImagesInPost) {
            networkPostCopy.reason = MUSErrorConnection;
            weakSelf.copyComplition (networkPostCopy, [weakSelf errorVkontakte]);
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

#pragma mark - obtainPlacesArrayForLocation

- (void) obtainPlacesArrayForLocation: (Location *) location withComplition: (Complition) block {
    self.copyComplition = block;
    
    if (!location.q || !location.latitude || !location.longitude || !location.distance || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        
        NSError *error = [NSError errorWithMessage: MUSLocationPropertiesError andCodeError: MUSLocationPropertiesErrorCode];
        return block (nil, error);
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    __weak VKNetwork *weakSelf = self;
    
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
             Place *place = [weakSelf createPlace: [places objectAtIndex: i]];
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

#pragma mark - updateNetworkPost

- (void) updateNetworkPostWithComplition: (UpdateNetworkPostsComplition) block {
    NSArray * networksPostsIDs = [[MUSPostManager manager] networkPostsArrayForNetworkType: self.networkType];
    
    if (![[InternetConnectionManager connectionManager] isInternetConnection] || !networksPostsIDs.count  || (![[InternetConnectionManager connectionManager] isInternetConnection] && networksPostsIDs.count)) {
        block (MUSVKError);
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
            networkPost.postID = [response.json[i] objectForKey: MUSVKParseNetworkPost_ID];
            networkPost.reason = MUSConnect;
            networkPost.networkType = MUSVKontakt;
            networkPost.likesCount = [[[response.json[i] objectForKey: MUSVKParseNetworkPost_Likes] objectForKey: MUSVKParseNetworkPost_Count] integerValue];
            networkPost.commentsCount = [[[response.json[i] objectForKey: MUSVKParseNetworkPost_Comments] objectForKey:MUSVKParseNetworkPost_Count] integerValue];
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForVKUpdateNetworkPost: networkPost]];
        }
        block (MUSVKSuccessUpdateNetworkPost);
    } errorBlock: ^(NSError *error) {
        block (MUSNetworkPost_Update_Error_Update);
    }];
}

- (VKRequest*) createRequestForCountOfLikesAndCountOfComments :(NSString*) stringPostsWithUserIdAndPostId {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:stringPostsWithUserIdAndPostId,MUSVKParameter_Posts,nil];
    
    VKRequest * request = [VKApi requestWithMethod : MUSVKMethodWallGetById
                                     andParameters : params
                                     andHttpMethod : MUSGET];
    return request;
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
    [self obtainUserInfoFromNetworkWithComplition:self.copyComplition];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [[self vcForLoginVK] presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token
{
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    self.isLogin = NO;
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


#pragma mark - createUser

/*!
 @abstract an instance of the User for VK network.
 @param dictionary takes dictionary from VK network.
 */
- (void) createUser : (NSDictionary*) result {
    self.currentUser = [User create];
    
    if ([result isKindOfClass: [NSDictionary class]]) {
        self.currentUser.firstName = [result objectForKey : MUSVKParseUser_First_Name];
        self.currentUser.lastName = [result objectForKey : MUSVKParseUser_Last_Name];
        self.currentUser.networkType = MUSVKontakt;
        self.currentUser.clientID = [NSString stringWithFormat: @"%@", [result objectForKey : MUSVKParseUser_ID]];
        self.currentUser.photoURL = [result objectForKey : MUSVKParseUser_Photo_Url];
        self.currentUser.photoURL = [self.currentUser.photoURL saveImageOfUserToDocumentsFolder:self.currentUser.photoURL];
    }
}

#pragma mark - createPlace
/*!
 @abstract an instance of the Place for VK network.
 @param dictionary takes dictionary from VK network.
 */

- (Place*) createPlace : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID = [NSString stringWithFormat: @"%@", [dictionary objectForKey: MUSVKParsePlace_ID]];
    currentPlace.fullName = [dictionary objectForKey: MUSVKParsePlace_Title];
    currentPlace.placeType = [dictionary objectForKey: MUSVKParsePlace_Type];
    currentPlace.country = [dictionary objectForKey: MUSVKParsePlace_Country];
    currentPlace.city = [dictionary objectForKey: MUSVKParsePlace_City];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [dictionary objectForKey: MUSVKParsePlace_Longitude]];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [dictionary objectForKey: MUSVKParsePlace_Latitude]];
    
    return currentPlace;
}


@end

