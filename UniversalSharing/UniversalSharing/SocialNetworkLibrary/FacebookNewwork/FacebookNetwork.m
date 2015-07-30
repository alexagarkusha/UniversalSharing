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

@property (copy, nonatomic) Complition copyPostComplition;

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
}

//#warning "Needs to add complition"
//#warning "Fix dublicates"

#warning "LOCATION NOT SHARE TO FB"

- (void) sharePost:(Post *)post withComplition:(Complition)block {
    self.copyPostComplition = block;
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        [self sharePostToFacebook: post];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                [self sharePostToFacebook: post];
            } else {
                self.copyPostComplition (nil, error);
            }
        }];
    }
}

- (void) sharePostToFacebook : (Post*) post {
    if (!post.imageToPost.image) {
        [self postMessageToFB:post];
    } else {
        [self postImageToFB:post];
    }
}



- (void) postMessageToFB : (Post*) post {
        [[[FBSDKGraphRequest alloc]
          initWithGraphPath:@"me/feed"
          parameters: @{ @"message" : post.postDescription }
          HTTPMethod:@"POST"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString *postMessageResult = @"Your message has been successfully sent";
                 self.copyPostComplition (postMessageResult, nil);
                 //NSLog(@"Post id:%@", result[@"id"]);
             } else {
                 self.copyPostComplition (nil, error);
             }
         }];
}


- (void) postImageToFB : (Post*) post {
    //NSString *latitude = [NSString stringWithFormat:@"%f", post.latitude];
    //NSString *longitude = [NSString stringWithFormat:@"%f", post.longitude];
    
    //NSDictionary *location = [[NSDictionary alloc] initWithObjectsAndKeys: latitude, @"latitude", longitude, @"longitude", nil];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"message"] = post.postDescription;
    params[@"picture"] = post.imageToPost.image;
    
    //params[@"location"] = location;

    
    [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"me/photos"
      parameters: params
      HTTPMethod:@"POST"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *postMessageResult = @"Your message has been successfully sent";
             self.copyPostComplition (postMessageResult, nil);
         } else {
             self.copyPostComplition (nil, error);
         }
     }];
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
