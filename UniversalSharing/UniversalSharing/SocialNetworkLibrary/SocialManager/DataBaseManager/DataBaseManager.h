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
- (void)insertObjectIntoTable:(id) object;
//===
- (void) deleteObjectFromDataBaseWithRequestStrings : (NSString*) requestString;
//===
- (void) editObjectAtDataBaseWithRequestString : (NSString*) requestString;
- (NSMutableArray*)obtainPostsFromDataBaseWithRequestString : (NSString*) requestString;
- (NSMutableArray*)obtainUsersFromDataBaseWithRequestString : (NSString*) requestString;
//===
- (NSMutableArray*)obtainNetworkPostsFromDataBaseWithRequestString : (NSString*) requestString;
- (NetworkPost*)obtainNetworkPostFromDataBaseWithRequestString : (NSString*) requestString;
//===
- (NSInteger) saveNetworkPost :(NetworkPost*) networkPost;
@end