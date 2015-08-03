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
#import "Place.h"

@interface FacebookNetwork()<FBSDKGraphRequestConnectionDelegate>

@property (copy, nonatomic) Complition copyPostComplition;
@property (strong, nonatomic) NSString *firstPlaceId;

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

#pragma mark - loginInNetwork

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

#pragma mark - obtainUserFromNetwork

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

#pragma mark - sharePost

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
    if (post.arrayImages.count == 1) {
        [self postImageToFB: post];
    } else if (post.arrayImages.count > 1) {
        NSLog(@"New");
    } else {
        [self postMessageToFB: post];
    }
}


- (void) obtainArrayOfPlaces: (Location *)location withComplition: (ComplitionPlaces) block {
    NSString *currentLocation = [NSString stringWithFormat:@"%@,%@", location.latitude, location.longitude];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"q"] = location.q;
    params[@"type"] = location.type;
    params[@"center"] = currentLocation;
    params[@"distance"] = location.distance;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:  @"/search?"
                                                                   parameters:  params
                                                                   HTTPMethod:  @"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (result) {
            NSDictionary *resultDictionary = result;
            NSArray *places = [resultDictionary objectForKey: @"data"];
            //NSDictionary *firstPlace = [placeArray firstObject];
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
            
            //self.firstPlaceId = [firstPlace objectForKey:@"id"];
            
        }
        //NSLog(@"result = %@", result);
        //NSLog(@"error = %@", error);
        //NSLog(@"connection = %@", connection);
    }];
}


/*
- (void) determinationOfCurrentLocationAndPostToFB : (Post*) post {
    NSString *location = [NSString stringWithFormat:@"%f,%f", post.latitude, post.longitude];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"q"] = @"";
    params[@"type"] = @"place";
    params[@"center"] = location;
    params[@"distance"] = @"100";

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:  @"/search?"
                                         parameters:  params
                                         HTTPMethod:  @"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (result) {
            NSDictionary *resultDic = result;
            NSArray *placeArray = [resultDic objectForKey: @"data"];
                NSDictionary *firstPlace = [placeArray firstObject];
                self.firstPlaceId = [firstPlace objectForKey:@"id"];
            
                if (!post.imageToPost.image) {
                    [self postMessageToFB: post withLocationID: self.firstPlaceId];
                } else {
                    [self postImageToFB: post withLocationID: self.firstPlaceId];
                }
        }
        NSLog(@"result = %@", result);
        NSLog(@"error = %@", error);
        NSLog(@"connection = %@", connection);
    }];
}
*/ //DELETE THIS PARTs

#warning "Move methods to constants"

- (void) postMessageToFB : (Post*) post {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"message"] = post.postDescription;
    
    if (post.placeID) params[@"place"] = post.placeID;

    [[[FBSDKGraphRequest alloc] initWithGraphPath: @"me/feed"
                                       parameters: params
                                       HTTPMethod: @"POST"]
                       startWithCompletionHandler:
     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
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
    ImageToPost *imageToPost = [post.arrayImages firstObject];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"message"] = post.postDescription;
    params[@"picture"] = imageToPost.image;

    if (post.placeID) params[@"place"] = post.placeID;

    [[[FBSDKGraphRequest alloc] initWithGraphPath: @"me/photos"
                                       parameters: params
                                       HTTPMethod: @"POST"]
                       startWithCompletionHandler:
     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
     
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
