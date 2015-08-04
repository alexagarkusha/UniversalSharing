//
//  SocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialNetwork.h"
#import "SocialManager.h"
#import "FacebookNetwork.h"
#import "VKNetwork.h"
#import "TwitterNetwork.h"
@implementation SocialNetwork

+ (SocialNetwork*) sharedManagerWithType :(NetworkType) networkType {
    SocialNetwork *socialNetwork = nil;
    switch (networkType) {
        case Facebook:{
            socialNetwork = [FacebookNetwork sharedManager];
            break;
        }
        case Twitters:{
            socialNetwork = [TwitterNetwork sharedManager];
            break;
        }
        case VKontakt:{
            socialNetwork = [VKNetwork sharedManager];
            break;
        }
        default:
            break;
    }
    return socialNetwork;
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

- (void) obtainArrayOfPlaces : (Location*) location withComplition : (ComplitionPlaces) block {
    
}



@end
