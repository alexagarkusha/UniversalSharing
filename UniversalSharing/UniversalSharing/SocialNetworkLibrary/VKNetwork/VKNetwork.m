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


@interface VKNetwork () <VKSdkDelegate>
@property (strong, nonatomic) UINavigationController *navigationController;
@property (copy, nonatomic) Complition copyComplition;

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
    [VKSdk initializeWithDelegate:self andAppId:musVKAppID];
    
    if (self) {
        self.networkType = VKontakt;
        self.name = musVKName;
        if (![VKNetwork isLoggedIn]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
            
            self.currentUser = [[DataBaseManager sharedManager]obtainUsersWithNetworkType:self.networkType];
            self.icon = self.currentUser.photoURL;
            self.title = [NSString stringWithFormat:@"%@  %@", self.currentUser.firstName, self.currentUser.lastName];
            self.isVisible = self.currentUser.isVisible;
            
            if ([self obtainCurrentConnection]){
                
                NSString *deleteImageFromFolder = self.currentUser.photoURL;
                
                [self obtainInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
                    
                    [[NSFileManager defaultManager] removeItemAtPath: [deleteImageFromFolder obtainPathToDocumentsFolder:deleteImageFromFolder] error: nil];
                    [[DataBaseManager sharedManager] editUser:result.currentUser];
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
    self.title = musVKTitle;
    self.icon = musVKIconName;
    self.isLogin = NO;
    self.isVisible = YES;
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

- (void) loginOut {
    [VKSdk forceLogout];
    [self removeUserFromDataBaseAndImageFromDocumentsFolder:self.currentUser];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

#pragma mark - obtainUserFromNetwork

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {

    __weak VKNetwork *weakSell = self;
    
    VKRequest * request = [[VKApi users] get:@{ VK_API_FIELDS : musVKAllUserFields }];
    [request executeWithResultBlock:^(VKResponse * response)
     {
         weakSell.currentUser = [User createFromDictionary:(NSDictionary*)[response.json firstObject] andNetworkType : weakSell.networkType];
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

#pragma mark - obtainArrayOfPlacesFromNetwork


- (void) obtainArrayOfPlaces: (Location *) location withComplition: (Complition) block {
    self.copyComplition = block;
    
    if (!location.q || !location.latitude || !location.longitude || !location.distance || [location.latitude floatValue] < -90.0f || [location.latitude floatValue] > 90.0f || [location.longitude floatValue] < -180.0f  || [location.longitude floatValue] > 180.0f) {
        
        NSError *error = [NSError errorWithMessage: musErrorLocationProperties andCodeError: musErrorLocationPropertiesCode];
        return block (nil, error);
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
        params[musVKLoactionParameter_Q] = location.q;
        params[musVKLoactionParameter_Latitude] = location.latitude;
        params[musVKLoactionParameter_Longitude] = location.longitude;
        params[musVKLoactionParameter_Radius] = [NSString stringWithFormat:@"%ld",
                                                    (long)[self radiusForVKLocation: location.distance]];
    
    VKRequest * locationRequest = [VKApi requestWithMethod : musVKMethodPlacesSearch
                                             andParameters : params
                                             andHttpMethod : musGET];
                           
    [locationRequest executeWithResultBlock:^(VKResponse * response)
     {
         NSDictionary *resultDictionary = (NSDictionary*) response.json;
         NSArray *places = [resultDictionary objectForKey: musVKKeyOfPlaceDictionary];
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
    if (distance <= musVKDistanceEqual300) {
        return DistanceType1;
    } else if (distance > musVKDistanceEqual300 && distance <= musVKDistanceEqual2400) {
        return DistanceType2;
    } else if (distance > musVKDistanceEqual2400 && distance <= musVKDistanceEqual18000) {
        return DistanceType3;
    } else {
        return DistanceType4;
    }
}


#pragma mark - sharePostToNetwork

- (void) sharePost : (Post*) post withComplition : (Complition) block {
    if (![self obtainCurrentConnection]){
        [self saveOrUpdatePost: post withReason: Offline];
        block(nil,[self errorConnection]);
        return;
    }
    self.copyComplition = block;
    if ([post.arrayImages count] > 0) {
        [self postImagesToVK: post];
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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
        parameters [VK_API_OWNER_ID] = [VKSdk getAccessToken].userId;
        parameters [VK_API_MESSAGE] = post.postDescription;
        if (post.place.placeID) {
            parameters [VK_API_PLACE_ID] = post.place.placeID;
        }
    
    VKRequest *request = [[VKApi wall] post: parameters];
    
    [request executeWithResultBlock: ^(VKResponse *response) {
        self.copyComplition (musPostSuccess, nil);
        [self saveOrUpdatePost: post withReason: Connect];
    } errorBlock: ^(NSError *error) {
        self.copyComplition (nil, [self errorVkontakte]);
        [self saveOrUpdatePost: post withReason: ErrorConnection];
    }];
    
}

/*!
 @abstract upload image(s) with message (optional) and user location (optional)
 @param current post of @class Post
 */

- (void) postImagesToVK : (Post*) post {
    NSInteger userId = [self.currentUser.clientID integerValue];
    NSMutableArray *requestArray = [[NSMutableArray alloc] init]; //array of requests to add pictures in the social network
    
    for (int i = 0; i < [post.arrayImages count]; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];
        
        VKRequest * request = [VKApi uploadWallPhotoRequest: imageToPost.image
                                                 parameters: [self imageForVKNetwork: imageToPost]
                                                     userId: userId
                                                    groupId: 0];
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
            if (post.placeID) {
                parameters [VK_API_PLACE_ID] = post.placeID;
            }
            if (post.postDescription) {
                parameters [VK_API_MESSAGE] = post.postDescription;
            }
        
        VKRequest *postRequest = [[VKApi wall] post: parameters];
        [postRequest executeWithResultBlock: ^(VKResponse *response) {
            self.copyComplition (musPostSuccess, nil);
            [self saveOrUpdatePost: post withReason: Connect];
        } errorBlock: ^(NSError *error) {
            [self saveOrUpdatePost: post withReason: ErrorConnection];
        }];
    } errorBlock: ^(NSError *error) {
        self.copyComplition (nil, [self errorVkontakte]);
    }];
}

/*!
 @abstract settings parameters for image for uploading image into VK servers
 @param current ImageToPost of @class ImageToPost
 */

- (VKImageParameters*) imageForVKNetwork : (ImageToPost*) imageToPost {
    switch (imageToPost.imageType) {
        case PNG:
            return [VKImageParameters pngImage];
            break;
        case JPEG:
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
    [self obtainInfoFromNetworkWithComplition:self.copyComplition];
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
    NSError *error = [NSError errorWithMessage: musErrorAccesDenied andCodeError: musErrorAccesDeniedCode];
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
    return [NSError errorWithMessage: musFacebookError andCodeError: musFacebookErrorCode];
}



@end
