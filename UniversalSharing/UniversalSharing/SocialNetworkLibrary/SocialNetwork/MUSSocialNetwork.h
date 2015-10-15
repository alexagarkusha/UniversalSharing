//
//  SocialNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MUSUser.h"
#import "MUSPost.h"
#import "MUSLocation.h"
#import "MUSSocialNetworkLibraryConstants.h"

@interface MUSSocialNetwork : NSObject
/*!
 @abstract whether the user is logged into a social network or not
*/
@property (assign, nonatomic) BOOL isLogin;
/*!
 @abstract icon of Social Network
 */
@property (strong, nonatomic) NSString *icon;
/*!
 @abstract title of Social Network
 */
@property (strong, nonatomic) NSString *title;
/*!
 @abstract name of Social Network
 */
@property (strong, nonatomic) NSString *name;
/*!
 @abstract logged user of social network
 */
@property (strong, nonatomic) MUSUser *currentUser;
/*!
 @abstract type of social network (like Facebook, Twitters, Vkontakte)
 */
@property (assign, nonatomic) NetworkType networkType;

/*!
 @abstract set type of social network (like Facebook, Twitters or Vkontakte)
 */
- (void) setNetworkType:(NetworkType)networkType;

/*!
 Login in social network
 @param completion The completion block will be called after authentication is successful or if there is an error.
*/
- (void) loginWithComplition :(Complition) block;

/*!
 Logout from social network
 Current user for social network become nil
 And initiation properties of VKNetwork without session
*/
- (void) logout;

/*!
 @param completion The completion block will be called after authentication and will fill properties for logged user (current user in Social network) or if there is an error.
 @warning This method requires that you have been login in Social Network.
*/
- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block;

/*!
 @abstract return message with status of shared post.
 @params current post of @class Post
 @warning This method requires that you have been login in Social Network.
*/
- (void) sharePost : (MUSPost*) post withComplition : (Complition) block loadingBlock :(LoadingBlock) loadingBlock;

/*!
 @abstract return a list of objects like @class Place found by the search params.
 @params object of @class Location (current location of user)
 @warning This method requires that you have been login in Social Network.
 */
- (void) obtainPlacesArrayForLocation : (MUSLocation*) location withComplition : (Complition) block;

- (void) updateNetworkPostWithComplition : (UpdateNetworkPostsBlock) updateNetworkPostsBlock;

- (void) updateUserInSocialNetwork;

- (NSError*) errorConnection;


@end
