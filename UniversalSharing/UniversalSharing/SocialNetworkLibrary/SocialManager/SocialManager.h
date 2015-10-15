//
//  LoginManager.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetwork.h"

@interface SocialManager : NSObject

/*!
 @abstract return an instance of the social network in a single copy. Singleton method.
*/

+ (SocialManager*) sharedManager;

/*!
 @abstract Returns a list of social networks in a user-defined order
 */
- (NSMutableArray*) allNetworks;

- (NSMutableArray*) networksForKeys: (NSArray*) keysArray; ///

//- (SocialNetwork*) networkForKey: (NSNumber*) key;

- (void) configurateWithNetworkClasses: (NSDictionary*) networksWithKeys;

@end
