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
#import "NetworkPost.h"


@interface DataBaseManager : NSObject 

+ (DataBaseManager*)sharedManager;
//===
- (void)insertIntoTable:(id) object;
//===
- (void) deletePostByPrimaryKey :(Post*) post;
- (void) deleteUserByClientId :(NSString*) clientId;
- (void) deleteObjectFromDataDase : (NSString*) deleteSQL;
//===
- (void) editObjectAtDataBaseWithRequestString : (NSString*) requestString;
- (NSMutableArray*)obtainPostsFromDataBaseWithRequestString : (NSString*) requestString;
- (NSMutableArray*)obtainUsersFromDataBaseWithRequestString : (NSString*) requestString;
///////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)obtainNetworkPostsFromDataBaseWithRequestStrings : (NSString*) requestString;
- (NSInteger) saveNetworkPostToTableWithObject :(NetworkPost*) networkPost;
- (NetworkPost*)obtainNetworkPostsFromDataBaseWithRequestString : (NSString*) requestString;

@end