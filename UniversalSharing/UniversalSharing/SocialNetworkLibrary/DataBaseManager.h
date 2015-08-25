//
//  DataBAseManager.h
//  UniversalSharing
//
//  Created by Roman on 8/17/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import "User.h"
#import "Post.h"
#import <sqlite3.h>

@interface DataBaseManager : NSObject 

+ (DataBaseManager*)sharedManager;

- (void)insertIntoTable:(id) object;
//==
- (NSMutableArray*)obtainAllUsers;
- (NSMutableArray*)obtainAllPosts;
- (NSMutableArray*)obtainAllPostsWithUserId :(NSString*) userId;
- (NSArray*)obtainPostsWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType;
- (User*)obtainUsersWithNetworkType :(NSInteger) networkType;
//===
- (void)editPost :(Post*) post;
- (void)editUser :(User*) user;
//===
- (void)deletePostByUserId :(NSString*) userId;
- (void)deleteUserByClientId :(NSString*) clientId;


// maybe come in handy when something would be changed

//- (void)deletePostByPrimeryId :(NSInteger) primeryId;
//- (void) updateUserIsVisible : (User*) user;
//- (void)deleteUserByPrimeryId :(NSInteger) primeryId;

@end