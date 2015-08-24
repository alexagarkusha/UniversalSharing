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
- (NSMutableArray*)obtainAllRowsFromTableNamedUsers;
- (NSMutableArray*)obtainAllRowsFromTableNamedPosts;
- (NSMutableArray*)obtainAllRowsFromTableNamedPostsWithUserId :(NSString*) userId;
- (NSArray*)obtainRowsFromTableNamedPostsWithReason :(NSInteger) reason andNetworkType :(NSInteger) networkType;//while so because we have two projects))
- (User*)obtainRowsFromTableNamedUsersWithNetworkType :(NSInteger) networkType;

- (void)deletePostByUserId :(NSString*) userId;
- (void)deletePostByPrimeryId :(NSInteger) primeryId;
- (void)editPostByPrimeryId :(Post*) post;

- (void)deleteUserByPrimeryId :(NSInteger) primeryId;
- (void)editUserByClientIdAndNetworkType :(User*) user;
- (void) updateUserIsVisible : (User*) user;

- (void)deleteUserByClientId :(NSString*) clientId;
@end