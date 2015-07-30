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


- (void) sharePost : (Post*) post {
    __weak VKNetwork *weakSell = self;
    
    NSInteger userId = [self.currentUser.clientID integerValue];
    UIImage *postImage = [UIImage imageWithData:post.photoData];
    
    VKRequest * request = [VKApi uploadWallPhotoRequest: postImage parameters:[VKImageParameters pngImage] userId: userId groupId:0 ];
    
    [request executeWithResultBlock: ^(VKResponse *response) {
        
        VKPhoto *photoInfo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        NSString *photoAttachment = [NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id];
        NSString *lalitude = [NSString stringWithFormat:@"%f", post.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", post.longitude];
    
        VKRequest *post = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : photoAttachment, VK_API_OWNER_ID : weakSell.currentUser.clientID, VK_API_MESSAGE : post.description ,VK_API_LAT : lalitude ,VK_API_LONG : longitude }];
        
        [post executeWithResultBlock: ^(VKResponse *response) {
            NSLog(@"Result: %@", @"Posted");
            
        } errorBlock: ^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } errorBlock: ^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}




/*
- (void) sharePostToNetwork : (id) sharePost {
    
    __weak VKNetwork *weakSell = self;

    NSInteger userId = [self.currentUser.clientID integerValue];
    VKRequest * request = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"VKimage.png"] parameters:[VKImageParameters pngImage] userId:userId groupId:0 ];
    [request executeWithResultBlock: ^(VKResponse *response) {
        
        VKPhoto *photoInfo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        NSString *photoAttachment = [NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id];
        
        VKRequest *post = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : photoAttachment, VK_API_OWNER_ID : weakSell.currentUser.clientID, VK_API_MESSAGE : @"TestLALALLAA",VK_API_LAT : @"34.9229100",VK_API_LONG : @"33.6233000" }];
        
        [post executeWithResultBlock: ^(VKResponse *response) {
            NSLog(@"Result: %@", @"Posted");
           
        } errorBlock: ^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } errorBlock: ^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
*/
 
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
