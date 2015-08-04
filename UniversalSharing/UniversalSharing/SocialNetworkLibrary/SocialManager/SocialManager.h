//
//  LoginManager.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialNetwork.h"

@interface SocialManager : NSObject

+ (SocialManager*) sharedManager;
+ (SocialNetwork*) currentSocialNetwork;
- (NSMutableArray*) networks :(NSArray*) arrayWithNetwork;
@end
