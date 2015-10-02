//
//  SocialNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Post.h"
#import "Location.h"
#import "MUSSocialNetworkLibraryConstants.h"

@interface SocialNetwork : NSObject

/*!
 @abstract whether the user is logged into a social network or not
*/
@property (assign, nonatomic) BOOL isLogin;

/*!
 @abstract lock appear in the social network application. The visibility state of Social network selects the user
*/
@property (assign, nonatomic) BOOL isVisible;

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
@property (strong, nonatomic) User *currentUser;

@property (strong, nonatomic) NSTimer *timer;
/*!
 @abstract type of social network (like Facebook, Twitters, Vkontakte)
 */
@property (assign, nonatomic) NetworkType networkType;

//@property (assign, nonatomic) NSInteger indexPosition;


/*!
 @abstract return object of SocialNetwork with the given type of social network
 @param networkType takes the type of social network (like Facebook, Twitters, Vkontakte)
*/

+ (SocialNetwork*) sharedManagerWithType :(NetworkType) networkType;


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

- (void) loginOut;

/*!
 @param completion The completion block will be called after authentication and will fill properties for logged user (current user in Social network) or if there is an error.
 @warning This method requires that you have been login in Social Network.
*/

- (void) obtainInfoFromNetworkWithComplition :(Complition) block;

/*!
 @abstract return a list of objects like @class Place found by the search params.
 @params object of @class Location (current location of user)
 @warning This method requires that you have been login in Social Network.
 */

- (void) obtainArrayOfPlaces : (Location*) location withComplition : (Complition) block;

/*!
 @abstract return message with status of shared post.
 @params current post of @class Post
 @warning This method requires that you have been login in Social Network.
*/

- (void) sharePost : (Post*) post withComplition : (Complition) block andComplitionLoading :(ComplitionProgressLoading)blockLoading;

- (void) setIsVisible:(BOOL)isVisible;


- (void) removeUserFromDataBaseAndImageFromDocumentsFolder :(User*) user;
//- (BOOL) obtainCurrentConnection;
//- (void) savePostDataBaseWithReason :(ReasonType) reason andPost :(Post*) post;
//- (void) updatePostDataBaseWithReason :(ReasonType) reason andPost :(Post*) post;
//- (void) saveOrUpdatePost : (Post*) post withReason : (ReasonType) reason;
//
- (void) updatePostWithComplition : (ComplitionUpdateNetworkPosts) block;

- (NSError*) errorConnection;

- (void) stopUpdatingPostWithObject : (id) object;


@end
