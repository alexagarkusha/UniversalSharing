//
//  FacebookManager.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialNetwork.h"

@interface FacebookNetwork : SocialNetwork

/*!
 @abstract return an instance of the social network in a single copy. Singleton method.
 */

+ (FacebookNetwork*) sharedManager;

@end
