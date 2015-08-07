//
//  User.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface User : NSObject

/*!
 @abstract username received after user logged in SocialNetwork. Like 'Tom Smith'
*/
@property (strong, nonatomic) NSString *username;
/*!
 @abstract firstName received after user logged in SocialNetwork. Like 'Tom'
 */
@property (strong, nonatomic) NSString *firstName;
/*!
 @abstract lastName received after user logged in SocialNetwork. Like 'Smith'
 */
@property (strong, nonatomic) NSString *lastName;
/*!
 @abstract dateOfBirth received after user logged in SocialNetwork.
*/
@property (strong, nonatomic) NSString *dateOfBirth;
/*!
 @abstract city received after user logged in SocialNetwork. Like 'Berlin'
 */
@property (strong, nonatomic) NSString *city;
/*!
 @abstract clientID received after user logged in SocialNetwork. Like '53217400'
 */
@property (strong, nonatomic) NSString *clientID;
/*!
 @abstract photoURL received after user logged in SocialNetwork.
*/
@property (strong, nonatomic) NSString *photoURL;
/*!
 @abstract type of Social network. (like Facebook, Twitters, Vkontakte)
 */
@property (assign, nonatomic) NetworkType networkType;


/*!
 @abstract return an instance of the User.
 @param dictionary takes dictionary from social network.
 @param networkType takes the type of social network (like Facebook, Twitters, Vkontakte)
*/
+ (User*) createFromDictionary:(id) dict andNetworkType :(NetworkType) networkType;

@end
