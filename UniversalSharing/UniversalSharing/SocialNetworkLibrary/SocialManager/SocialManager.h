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

/*!
 @abstract return an instance of the social network in a single copy. Singleton method.
*/

+ (SocialManager*) sharedManager;

/*!
 @abstract returns the first available social network, which has the status of a isLogin YES
*/
+ (SocialNetwork*) currentSocialNetwork;

/*!
 @abstract Returns a list of social networks in a user-defined order
 @param arrayWithNetwork contains the order of social networks by their type (NetworkType = Facebook, VKontakt or Twitters);
 */

- (NSMutableArray*) networks :(NSArray*) arrayWithNetwork;

- (NSMutableArray*) activeSocialNetworks;

- (void) obtainNetworksWithComplition :(ComplitionWithArrays) block;
- (void) editNetworks;


@end
