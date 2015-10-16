//
//  ReachabilityManager.m
//  UniversalSharing
//
//  Created by U 2 on 07.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "ReachabilityManager.h"
#import "MUSSocialNetworkLibraryConstants.h"

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

#pragma mark Private Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityWithHostname:MUSReachabilityManager_Host_Name];
        [self.reachability startNotifier];
    }
    return self;
}

#pragma mark Memory Management

- (void)dealloc {
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

@end
