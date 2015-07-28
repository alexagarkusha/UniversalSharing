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
    
    for (int i = 0; i < arrayWithNetwork.count; i++) {
        
        self.networkType = [arrayWithNetwork[i] integerValue];
        switch (self.networkType) {
            case Facebook:{
                FacebookNetwork *facebookNetwork = [FacebookNetwork sharedManager];
                [arrayWithNetworks addObject:facebookNetwork];
                break;
            }
            case Twitters:{
                TwitterNetwork *twitterNetwork = [TwitterNetwork sharedManager];
                [arrayWithNetworks addObject:twitterNetwork];
                break;
            }
            case VKontakt:{
                VKNetwork *vkNetwork = [VKNetwork sharedManager];
                [arrayWithNetworks addObject:vkNetwork];
                break;
            }
            default:
                break;
        }
    }
        return arrayWithNetworks;
}

//- (SocialNetwork*) p_determinationOfTheTypeOfSocialNetwork : (NetworkType) networkType {
//    SocialNetwork *socialNetwork = nil;//[[SocialNetwork alloc] init];
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"networkType == %d", networkType];
//    NSArray *filteredArray = [self.arrayWithNetworks filteredArrayUsingPredicate:predicate];
//
//    if (filteredArray.count > 0) {
//        socialNetwork = (SocialNetwork*) [filteredArray firstObject];
//    }
//    return socialNetwork;
//}

@end
