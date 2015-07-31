//
//  LoginManager.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialManager.h"
#import "MUSSocialNetworkLibraryConstants.h"

#import "FacebookNetwork.h"
#import "VKNetwork.h"
#import "TwitterNetwork.h"
@interface SocialManager()
@property (assign, nonatomic) NetworkType networkType;
@end
static SocialManager *model = nil;

@implementation SocialManager
+ (SocialManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SocialManager alloc] init];
    });
    return  model;
}


//#warning "Add availability to choose networks and they position, means just Twitter or VK and FB"

- (NSArray*) networks :(NSArray*) arrayWithNetwork {
    NSMutableArray *arrayWithNetworks = [NSMutableArray new];

#warning "Update for on block"
//    [arrayWithNetwork enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        <#code#>
//    }];
    
//#warning "Check if networks types repeads in array"
//#warning "Replace switch in SocialNetwork class"
    
    for (int i = 0; i < arrayWithNetwork.count; i++) {
        self.networkType = [arrayWithNetwork[i] integerValue];
        SocialNetwork * socialNetwork = [SocialNetwork sharedManagerWithType: self.networkType];
        [arrayWithNetworks addObject: socialNetwork];
    }
    
    return arrayWithNetworks;
}

@end
