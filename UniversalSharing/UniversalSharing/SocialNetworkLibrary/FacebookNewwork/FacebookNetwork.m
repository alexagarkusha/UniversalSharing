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
@interface FacebookNetwork()<FBSDKGraphRequestConnectionDelegate>
@end

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
        }
    }
    return self;
}

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
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
            block(weakSell,nil);
        });
    }];

    
}

- (void) loginWithComplition :(Complition) block {    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    self.isLogin = YES;

    __weak FacebookNetwork *weakSell = self;
//     if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
//         [self obtainInfoFromNetworkWithComplition:block];
//     }else{
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            block(nil, error);
        } else if (result.isCancelled) {
            block(nil, error);
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                
                
                [weakSell obtainInfoFromNetworkWithComplition:block];
                
            }
        }
    }];
     //}
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    
}
- (void) sharePostToNetwork : (id) sharePost {
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
       UIImage *image = [UIImage imageNamed:@"FBimage.jpg"];
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        params[@"message"] = @"WWWWW";
        //params[@"picture"] = UIImageJPEGRepresentation(image, 0.8f);
        /* make the API call */
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/feed"///me/photos
                                      parameters:params
                                      HTTPMethod:@"POST"];
        
        FBSDKGraphRequestConnection *requestConnection  = [[FBSDKGraphRequestConnection alloc]init];
        [requestConnection addRequest:request completionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                  id result,
                                                                  NSError *error)
         {
             if (!error)
             {
                 
             }
             else
             {
                 
             }
         }];
        requestConnection.delegate = self;
        [requestConnection start];

        

    } else {

        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            UIImage *image = [UIImage imageNamed:@"FBimage.jpg"];
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            params[@"message"] = @"WWWWW";
            params[@"picture"] = UIImageJPEGRepresentation(image, 0.8f);
            /* make the API call */
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me/photos"
                                          parameters:params
                                          HTTPMethod:@"POST"];
            
            FBSDKGraphRequestConnection *requestConnection  = [[FBSDKGraphRequestConnection alloc]init];
            [requestConnection addRequest:request completionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                      id result,
                                                                      NSError *error)
             {
                 if (!error)
                 {
                     
                 }
                 else
                 {
                     
                 }
             }];
            requestConnection.delegate = self;
            [requestConnection start];

            
                    }];
    }
}

- (void) initiationPropertiesWithoutSession {
    self.title = @"Login Facebook";
    self.icon = @"FBimage.jpg";
    self.isLogin = NO;
    self.currentUser = nil;
}

- (void) loginOut {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [self initiationPropertiesWithoutSession];
}


@end
