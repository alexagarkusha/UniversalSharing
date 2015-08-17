//
//  DataBAseManager.m
//  UniversalSharing
//
//  Created by Roman on 8/17/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "DataBaseManager.h"
#import "User.h"
#import "Post.h"
#import "MUSSocialNetworkLibraryConstants.h"
#import "SocialNetwork.h"

@implementation DataBaseManager

static DataBaseManager *_database;

+ (DataBaseManager*)dataBaseManager {
    if (_database == nil) {
        _database = [[DataBaseManager alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        //sqlite3_close(_database);
        if (sqlite3_open([[self filePath] UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
        [self createSqliteTables];
    }
    return self;
}

- (NSString *) filePath {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"UniversalSharing.sql"];
}

-(void) createSqliteTables {
    char *error;
    NSString *stringUsersTable = [self createStringUsersTable];
    NSString *stringPostsTable = [self createStringPostsTable];
    
    if(sqlite3_exec(_database, [stringPostsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
         NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        sqlite3_close(_database);
        NSAssert(0, @"Table Posts failed to create");
    }
    
    if(sqlite3_exec(_database, [stringUsersTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Table Users failed to create");
    }
}

-(void)insertIntoTable:(id) object {
    if (sqlite3_open_v2([[self filePath] UTF8String], &_database, SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
        NSLog(@"Database opened");
    
    sqlite3_stmt *selectStmt;    
    if ([object isKindOfClass:[User class]]) {
        User *user = object;
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?)",@"Users",@"username",@"firstName",@"lastName",@"dateOfBirth",@"city",@"clientID",@"photoURL",@"networkType"];
        const char *sql = [sqlStr UTF8String];
        
        if(sqlite3_prepare_v2(_database, sql, -1, &selectStmt, nil) == SQLITE_OK)
        {
            sqlite3_bind_text(selectStmt, 1, [user.username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 2, [user.firstName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 3, [user.lastName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 4, [user.dateOfBirth UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 5, [user.city UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 6, [user.clientID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 7, [user.photoURL UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int64(selectStmt, 8, user.networkType);
        }
    } else {
        Post *post = object;
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",@"Posts",@"postID",@"postDescription",@"arrayImagesUrl",@"likesCount",@"commentsCount",@"placeID",@"networkType",@"longitude",@"latitude",@"dateCreate",@"reson",@"userId"];
        const char *sql = [sqlStr UTF8String];
        NSString *url = @"";
        if(sqlite3_prepare_v2(_database, sql, -1, &selectStmt, nil) == SQLITE_OK)
        {
            sqlite3_bind_text(selectStmt, 1, [post.placeID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectStmt, 2, [post.postDescription UTF8String], -1, SQLITE_TRANSIENT);
            //[post.arrayImagesUrl enumerateObjectsUsingBlock:^(NSString *stringUrl, NSUInteger index, BOOL *stop) {
            for (int i = 0; i < post.arrayImagesUrl.count; i++) {
                 url = [url stringByAppendingString:post.arrayImagesUrl[i]];
                if(post.arrayImagesUrl.count - 1 != i)
                url = [url stringByAppendingString:@", "];
            }
//                url = stringUrl;
//                if (stop) {
//                     url = [url stringByAppendingString:@", "];
//                }
            //}];
            sqlite3_bind_text(selectStmt, 3, [url UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int64(selectStmt, 4, post.likesCount);
            sqlite3_bind_int64(selectStmt, 5, post.commentsCount);

            sqlite3_bind_text(selectStmt, 6, [post.placeID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int64(selectStmt, 7, post.networkType);
            
//            sqlite3_bind_text(selectStmt, 8, [post.longitude UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(selectStmt, 9, [post.latitude UTF8String], -1, SQLITE_TRANSIENT);
//            //dateCreate
            //reson
            //userId
//            sqlite3_bind_text(selectStmt, 7, [post.postDescription UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_int64(selectStmt, 8, user.networkType);
        }

        
    }
    
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error upadating table");
        sqlite3_finalize(selectStmt);
    }
}

- (NSString *) createStringUsersTable {
    NSString *stringUsersTable = @"CREATE TABLE IF NOT EXISTS Users (";
    stringUsersTable = [stringUsersTable stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"username TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"firstName TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"lastName TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"dateOfBirth TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"city TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"clientID TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"photoURL TEXT, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"networkType INTEGER)"];
    return stringUsersTable;
}

- (NSString *) createStringPostsTable {
    NSString *stringPostsTable = @"CREATE TABLE IF NOT EXISTS Posts (";
    stringPostsTable = [stringPostsTable stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"postID TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"postDescription TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"arrayImagesUrl TEXT,"];////////////////////////////
    stringPostsTable = [stringPostsTable stringByAppendingString:@"likesCount INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"commentsCount INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"placeID TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"networkType INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"longitude TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"latitude TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"dateCreate TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"reson INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"userId TEXT)"];
    return stringPostsTable;
}

@end
