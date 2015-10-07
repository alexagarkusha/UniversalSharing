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

- (id) init {
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
    
    if(sqlite3_exec(_database, [stringNetworkPostsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Table NetworkPosts failed to create");
    }
}

#pragma mark - save objects to dataBase

- (sqlite3_stmt*) savePost :(Post*) post {
    sqlite3_stmt *statement = nil;
    const char *sql = [[MUSDatabaseRequestStringsHelper createStringForSavePostToTable] UTF8String];
    [post convertArrayWithNetworkPostsIdsToString];
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, nil) == SQLITE_OK) {
        
        sqlite3_bind_text(statement, 1, [[self checkExistedString: post.postDescription] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[self checkExistedString: [post convertArrayImagesUrlToString]] UTF8String], -1, SQLITE_TRANSIENT);
        //change logic array to string
        sqlite3_bind_text(statement, 3, [[self checkExistedString: post.postID] UTF8String], -1, SQLITE_TRANSIENT);//postId
        sqlite3_bind_text(statement, 4, [[self checkExistedString: post.longitude] UTF8String], -1, SQLITE_TRANSIENT);//longitude
        sqlite3_bind_text(statement, 5, [[self checkExistedString: post.latitude] UTF8String], -1, SQLITE_TRANSIENT);//latitude
        sqlite3_bind_text(statement, 6, [[self checkExistedString: post.dateCreate] UTF8String], -1, SQLITE_TRANSIENT);//dateCreate
    }
    
    return statement;
}

- (NSInteger) saveNetworkPost :(NetworkPost*) networkPost {//networkPOst
    NSInteger lastRowId;
    sqlite3_stmt *statement = nil;
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
            lastRowId = (NSInteger) sqlite3_last_insert_rowid(_database);//get primaryKey of the last object was added
        }
    }
    
    return lastRowId;
}

- (sqlite3_stmt*) saveUser :(User*) user {
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

-(void)insertObjectIntoTable:(id) object {
    sqlite3_stmt *selectStmt = nil;
    if ([object isKindOfClass:[User class]]) {
        selectStmt = [self saveUser:object];
    } else {
        selectStmt = [self savePost:object];
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

#pragma mark - obtainPostsFromDataBaseWithRequestString

- (NSMutableArray*)obtainPostsFromDataBaseWithRequestString : (NSString*) requestString {
    NSMutableArray *arrayWithPosts = [NSMutableArray new];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Post *post = [Post new];
            post.primaryKey = sqlite3_column_int(statement, 0);
            post.postDescription = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            post.arrayImagesUrl = [[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] componentsSeparatedByString: @", "]mutableCopy];
            post.arrayWithNetworkPostsId = [[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] componentsSeparatedByString: @","]mutableCopy];
            post.longitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            post.latitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            post.dateCreate = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [post convertArrayOfImagesUrlToArrayImagesWithObjectsImageToPost];
        [arrayWithPosts addObject:post];
        }
    }
    return arrayWithPosts;
}

- (NetworkPost*)obtainNetworkPostFromDataBaseWithRequestString : (NSString*) requestString {
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
        }
    }
    return networkPost;
}

- (NSMutableArray*)obtainNetworkPostsFromDataBaseWithRequestString : (NSString*) requestString {
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

- (void) deleteObjectFromDataDaseWithRequestStrings : (NSString*) requestString {
    sqlite3_stmt *statement = nil;
    const char *delete_stmt = [requestString UTF8String];
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
        //NSLog(@"the object is updated");
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
