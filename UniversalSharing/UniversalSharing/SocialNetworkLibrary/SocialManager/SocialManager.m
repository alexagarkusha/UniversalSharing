//
//  LoginManager.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialManager.h"
#import "MUSSocialNetworkLibraryConstants.h"

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

+ (SocialNetwork*) currentSocialNetwork {
    SocialNetwork *currentSocialNetwork = nil;
    NSArray *accountsArray = [[SocialManager sharedManager] networks:@[@(Twitters), @(VKontakt), @(Facebook)]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogin == %d", YES];
    NSArray *filteredArray = [accountsArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        currentSocialNetwork = (SocialNetwork*) [filteredArray firstObject];
    }
    return currentSocialNetwork;
}


- (NSMutableArray*) networks :(NSArray*) arrayWithNetwork {
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayWithNetwork];
    NSArray *arrayWithNetworkWithoutDuplicates = [orderedSet array];
    
    NSMutableArray *arrayWithNetworks = [NSMutableArray new];
    [arrayWithNetworkWithoutDuplicates enumerateObjectsUsingBlock:^(id obj, NSUInteger currentIndex, BOOL *stop) {
        [arrayWithNetworks addObject:[SocialNetwork sharedManagerWithType: [arrayWithNetwork[currentIndex] integerValue]]];
    }];    
    return arrayWithNetworks;
}

@end
