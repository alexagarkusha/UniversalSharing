//
//  TwitterNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/23/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//


#import "MUSSocialNetwork.h"

@interface TwitterNetwork : MUSSocialNetwork

/*!
 @abstract return an instance of the social network in a single copy. Singleton method.
 */
+ (TwitterNetwork*) sharedManager;

@end
