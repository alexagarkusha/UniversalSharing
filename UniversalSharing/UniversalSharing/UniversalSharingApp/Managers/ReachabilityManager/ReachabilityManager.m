//
//  ReachabilityManager.m
//  UniversalSharing
//
//  Created by U 2 on 07.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "ReachabilityManager.h"


@implementation ReachabilityManager

#pragma mark Default Manager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark Memory Management

- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark Class Methods

+ (BOOL) isReachable {
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL) isUnreachable {
    return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL) isReachableViaWWAN {
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL) isReachableViaWiFi {
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark Private Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        //self.reachability.isReachable
        //self.reachability.reachableOnWWAN = NO;
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

@end
