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

@interface VKNetwork () <VKSdkDelegate>
@property (strong, nonatomic) UINavigationController *navigationController;
@property (copy, nonatomic) Complition copyComplition;
@property (copy, nonatomic) Complition copyPostComplition;

@end

static VKNetwork *model = nil;


//#warning "Use isLoggedIn method to check is login"

@implementation VKNetwork

+ (VKNetwork*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[VKNetwork alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    [VKSdk initializeWithDelegate:self andAppId:kVkAppID];
    
    if (self) {
        self.networkType = VKontakt;
        if (![self isLoggedIn]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
        }
    }
    return self;
}

- (BOOL) isLoggedIn {
    return [VKSdk wakeUpSession];
}

- (void) initiationPropertiesWithoutSession {
    self.title = @"Login VKontakt";
    self.icon = @"VKimage.png";
    self.isLogin = NO;
}

#pragma mark - loginInNetwork

- (void) loginWithComplition :(Complition) block {
    self.isLogin = YES;
    self.copyComplition = block;
    if (![self isLoggedIn])
    {
        [VKSdk authorize:@[VK_PER_NOHTTPS, VK_PER_OFFLINE, VK_PER_PHOTOS, VK_PER_WALL, VK_PER_EMAIL]];
    }
}

#pragma mark - logoutInNetwork

- (void) loginOut {
    [VKSdk forceLogout];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

#pragma mark - obtainUserFromNetwork

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {

    __weak VKNetwork *weakSell = self;
    
    VKRequest * request = [[VKApi users] get:@{ VK_API_FIELDS : ALL_USER_FIELDS }];
    [request executeWithResultBlock:^(VKResponse * response)
     {
         weakSell.currentUser = [User createFromDictionary:(NSDictionary*)[response.json firstObject] andNetworkType:weakSell.networkType];
         weakSell.title = [NSString stringWithFormat:@"%@ %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
         weakSell.icon = weakSell.currentUser.photoURL;
             block(weakSell, nil);
         
     } errorBlock:^(NSError * error) {
         if (error.code != VK_API_ERROR) {
             [error.vkError.request repeat];
         }
         else {
             NSLog(@"VK error: %@", error);
         }
     }];
}

#pragma mark - obtainArrayOfPlacesFromNetwork

- (void) obtainArrayOfPlaces: (Location *) location withComplition: (ComplitionPlaces) block {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"q"] = location.q;
    params[@"latitude"] = location.latitude;
    params[@"longitude"] = location.longitude;
    params[@"radius"] = [self radiusForVKLocation: location.distance];
    
    VKRequest * locationRequest = [VKApi requestWithMethod: @"places.search"
                                     andParameters: params
                                     andHttpMethod:@"GET"];
                           
    [locationRequest executeWithResultBlock:^(VKResponse * response)
     {
         NSDictionary *resultDictionary = (NSDictionary*) response.json;
         NSArray *places = [resultDictionary objectForKey: @"items"];
         
         NSMutableArray *placesArray = [[NSMutableArray alloc] init];
         for (int i = 0; i < places.count; i++) {
             Place *place = [Place createFromDictionary: [places objectAtIndex: i] andNetworkType:self.networkType];
             [placesArray addObject:place];
         }
         
         if (placesArray.count != 0) {
             block (placesArray, nil);
         }   else {
             //// ADD ERROR /////
         }
     } errorBlock:^(NSError * error) {
         if (error.code != VK_API_ERROR) {
             [error.vkError.request repeat];
         }
         else {
             NSLog(@"VK error: %@", error);
         }
     }];
}

- (NSString*) radiusForVKLocation : (NSString*) distanceString {
    NSInteger distance = [distanceString floatValue];
    if (distance <= 300) {
        return @"1";
    } else if (distance > 300 && distance <= 2400) {
        return @"2";
    } else if (distance > 2400 && distance <= 18000) {
        return @"3";
    } else {
        return @"4";
    }
}

#pragma mark - sharePostToNetwork

- (void) sharePost : (Post*) post withComplition : (Complition) block {
    self.copyPostComplition = block;
    if (!post.imageToPost.image) {
        [self postMessageToVK : post];
    } else if (post.arrayImages.count > 1) {
        [self postImagesToVK : post];
    } else {
        [self postImageToVK : post];
    }
}

#pragma mark - postMessageToNetwork

- (void) postMessageToVK : (Post*) post {
    
    VKRequest *request = [[VKApi wall] post: @{VK_API_MESSAGE : post.postDescription,
                                               VK_API_OWNER_ID : [VKSdk getAccessToken].userId,
                                               VK_API_PLACE_ID : post.placeID }];
    [request executeWithResultBlock: ^(VKResponse *response) {
        self.copyPostComplition (@"Post is success", nil);
    } errorBlock: ^(NSError *error) {
        self.copyPostComplition (nil, error);
    }];
    
}


#pragma mark - postSingleImageToNetwork

- (void) postImageToVK : (Post*) post {
    __weak VKNetwork *weakSell = self;
    
    ImageToPost *imageToPost = [post.arrayImages firstObject];
    
    NSInteger userId = [self.currentUser.clientID integerValue];
    VKRequest * request = [VKApi uploadWallPhotoRequest: imageToPost.image
                                             parameters: [self imageForVKNetwork: imageToPost]
                                                 userId: userId
                                                groupId: 0];
    
    [request executeWithResultBlock: ^(VKResponse *response) {
        
        VKPhoto *photoInfo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        NSString *photoAttachment = [NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id];
        
        VKRequest *postRequest = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : photoAttachment,
                                                          VK_API_OWNER_ID : weakSell.currentUser.clientID,
                                                           VK_API_MESSAGE : post.postDescription,
                                                          VK_API_PLACE_ID : post.placeID}];
        
            [postRequest executeWithResultBlock: ^(VKResponse *response) {
                NSLog(@"Result: %@", @"Posted");
                self.copyPostComplition (@"Post is success", nil);
            } errorBlock: ^(NSError *error) {
                NSLog(@"Error: %@", error);
                self.copyPostComplition (nil, error);
            }];
        
    } errorBlock: ^(NSError *error) {
        self.copyPostComplition (nil, error);
        NSLog(@"Error: %@", error);
    }];
}

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


- (void) postImagesToVK : (Post*) post {
    __weak VKNetwork *weakSell = self;

    NSInteger userId = [self.currentUser.clientID integerValue];
    NSMutableArray *requestArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < post.arrayImages.count; i++) {
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];

        VKRequest * request = [VKApi uploadWallPhotoRequest: imageToPost.image
                                                 parameters: [self imageForVKNetwork: imageToPost]
                                                     userId: userId
                                                    groupId: 0];
        [requestArray addObject: request];
    }
    
    VKBatchRequest *batch = [[VKBatchRequest alloc] initWithRequestsArray: requestArray];
    
    [batch executeWithResultBlock: ^(NSArray *responses) {

        NSLog(@"Photos: %@", responses);
            NSMutableArray *photosAttachments = [NSMutableArray new];
        
            for (VKResponse * resp in responses) {
                VKPhoto *photoInfo = [(VKPhotoArray*)resp.parsedModel objectAtIndex:0];
                
                [photosAttachments addObject:[NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id]];
            }
        
        
        VKRequest *postRequest = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : [photosAttachments componentsJoinedByString: @","],
                                                       VK_API_OWNER_ID : weakSell.currentUser.clientID,
                                                       VK_API_MESSAGE  : post.postDescription,
                                                       VK_API_PLACE_ID : post.placeID}];
        
        
            [postRequest executeWithResultBlock: ^(VKResponse *response) {
                    NSLog(@"Result: %@", response);
                } errorBlock: ^(NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
        } errorBlock: ^(NSError *error) {
            NSLog(@"Error: %@", error);
    }];
}





- (UIViewController*) vcForLoginVK {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *vc=[window rootViewController];
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
    NSLog(@"Access denied");
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
@end
