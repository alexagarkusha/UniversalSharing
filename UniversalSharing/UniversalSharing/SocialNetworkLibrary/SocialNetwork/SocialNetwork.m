//
//  SocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialNetwork.h"
#import "FacebookNetwork.h"
#import "VKNetwork.h"
#import "TwitterNetwork.h"

@implementation SocialNetwork

+ (SocialNetwork*) sharedManagerWithType : (NetworkType) networkType {
    switch (networkType) {
        case Facebook:{
            FacebookNetwork *facebookNetwork = [FacebookNetwork sharedManager];
            return facebookNetwork;
            break;
        }
        case Twitters:{
            TwitterNetwork *twitterNetwork = [TwitterNetwork sharedManager];
            return twitterNetwork;
            break;
        }
        case VKontakt:{
            VKNetwork *vkNetwork = [VKNetwork sharedManager];
            return vkNetwork;
            break;
        }
        default:
            break;
    }
}

- (void) loginWithComplition :(Complition) block {
}

- (void) loginOut {
}

- (void)setNetworkType:(NetworkType)networkType {
    _networkType = networkType;
}

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
    
    
}

- (void) sharePost : (Post*) post withComplition : (Complition) block {
    
}



@end
