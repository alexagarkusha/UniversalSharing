//
//  MUSDatabaseRequestStringsHelper.h
//  UniversalSharing
//
//  Created by Roman on 8/27/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import "User.h"
#import "Post.h"


////use
//@class User;
//@class Post;
//and remove they header file in .m file
@interface MUSDatabaseRequestStringsHelper : NSObject

#warning "Read https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html#//apple_ref/doc/uid/20001282-BCIGIJJF"

+ (NSString*) createStringForPostWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType;
+ (NSString*) createStringForPostWithUserId :(NSString*) userId;
+ (NSString*) createStringForPostWithPostId :(NSString*) PostId;
+ (NSString*) createStringForAllPosts;
+ (NSString*) createStringUsersForUpdateWithObjectUser :(User*) user;
+ (NSString*) createStringPostsForUpdateWithObjectPost :(Post*) post;
+ (NSString*) createStringLocationsForUpdateWithObjectPost :(Post*) post;
+ (NSString*) createStringPostsForUpdateWithObjectPostForVK :(Post*) post;
+ (NSString*) createStringUsersTable;
+ (NSString*) createStringLocationsTable;
+ (NSString*) createStringPostsTable;
+ (NSString*) createStringForSavePostToTable;
+ (NSString*) createStringForSaveLocationToTable;
+ (NSString*) createStringForLocationId;
+ (NSString*) createStringForSaveUserToTable;
+ (NSString*) createStringForAllUsers;
+ (NSString*) createStringForUsersWithNetworkType :(NSInteger) networkType;
+ (NSString*) createStringForLocationsWithLocationId :(NSString*) locationId;
+ (NSString*) createStringForDeleteLocationWithLocationId :(NSString*) locationId;
+ (NSString*) createStringForDeleteLocationWithUserId :(NSString*) userId;
+ (NSString*) createStringForDeleteUserWithClientId :(NSString*) clientId;
+ (NSString*) createStringForDeletePostWithPrimaryKey :(NSInteger) primaryKey;
+ (NSString*) createStringForDeletePostWithUserId :(NSString*) userId;
@end
