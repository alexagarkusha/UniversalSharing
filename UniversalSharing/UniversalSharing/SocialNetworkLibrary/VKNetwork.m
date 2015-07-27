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
@end

static VKNetwork *model = nil;
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
            [self obtainDataFromVK];
        }
    }
    return self;
}

- (void) loginWithComplition :(Complition) block {
    self.copyComplition = block;
    if (![VKSdk wakeUpSession])
    {
        [VKSdk authorize:@[VK_PER_NOHTTPS, VK_PER_OFFLINE, VK_PER_PHOTOS, VK_PER_WALL, VK_PER_EMAIL]];
    }
    else
    {
        [self obtainDataFromVK];
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

- (void) obtainDataFromVK
{
    __weak VKNetwork *weakSell = self;
    
    VKRequest * request = [[VKApi users] get:@{ VK_API_FIELDS : ALL_USER_FIELDS }];
    [request executeWithResultBlock:^(VKResponse * response)
     {
         weakSell.currentUser = [User createFromDictionary:(NSDictionary*)[response.json firstObject] andNetworkType:weakSell.networkType];
         weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
         weakSell.icon = weakSell.currentUser.photoURL;
         if(self.copyComplition)
             self.copyComplition(weakSell, nil);
        // [[NSNotificationCenter defaultCenter] postNotificationName:notificationReloadTableView object:nil];
         
     } errorBlock:^(NSError * error) {
         if (error.code != VK_API_ERROR) {
             [error.vkError.request repeat];
         }
         else {
             NSLog(@"VK error: %@", error);
         }
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
    [self obtainDataFromVK];
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
