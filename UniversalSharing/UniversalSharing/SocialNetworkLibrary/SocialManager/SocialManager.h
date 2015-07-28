//
//  LoginManager.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MUSSocialNetworkLibraryConstants.h"

@interface SocialManager : NSObject

+ (SocialManager*) sharedManager;
- (NSArray*) networks :(NSArray*) arrayWithNetwork;
@end
