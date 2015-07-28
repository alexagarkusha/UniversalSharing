//
//  LoginManager.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface SocialManager : NSObject
@property (strong, nonatomic) NSArray *arrayWithNetworks;

+ (SocialManager*) sharedManager;

- (NSArray*) networks :(NSArray*) arrrayWithNetworks;
@end
