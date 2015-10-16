//
//  VKNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/22/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//


#import "MUSSocialNetwork.h"

@interface VKNetwork : MUSSocialNetwork

/*!
 @abstract return an instance of the social network in a single copy. Singleton method.
 */
+ (VKNetwork*) sharedManager;

@end
