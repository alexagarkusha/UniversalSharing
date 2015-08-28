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
#import "Place.h"


@interface DataBaseManager : NSObject 

+ (DataBaseManager*)sharedManager;
//===
- (void)insertIntoTable:(id) object;
//==
//- (NSMutableArray*)obtainAllUsers;//will be deleted
//- (User*)obtainUsersWithNetworkType :(NSInteger) networkType;//will be deleted
- (NSMutableArray*)obtainAllPosts;///will be deleted
- (NSMutableArray*)obtainAllPostsWithUserId :(NSString*) userId;///will be deleted
- (NSArray*)obtainPostsWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType;///will be deleted

//===
- (void)editPost :(Post*) post;///will be deleted
//- (void)editUser :(User*) user;///will be deleted
//===
//- (void)deletePostByUserId :(NSString*) userId;
- (void)deletePostByPrimaryKey :(Post*) post;
- (void)deleteUserByClientId :(NSString*) clientId;


///////////////////////////////////////////////////////////////////////////////////////////////


- (void) editObjectAtDataBaseWithRequestString : (NSString*) requestString;// it would be a method for edit
- (NSMutableArray*)obtainPostsFromDataBaseWithRequestString : (NSString*) requestString;
- (NSMutableArray*)obtainUsersFromDataBaseWithRequestString : (NSString*) requestString;

@end