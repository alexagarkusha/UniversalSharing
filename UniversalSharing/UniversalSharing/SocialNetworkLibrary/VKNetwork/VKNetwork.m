//
//  VKNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/22/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "VKNetwork.h"

#import <VKSdk.h>

@interface VKNetwork () <VKSdkDelegate>
@property (strong, nonatomic) UINavigationController *navigationController;
@property (copy, nonatomic) Complition copyComplition;
@property (copy, nonatomic) Complition copyPostComplition;

@end

static VKNetwork *model = nil;


#warning "Use isLoggedIn method to check is login"

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
        if (![VKSdk wakeUpSession]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
        }
    }
    return self;
}

- (void) loginWithComplition :(Complition) block {
    self.isLogin = YES;
    self.copyComplition = block;
    if (![VKSdk wakeUpSession])
    {
        [VKSdk authorize:@[VK_PER_NOHTTPS, VK_PER_OFFLINE, VK_PER_PHOTOS, VK_PER_WALL, VK_PER_EMAIL]];
    }
}

- (void) loginOut {
    [VKSdk forceLogout];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

- (void) initiationPropertiesWithoutSession {
    self.title = @"Login VKontakt";
    self.icon = @"VKimage.png";
    self.isLogin = NO;
}

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


- (void) sharePost : (Post*) post withComplition : (Complition) block {
    self.copyPostComplition = block;
    if (!post.imageToPost.image) {
        [self postMessageToVK:post];
    } else {
        [self postImageToVK:post];
    }
}


- (void) postImageToVK : (Post*) post {
    __weak VKNetwork *weakSell = self;
    NSInteger userId = [self.currentUser.clientID integerValue];
    VKRequest * request = [VKApi uploadWallPhotoRequest: post.imageToPost.image parameters: [self imageForVKNetwork: post] userId:userId groupId:0 ];
    
    [request executeWithResultBlock: ^(VKResponse *response) {
        
        VKPhoto *photoInfo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        NSString *photoAttachment = [NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id];
        NSString *postDescription = post.postDescription;
        NSString *latitude = [NSString stringWithFormat:@"%f", post.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", post.longitude];
        
        VKRequest *post = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : photoAttachment, VK_API_OWNER_ID : weakSell.currentUser.clientID, VK_API_MESSAGE : postDescription, VK_API_LAT :latitude,VK_API_LONG : longitude }];
        
            [post executeWithResultBlock: ^(VKResponse *response) {
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



- (void) postMessageToVK : (Post*) post {
    NSString *latitude = [NSString stringWithFormat:@"%f", post.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", post.longitude];
    
    VKRequest *request = [[VKApi wall] post: @{VK_API_MESSAGE: post.postDescription, VK_API_OWNER_ID : [VKSdk getAccessToken].userId, VK_API_LAT :latitude,VK_API_LONG : longitude}];
    [request executeWithResultBlock: ^(VKResponse *response) {
        self.copyPostComplition (@"Post is success", nil);
    } errorBlock: ^(NSError *error) {
        self.copyPostComplition (nil, error);
    }];
    
}

- (VKImageParameters*) imageForVKNetwork : (Post*) post {
    switch (post.imageToPost.imageType) {
        case PNG:
            return [VKImageParameters pngImage];
            break;
        case JPEG:
            if (post.imageToPost.quality > 0) {
                return [VKImageParameters jpegImageWithQuality:post.imageToPost.quality];
                break;
            }
            return [VKImageParameters jpegImageWithQuality: 1.f];
            break;
        default:
            break;
    }
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

//vbiflehfr1987

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
