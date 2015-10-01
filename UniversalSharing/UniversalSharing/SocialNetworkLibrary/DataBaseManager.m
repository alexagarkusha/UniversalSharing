//
//  DataBAseManager.m
//  UniversalSharing
//
//  Created by Roman on 8/17/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "DataBaseManager.h"
#import "SocialNetwork.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import <sqlite3.h>
#import "UIImage+LoadImageFromDataBase.h"

@interface DataBaseManager() {
    sqlite3 *_database;
}
@end

@implementation DataBaseManager

static DataBaseManager *databaseManager;

+ (DataBaseManager*)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[DataBaseManager alloc] init];
    });
    return databaseManager;
}

- (id)init {
    if ((self = [super init])) {
        if (sqlite3_open([[self filePath] UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
        [self createSqliteTables];
    }
    return self;
}

#pragma mark - get filePath

- (NSString *) filePath {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent: nameDataBase];
}

#pragma mark - createSqliteTables

-(void) createSqliteTables {
    char *error;
    NSString *stringUsersTable = [MUSDatabaseRequestStringsHelper createStringUsersTable];
    NSString *stringPostsTable = [MUSDatabaseRequestStringsHelper createStringPostsTable];
    //NSString *stringLocationsTable = [MUSDatabaseRequestStringsHelper createStringLocationsTable];
    NSString *stringNetworkPostsTable = [MUSDatabaseRequestStringsHelper createStringNetworkPostsTable];
    
    if(sqlite3_exec(_database, [stringPostsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        sqlite3_close(_database);
        NSAssert(0, @"Table Posts failed to create");
    }
    
    if(sqlite3_exec(_database, [stringUsersTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Table Users failed to create");
    }
    
//    if(sqlite3_exec(_database, [stringLocationsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
//        sqlite3_close(_database);
//        NSAssert(0, @"Table Location failed to create");
//    }
    if(sqlite3_exec(_database, [stringNetworkPostsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Table NetworkPosts failed to create");
    }
}

#pragma mark - save objects to dataBase

//- (sqlite3_stmt*) savePostToTableWithObject :(Post*) post {
//    sqlite3_stmt *statement = nil;
//    post.locationId = [self saveLocationToTableWithObject:post];
//    const char *sql = [[MUSDatabaseRequestStringsHelper createStringForSavePostToTable] UTF8String];
//    if(sqlite3_prepare_v2(_database, sql, -1, &statement, nil) == SQLITE_OK) {
//        sqlite3_bind_text(statement, 1, [[self checkExistedString: post.locationId] UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 2, [[self checkExistedString: post.postDescription] UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 3, [[self checkExistedString: [post convertArrayImagesUrlToString]] UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_int64(statement, 4, post.likesCount);
//        sqlite3_bind_int64(statement, 5, post.commentsCount);
//        sqlite3_bind_int64(statement, 6, post.networkType);
//        sqlite3_bind_text(statement, 7, [[self checkExistedString: post.dateCreate] UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_int64(statement, 8, post.reason);
//        sqlite3_bind_text(statement, 9, [[self checkExistedString: post.userId] UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 10, [[self checkExistedString: post.postID] UTF8String], -1, SQLITE_TRANSIENT);
//    }
//    
//    return statement;
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (sqlite3_stmt*) savePostToTableWithObject :(Post*) post {
    sqlite3_stmt *statement = nil;
    //post.locationId = [self saveLocationToTableWithObject:post];
    const char *sql = [[MUSDatabaseRequestStringsHelper createStringForSavePostToTable] UTF8String];
#warning NEED TO CHANGE IT;
    
    post.postID = @"";
    for (int i = 0; i < post.arrayWithNetworkPostsId.count; i++) {
        post.postID = [post.postID stringByAppendingString: [post.arrayWithNetworkPostsId objectAtIndex:i]];
        if (i != post.arrayWithNetworkPostsId.count - 1) {
            post.postID = [post.postID stringByAppendingString: @","];
        }
    }
    
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, nil) == SQLITE_OK) {
        
        sqlite3_bind_text(statement, 1, [[self checkExistedString: post.postDescription] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[self checkExistedString: [post convertArrayImagesUrlToString]] UTF8String], -1, SQLITE_TRANSIENT);
        //change logic array to string
        sqlite3_bind_text(statement, 3, [[self checkExistedString: post.postID] UTF8String], -1, SQLITE_TRANSIENT);//networkPostsId
        sqlite3_bind_text(statement, 4, [[self checkExistedString: post.dateCreate] UTF8String], -1, SQLITE_TRANSIENT);

    }
    
    return statement;
}

- (NSInteger) saveNetworkPostToTableWithObject :(NetworkPost*) networkPost {//networkPOst
    NSInteger lastRowId;
    sqlite3_stmt *statement = nil;
    //post.locationId = [self saveLocationToTableWithObject:post];
    const char *sql = [[MUSDatabaseRequestStringsHelper createStringForSaveNetworkPostToTable] UTF8String];
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int64(statement, 1, networkPost.likesCount);
        sqlite3_bind_int64(statement, 2, networkPost.commentsCount);
        sqlite3_bind_int64(statement, 3, networkPost.networkType);
        sqlite3_bind_int64(statement, 4, networkPost.reason);
        sqlite3_bind_text (statement, 5, [[self checkExistedString: networkPost.dateCreate] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text (statement, 6, [[self checkExistedString: networkPost.postID] UTF8String], -1, SQLITE_TRANSIENT);
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            lastRowId = (NSInteger) sqlite3_last_insert_rowid(_database);
            //member.memberId = lastRowId;
            //NSLog(@"inserted member id = %ld",lastRowId);
            //NSLog(@"member is added");
        }
    }
    
    return lastRowId;
   // NSLog(@"Primary key = %d", [self obtainNetworkPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForNetworkPostToGetLastObject]].primaryKey);
    
    //return [self obtainNetworkPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForNetworkPostToGetLastObject]].primaryKey;//get primaryKey of this networkpost From base//createStringForNetworkPostToGetLastObject
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) saveLocationToTableWithObject :(Post*) post {
    sqlite3_stmt *statement = nil;
    Place *place = post.place;
    NSString *locationID = [MUSDatabaseRequestStringsHelper createStringForLocationId];
    const char *sql = [[MUSDatabaseRequestStringsHelper createStringForSaveLocationToTable] UTF8String];
    
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, nil) == SQLITE_OK) {
        
        sqlite3_bind_text(statement, 1, [[self checkExistedString: place.placeID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[self checkExistedString: place.longitude] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[self checkExistedString: place.latitude] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [[self checkExistedString: place.fullName] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [[self checkExistedString: locationID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [[self checkExistedString: post.userId] UTF8String], -1, SQLITE_TRANSIENT);
    }
    if(sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error insert table");
    }
    sqlite3_finalize(statement);
    
    return locationID;
}

- (sqlite3_stmt*) saveUserToTableWithObject :(User*) user {
    sqlite3_stmt *statement = nil;
    const char *sql = [[MUSDatabaseRequestStringsHelper createStringForSaveUserToTable] UTF8String];
    
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [[self checkExistedString: user.username] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[self checkExistedString: user.firstName] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[self checkExistedString: user.lastName] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [[self checkExistedString: user.dateOfBirth] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [[self checkExistedString: user.city] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [[self checkExistedString: user.clientID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [[self checkExistedString: user.photoURL] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(statement, 8, user.isVisible);
        sqlite3_bind_int64(statement, 9, user.isLogin);
        sqlite3_bind_int64(statement, 10, user.indexPosition);
        sqlite3_bind_int64(statement, 11, user.networkType);
    }
    return statement;
}

- (NSString*) checkExistedString :(NSString*) stringForChecking {
    if (stringForChecking) {
        return stringForChecking;
    }
    return @"";
}

#pragma mark - insertIntoTable

-(void)insertIntoTable:(id) object {
    sqlite3_stmt *selectStmt = nil;
    if ([object isKindOfClass:[User class]]) {
        selectStmt = [self saveUserToTableWithObject:object];
//    } else if([object isKindOfClass:[NetworkPost class]]){//networkPost
//        selectStmt = [self saveNetworkPostToTableWithObject:object];
//    }
    }else {
        selectStmt = [self savePostToTableWithObject:object];
    }
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error insert table");
    }
    sqlite3_finalize(selectStmt);
}

#pragma mark - obtainUsersFromDataBaseWithRequestString

- (NSMutableArray*)obtainUsersFromDataBaseWithRequestString : (NSString*) requestString {
    NSMutableArray *arrayWithUsers = [NSMutableArray new];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            User *user = [User new];
            user.primaryKey = sqlite3_column_int(statement, 0);//perhaps it will be needed
            user.username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            user.firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            user.lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            user.dateOfBirth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            user.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            user.clientID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            user.photoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            user.isVisible = sqlite3_column_int(statement, 8);
            user.isLogin = sqlite3_column_int(statement, 9);
            user.indexPosition = sqlite3_column_int(statement, 10);
            user.networkType = sqlite3_column_int(statement, 11);
            [arrayWithUsers addObject:user];
            
        }
    }
    return arrayWithUsers;
}

- (Place*) obtainLocations :(Post*) post {
    sqlite3_stmt *statement = nil;
    Place *place = [Place new];
    if(sqlite3_prepare_v2(_database, [[MUSDatabaseRequestStringsHelper createStringForLocationsWithLocationId:post.locationId] UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            place.placeID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            place.longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            place.latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            place.fullName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return place;
}

#pragma mark - obtainPostsFromDataBaseWithRequestString

//- (NSMutableArray*)obtainPostsFromDataBaseWithRequestString : (NSString*) requestString {
//    NSMutableArray *arrayWithPosts = [NSMutableArray new];
//    sqlite3_stmt *statement = nil;
//    
//    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            Post *post = [Post new];
//            post.primaryKey = sqlite3_column_int(statement, 0);
//            post.locationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//            post.postDescription = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            post.arrayImagesUrl = [[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] componentsSeparatedByString: @", "]mutableCopy];
//            post.likesCount = sqlite3_column_int(statement, 4);
//            post.commentsCount = sqlite3_column_int(statement, 5);
//            post.networkType = sqlite3_column_int(statement, 6);
//            post.dateCreate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//            post.reason = sqlite3_column_int(statement, 8);
//            post.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//            post.postID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
//            post.place = [self obtainLocations:post];
//            [arrayWithPosts addObject:post];
//        }
//    }
//    return arrayWithPosts;
//}

//check string with int post.arrayWithNetworkPostsId

- (NSMutableArray*)obtainPostsFromDataBaseWithRequestString : (NSString*) requestString {
    NSMutableArray *arrayWithPosts = [NSMutableArray new];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Post *post = [Post new];
            post.primaryKey = sqlite3_column_int(statement, 0);
            //post.locationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            post.postDescription = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            post.arrayImagesUrl = [[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] componentsSeparatedByString: @", "]mutableCopy];
            post.arrayWithNetworkPostsId = [[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] componentsSeparatedByString: @","]mutableCopy];//check when gether all the parts
            //////////////////////////////////////////////////
//            post.arrayWithNetworkPosts = [NSMutableArray new];
//            [post.arrayWithNetworkPostsId enumerateObjectsUsingBlock:^(NSString *primaryKeyNetPost, NSUInteger idx, BOOL *stop) {
//                [post.arrayWithNetworkPosts addObject:[self obtainNetworkPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForNetworkPostWithPrimaryKey:[primaryKeyNetPost integerValue]]]];
//            }];
            post.dateCreate = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//check when gether all the parts
            
            post.arrayImages = [NSMutableArray new];
            for (int i = 0; i < post.arrayImagesUrl.count; i++) {
                UIImage *image = [UIImage new];
                image = [image loadImageFromDataBase: [post.arrayImagesUrl objectAtIndex: i]];
                ImageToPost *imageToPost = [[ImageToPost alloc] init];
                imageToPost.image = image;
                imageToPost.quality = 1.0f;
                imageToPost.imageType = JPEG;
                [post.arrayImages addObject: imageToPost];
            }
        [arrayWithPosts addObject:post];
        }
    }
    return arrayWithPosts;
}

- (NetworkPost*)obtainNetworkPostsFromDataBaseWithRequestString : (NSString*) requestString {
    //NSMutableArray *arrayWithNetworkPosts = [NSMutableArray new];
    sqlite3_stmt *statement = nil;
    NetworkPost *networkPost = [NetworkPost create];
    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            networkPost.primaryKey = sqlite3_column_int(statement, 0);
            networkPost.likesCount = sqlite3_column_int(statement, 1);
            networkPost.commentsCount = sqlite3_column_int(statement, 2);
            networkPost.networkType = sqlite3_column_int(statement, 3);
            networkPost.reason = sqlite3_column_int(statement, 4);
            networkPost.dateCreate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            networkPost.postID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            //[arrayWithNetworkPosts addObject:networkPost];
        }
    }
  
    return networkPost;
}

- (NSMutableArray*)obtainNetworkPostsFromDataBaseWithRequestStrings : (NSString*) requestString {
    NSMutableArray *arrayWithNetworkPosts = [NSMutableArray new];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NetworkPost *networkPost = [NetworkPost create];
            networkPost.primaryKey = sqlite3_column_int(statement, 0);
            networkPost.likesCount = sqlite3_column_int(statement, 1);
            networkPost.commentsCount = sqlite3_column_int(statement, 2);
            networkPost.networkType = sqlite3_column_int(statement, 3);
            networkPost.reason = sqlite3_column_int(statement, 4);
            networkPost.dateCreate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            networkPost.postID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            [arrayWithNetworkPosts addObject:networkPost];
        }
    }
    return arrayWithNetworkPosts;
}

#pragma mark - delete methods

- (void)deleteUserByClientId :(NSString*) clientId {
    [self deleteObjectFromDataDase:[MUSDatabaseRequestStringsHelper createStringForDeleteUserWithClientId:clientId]];
    //[self deletePostByUserId:clientId];
    
}

- (void)deletePostByPrimaryKey :(Post*) post {
    [self deleteObjectFromDataDase:[MUSDatabaseRequestStringsHelper createStringForDeletePostWithPrimaryKey:post.primaryKey]];
    [self deleteObjectFromDataDase:[MUSDatabaseRequestStringsHelper createStringForDeleteLocationWithLocationId: post.locationId]];
}

- (void)deletePostByUserId :(NSString*) userId {
    [self deleteObjectFromDataDase:[MUSDatabaseRequestStringsHelper createStringForDeletePostWithUserId:userId]];
    [self deleteObjectFromDataDase:[MUSDatabaseRequestStringsHelper createStringForDeleteLocationWithUserId:userId]];
}

- (void) deleteObjectFromDataDase : (NSString*) deleteSQL {
    sqlite3_stmt *statement = nil;
    const char *delete_stmt = [deleteSQL UTF8String];
    if( sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL ) == SQLITE_OK) {
        NSLog(@" the object is deleted ");
    }
    if (sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"delete failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error delete from table");
    }
    sqlite3_finalize(statement);
}

#pragma mark - edit method

- (void) editObjectAtDataBaseWithRequestString : (NSString*) requestString {
    const char *update_stmt = [requestString UTF8String];
    sqlite3_stmt *selectStmt;
    
    if(sqlite3_prepare_v2(_database, update_stmt, -1, &selectStmt, nil) == SQLITE_OK) {
        NSLog(@"the object is updated");
    }
    
    if(sqlite3_step(selectStmt) != SQLITE_DONE) {
        NSLog(@"Update failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error upadating table");
    }
    sqlite3_finalize(selectStmt);
}

#pragma mark - close dataBase

- (void)dealloc {
    sqlite3_close(_database);
}

@end
