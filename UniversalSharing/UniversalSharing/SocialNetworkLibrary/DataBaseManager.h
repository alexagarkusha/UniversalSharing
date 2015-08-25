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

#warning "why database in h file?"

@interface DataBaseManager : NSObject {
    sqlite3 *_database;
}

+ (DataBaseManager*)sharedManager;

- (void)insertIntoTable:(id) object;

#warning "Some methods gets objects (User or Post), another just ID"

#warning "Change methods name. F.ex. obtainAllUsers, obtainAllPosts, etc"

- (NSMutableArray*)obtainAllRowsFromTableNamedUsers;
- (NSMutableArray*)obtainAllRowsFromTableNamedPosts;
- (NSMutableArray*)obtainAllRowsFromTableNamedPostsWithUserId :(NSString*) userId;
- (NSArray*)obtainRowsFromTableNamedPostsWithReason :(NSInteger) reason andNetworkType :(NSInteger) networkType;//while so because we have two projects))
- (User*)obtainRowsFromTableNamedUsersWithNetworkType :(NSInteger) networkType;

#warning "Primary, not Primery"
- (void)deletePostByUserId :(NSString*) userId;
- (void)deletePostByPrimeryId :(NSInteger) primeryId;
- (void)editPostByPrimeryId :(Post*) post;

- (void)deleteUserByPrimeryId :(NSInteger) primeryId;

#warning "Incorrect name and getting parameter. Should be editUser:"
- (void)editUserByClientIdAndNetworkType :(User*) user;
#warning "Is it necessary have 2 methods for edit user?"
- (void) updateUserIsVisible : (User*) user;

- (void)deleteUserByClientId :(NSString*) clientId;

@end