//
//  TwitterNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/23/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#warning "Create folder for this class"

#import "SocialNetwork.h"

@interface TwitterNetwork : SocialNetwork

/*!
 @abstract return an instance of the social network in a single copy. Singleton method.
 */
+ (TwitterNetwork*) sharedManager;

@end
