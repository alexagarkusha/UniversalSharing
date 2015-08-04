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
//#warning "Check if networks types repeads in array"
//#warning "Replace switch in SocialNetwork class"
//#warning "Update for on block"

- (NSMutableArray*) networks :(NSArray*) arrayWithNetwork {
    //Check if networks types repeads in array
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayWithNetwork];
    NSArray *arrayWithNetworkWithoutDuplicates = [orderedSet array];
    
#warning "change parameter name to avoid problems"
#warning "why arrayWithNetwork[idx]?"
    NSMutableArray *arrayWithNetworks = [NSMutableArray new];
    [arrayWithNetworkWithoutDuplicates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [arrayWithNetworks addObject:[SocialNetwork sharedManagerWithType: [arrayWithNetwork[idx] integerValue]]];
    }];    
    return arrayWithNetworks;
}

@end
