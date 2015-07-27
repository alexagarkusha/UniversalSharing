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

- (NSArray*) networks {
    FacebookNetwork *facebookNetwork = [FacebookNetwork sharedManager];//[[FacebookNetwork alloc]init] is THE fucking mistake!!!
    VKNetwork *vkNetwork = [VKNetwork sharedManager];
    TwitterNetwork *twitterNetwork = [TwitterNetwork sharedManager];
    self.arrayWithNetworks = [[NSArray alloc ]initWithObjects:facebookNetwork, vkNetwork, twitterNetwork, nil];
    return self.arrayWithNetworks;
}

- (void) loginForTypeNetwork:(NetworkType)networkIdentifier :(Complition)block{
    
    SocialNetwork *socialNetwork = [self p_determinationOfTheTypeOfSocialNetwork:networkIdentifier];
   
    if (!socialNetwork) {
        //TODO: error
        return;
    }
    
    if (socialNetwork.isLogin) {//it does not need))
        block(socialNetwork,nil);
    }else{
        [socialNetwork loginWithComplition:^(id result, NSError *error) {
            block(result,error);
        }];
    }
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
