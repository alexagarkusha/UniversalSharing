//
//  InternetConnectionManager.m
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "InternetConnectionManager.h"
#import "ReachabilityManager.h"

static InternetConnectionManager *model = nil;

@implementation InternetConnectionManager

+ (InternetConnectionManager*) manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[InternetConnectionManager alloc] init];
    });
    return  model;
}

- (BOOL) isInternetConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    if (!isReachableViaWiFi && !isReachable){
        return NO;
    }
    return YES;
}


@end
