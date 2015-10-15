//
//  MUSDatabaseRequestStringsHelper.h
//  UniversalSharing
//
//  Created by Roman on 8/27/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"

@class MUSUser;
@class MUSPost;
@class MUSNetworkPost;

@interface MUSDatabaseRequestStringsHelper : NSObject

+ (NSString*) stringForAllPosts;
+ (NSString*) stringForUpdateUser :(MUSUser*) user;
+ (NSString*) stringCreateTableOfUsers;
+ (NSString*) stringCreateTableOfPosts;
///////////////////////////////////////////////

+ (NSString*) stringCreateTableOfNetworkPosts;
+ (NSString*) stringSaveNetworkPost;
+ (NSString*) stringForNetworkPostWithPrimaryKey :(NSInteger) primaryKey;
+ (NSString*) stringForNetworkPostWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType;
+ (NSString*) stringForUpdateNetworkPost :(MUSNetworkPost*) networkPost;

///////////////////////////////////////////////////////

+ (NSString*) stringForSavePost;
+ (NSString*) stringForSaveUser;
+ (NSString*) stringForUserWithNetworkType :(NSInteger) networkType;
+ (NSString*) stringForDeleteUserByClientId :(NSString*) clientId;
+ (NSString*) stringForDeletePostByPrimaryKey :(NSInteger) primaryKey;
+ (NSString*) stringForVKUpdateNetworkPost :(MUSNetworkPost*) networkPost;
+ (NSString*) stringForDeleteNetworkPost : (MUSNetworkPost*) networkPost;
+ (NSString*) stringForUpdatePost :(MUSPost*) post;

@end
