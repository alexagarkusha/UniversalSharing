//
//  FacebookManager.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialNetwork.h"

@interface FacebookNetwork : SocialNetwork
+ (FacebookNetwork*) sharedManager;
@end
