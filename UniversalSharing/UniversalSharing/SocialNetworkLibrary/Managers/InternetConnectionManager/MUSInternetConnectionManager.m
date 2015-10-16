//
//  InternetConnectionManager.m
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSInternetConnectionManager.h"
#import "ReachabilityManager.h"

static MUSInternetConnectionManager *model = nil;

@implementation MUSInternetConnectionManager

+ (MUSInternetConnectionManager*) connectionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSInternetConnectionManager alloc] init];
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
