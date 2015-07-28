//
//  LoginManager.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialManager.h"

#import "FacebookNetwork.h"
#import "VKNetwork.h"
#import "TwitterNetwork.h"

static SocialManager *model = nil;

@implementation SocialManager
+ (SocialManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SocialManager alloc] init];
    });
    return  model;
}


#warning "Add availability to choose networks and they position, means just Twitter or VK and FB"

- (NSArray*) networks :(NSArray*) arrrayWithNetworks {
    FacebookNetwork *facebookNetwork = [FacebookNetwork sharedManager];//[[FacebookNetwork alloc]init] is THE fucking mistake!!!
    VKNetwork *vkNetwork = [VKNetwork sharedManager];
    TwitterNetwork *twitterNetwork = [TwitterNetwork sharedManager];
    self.arrayWithNetworks = [[NSArray alloc ]initWithObjects:facebookNetwork, vkNetwork, twitterNetwork, nil];
    return self.arrayWithNetworks;
}

- (SocialNetwork*) p_determinationOfTheTypeOfSocialNetwork : (NetworkType) networkType {
    SocialNetwork *socialNetwork = nil;//[[SocialNetwork alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"networkType == %d", networkType];
    NSArray *filteredArray = [self.arrayWithNetworks filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        socialNetwork = (SocialNetwork*) [filteredArray firstObject];
    }
    return socialNetwork;
}

@end
