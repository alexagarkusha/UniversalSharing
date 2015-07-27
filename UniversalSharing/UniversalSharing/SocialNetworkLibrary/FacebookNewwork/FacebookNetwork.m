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

static FacebookNetwork *model = nil;

@implementation FacebookNetwork
+ (FacebookNetwork*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[FacebookNetwork alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkType = Facebook;
        if (![FBSDKAccessToken currentAccessToken]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
            [self obtainDataFromFacebook];
        }
    }
    return self;
}

- (void) obtainDataFromFacebook {
    __weak FacebookNetwork *weakSell = self;
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me"
                                                                  parameters:@{@"fields": kRequestParametrsFacebook}
                                                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        weakSell.currentUser = [User createFromDictionary:result andNetworkType : weakSell.networkType];
        weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
        weakSell.icon = weakSell.currentUser.photoURL;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[[NSNotificationCenter defaultCenter] postNotificationName:notificationReloadTableView object:nil];
        });
    }];
}

- (void) loginWithComplition :(Complition) block {    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    __weak FacebookNetwork *weakSell = self;
    
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            block(nil, error);
        } else if (result.isCancelled) {
            block(nil, error);
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":kRequestParametrsFacebook }]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *result, NSError *error) {
                         if (error) {
                             block(nil, error);
                             return ;
                         }
                         weakSell.currentUser = [User createFromDictionary:result andNetworkType : weakSell.networkType];
                         weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
                         weakSell.icon = weakSell.currentUser.photoURL;
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             block(weakSell, error);
                             //[[NSNotificationCenter defaultCenter] postNotificationName:notificationReloadTableView object:nil];
                         });
                     }];
                }
            }
        }
    }];
}

- (void) initiationPropertiesWithoutSession {
    self.title = @"Login Facebook";
    self.icon = @"FBimage.jpg";
    self.isLogin = NO;
}

- (void) loginOut {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}


@end
