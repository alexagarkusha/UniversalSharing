//
//  DataBAseManager.m
//  UniversalSharing
//
//  Created by Roman on 8/17/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "DataBaseManager.h"
#import "SocialNetwork.h"

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
    return [documentDirectory stringByAppendingPathComponent: nameDataBase];
}

-(void) createSqliteTables {
    char *error;
    NSString *stringUsersTable = [self createStringUsersTable];
    NSString *stringPostsTable = [self createStringPostsTable];
    NSString *stringLocationsTable = [self createStringLocationsTable];
    
    if(sqlite3_exec(_database, [stringPostsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        sqlite3_close(_database);
        NSAssert(0, @"Table Posts failed to create");
    }
    
    if(sqlite3_exec(_database, [stringUsersTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Table Users failed to create");
    }
    
    if(sqlite3_exec(_database, [stringLocationsTable UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Table Location failed to create");
    }
}



- (sqlite3_stmt*) savePostToTableWithObject :(Post*) object {
    
    sqlite3_stmt *selectStmt = nil;
    Post *post = object;
    post.locationId = [self saveLocationToTableWithObject:post];
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?)",@"Posts",@"locationID",@"postDescription",@"arrayImagesUrl",@"likesCount",@"commentsCount",@"networkType",@"dateCreate",@"reson",@"userId"];
    const char *sql = [sqlStr UTF8String];
    NSString *url = @"";
    if(sqlite3_prepare_v2(_database, sql, -1, &selectStmt, nil) == SQLITE_OK)
    {
        //location id
        
        
        
        sqlite3_bind_text(selectStmt, 1, [[self checkExistedString: post.locationId] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 2, [[self checkExistedString: post.postDescription] UTF8String], -1, SQLITE_TRANSIENT);
        //[post.arrayImagesUrl enumerateObjectsUsingBlock:^(NSString *stringUrl, NSUInteger index, BOOL *stop) {
#warning "Replace this logic on Post"
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
        sqlite3_bind_text(selectStmt, 3, [[self checkExistedString: url] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(selectStmt, 4, post.likesCount);
        sqlite3_bind_int64(selectStmt, 5, post.commentsCount);
        //sqlite3_bind_text(selectStmt, 6, [[self checkExistedString: post.placeID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(selectStmt, 6, post.networkType);
        //        sqlite3_bind_text(selectStmt, 8, [[self checkExistedString: post.longitude] UTF8String], -1, SQLITE_TRANSIENT);
        //        sqlite3_bind_text(selectStmt, 9, [[self checkExistedString: post.latitude] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 7, [[self checkExistedString: post.dateCreate] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(selectStmt, 8, post.reason);
        sqlite3_bind_text(selectStmt, 9, [[self checkExistedString: post.userId] UTF8String], -1, SQLITE_TRANSIENT);
    }
    
    return selectStmt;
}

- (NSString*) saveLocationToTableWithObject :(Post*) object {
    
    sqlite3_stmt *selectStmt = nil;
    Place *place = object.place;
    NSString *locationID = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?)",@"Locations",@"placeID",@"longitude",@"latitude",@"placeName",@"locationID",@"userID"];
    const char *sql = [sqlStr UTF8String];
    
    if(sqlite3_prepare_v2(_database, sql, -1, &selectStmt, nil) == SQLITE_OK) {
        
        sqlite3_bind_text(selectStmt, 1, [[self checkExistedString: place.placeID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 2, [[self checkExistedString: place.longitude] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 3, [[self checkExistedString: place.latitude] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 4, [[self checkExistedString: place.fullName] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 5, [[self checkExistedString: locationID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 6, [[self checkExistedString: object.userId] UTF8String], -1, SQLITE_TRANSIENT);
    }
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error insert table");
    }
    sqlite3_finalize(selectStmt);
    
    return locationID;
}

- (sqlite3_stmt*) saveUserToTableWithObject :(User*) object {
    User *user = object;
    sqlite3_stmt *selectStmt = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?)",@"Users",@"username",@"firstName",@"lastName",@"dateOfBirth",@"city",@"clientID",@"photoURL",@"isVisible",@"isLogin",@"networkType"];
    const char *sql = [sqlStr UTF8String];
    
    if(sqlite3_prepare_v2(_database, sql, -1, &selectStmt, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(selectStmt, 1, [[self checkExistedString: user.username] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 2, [[self checkExistedString: user.firstName] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 3, [[self checkExistedString: user.lastName] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 4, [[self checkExistedString: user.dateOfBirth] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 5, [[self checkExistedString: user.city] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 6, [[self checkExistedString: user.clientID] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(selectStmt, 7, [[self checkExistedString: user.photoURL] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(selectStmt, 8, user.isVisible);
        sqlite3_bind_int64(selectStmt, 9, user.isLogin);
        sqlite3_bind_int64(selectStmt, 10, user.networkType);
    }
    return selectStmt;
}
- (NSString*) checkExistedString :(NSString*) stringForChecking {
    if (stringForChecking) {
        return stringForChecking;
    }
    return @"";
}

-(void)insertIntoTable:(id) object {
    sqlite3_stmt *selectStmt = nil;
    if ([object isKindOfClass:[User class]]) {
        selectStmt = [self saveUserToTableWithObject:object];
    } else {
        selectStmt = [self savePostToTableWithObject:object];
    }
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Insert failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error insert table");
    }
    sqlite3_finalize(selectStmt);
}

- (NSMutableArray*)obtainAllUsers {
    NSMutableArray *arrayWithUsers = [NSMutableArray new];
    NSString *qsql=[NSString stringWithFormat:@"SELECT * FROM %@",@"Users"];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
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
            user.networkType = sqlite3_column_int(statement, 10);
            [arrayWithUsers addObject:user];
            
        }
    }
    return arrayWithUsers;
}

- (NSMutableArray*)obtainAllPosts {
    NSMutableArray *arrayWithPosts = [NSMutableArray new];
    NSString *qsql = [NSString stringWithFormat:@"SELECT * FROM %@",@"Posts"];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            Post *post = [Post new];
            post.primaryKey = sqlite3_column_int(statement, 0);//perhaps it will be needed
            //post.postID = sqlite3_column_int(statement, 1);
            post.locationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            post.postDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            
            NSString *stringWithImageUrls = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            post.arrayImagesUrl = [[stringWithImageUrls componentsSeparatedByString: @", "]mutableCopy];
            
            post.likesCount = sqlite3_column_int(statement, 4);
            post.commentsCount = sqlite3_column_int(statement, 5);
            //post.placeID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            post.networkType = sqlite3_column_int(statement, 6);
            // post.longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            //post.latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            post.dateCreate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            post.reason = sqlite3_column_int(statement, 8);
            post.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            post.place = [self obtainLocations:post];
            [arrayWithPosts addObject:post];
            
        }
    }
    return arrayWithPosts;
}

- (Place*) obtainLocations :(Post*) post {
    
    NSString *qsql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE locationID =  \"%@\"",@"Locations",post.locationId];
    sqlite3_stmt *statement = nil;
    Place *place = [Place new];
    if(sqlite3_prepare_v2(_database, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            place.placeID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            place.longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            place.latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            place.fullName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        }
    }
    return place;
}

- (NSMutableArray*)obtainAllPostsWithUserId :(NSString*) userId {
    
    NSMutableArray *arrayWithPosts = [NSMutableArray new];
    NSString *qsql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = \"%@\" ",@"Posts",userId];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            Post *post = [Post new];
            post.primaryKey = sqlite3_column_int(statement, 0);//perhaps it will be needed
            //post.postID = sqlite3_column_int(statement, 1);
            post.locationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            post.postDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            
            NSString *stringWithImageUrls = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            post.arrayImagesUrl = [[stringWithImageUrls componentsSeparatedByString: @", "]mutableCopy];
            
            post.likesCount = sqlite3_column_int(statement, 4);
            post.commentsCount = sqlite3_column_int(statement, 5);
            // post.placeID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            post.networkType = sqlite3_column_int(statement, 6);
            //post.longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            //post.latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            post.dateCreate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            post.reason = sqlite3_column_int(statement, 8);
            post.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
             post.place = [self obtainLocations:post];
            [arrayWithPosts addObject:post];
            
        }
    }
    return arrayWithPosts;
}

- (NSArray*)obtainPostsWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType {
    NSMutableArray *arrayWithPosts = [NSMutableArray new];
    NSString *requestString = [NSString stringWithFormat:@"SELECT * FROM %@",@"Posts"];
    
    if (networkType != AllNetworks) {
        requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@" WHERE networkType = \"%ld\"", (long)networkType]];
        
        if (reason != AllReasons) {
            requestString = [requestString stringByAppendingString: [NSString stringWithFormat: @" AND reason = \"%ld\"", (long)reason]];
        }
    } else if (reason != AllReasons && networkType == AllNetworks) {
        requestString = [requestString stringByAppendingString: [NSString stringWithFormat: @" WHERE reason=\"%ld\"", (long)reason]];
    }
    
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database, [requestString UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            Post *post = [Post new];
            post.primaryKey = sqlite3_column_int(statement, 0);//perhaps it will be needed
            // post.postID = sqlite3_column_int(statement, 1);
            post.locationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            post.postDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            
            NSString *stringWithImageUrls = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            post.arrayImagesUrl = [[stringWithImageUrls componentsSeparatedByString: @", "]mutableCopy];
            
            post.likesCount = sqlite3_column_int(statement, 4);
            post.commentsCount = sqlite3_column_int(statement, 5);
            //post.placeID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            post.networkType = sqlite3_column_int(statement, 6);
            // post.longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            //post.latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            post.dateCreate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            post.reason = sqlite3_column_int(statement, 8);
            post.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            post.place = [self obtainLocations:post];
            [arrayWithPosts addObject:post];
            
        }
    }
    return arrayWithPosts;
}

- (User*)obtainUsersWithNetworkType :(NSInteger) networkType {
    
    NSString *qsql = [NSString stringWithFormat:@"SELECT * FROM Users WHERE networkType = %ld", (long)networkType];
    sqlite3_stmt *statement = nil;
    User *user = [User new];
    if(sqlite3_prepare_v2(_database, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
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
            user.networkType = sqlite3_column_int(statement, 10);
            
        }
    }
    
    return user;
}

- (void)deletePostByUserId :(NSString*) userId {
    
    sqlite3_stmt *statement = nil;
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from Posts WHERE userId = \"%@\"",userId];
    
    const char *delete_stmt = [deleteSQL UTF8String];
    
    if( sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL ) == SQLITE_OK){
        NSLog(@" the Post is deleted ");
    }
    if (sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"delete failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error delete from table");
    }
    [self deleteLocationByUserId:userId];
    sqlite3_finalize(statement);
}

- (void)deleteLocationByUserId :(NSString*) userId {
    
    sqlite3_stmt *statement = nil;
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from Locations WHERE userId = \"%@\"",userId];
    
    const char *delete_stmt = [deleteSQL UTF8String];
    
    if( sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL ) == SQLITE_OK){
        NSLog(@" the location is deleted ");
    }
    if (sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"delete failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error delete from table");
    }
    sqlite3_finalize(statement);
}

- (void)editPost :(Post*) post {
    [self editLocation:post];
    NSString *url = @"";//go to  method
    for (int i = 0; i < post.arrayImagesUrl.count; i++) {
        url = [url stringByAppendingString:post.arrayImagesUrl[i]];
        if(post.arrayImagesUrl.count - 1 != i)
            url = [url stringByAppendingString:@", "];
    }
    
    NSString *stringPostsForUpdate = [NSString stringWithFormat:[self createStringPostsForUpdate],post.locationId, post.postDescription, url, post.likesCount, post.commentsCount, post.networkType, post.dateCreate, post.reason, post.userId, post.primaryKey];
    
    
    const char *update_stmt = [stringPostsForUpdate UTF8String];
    
    ////////////////////////////////////////////////////////////
    
    sqlite3_stmt *selectStmt;
    
    if(sqlite3_prepare_v2(_database, update_stmt, -1, &selectStmt, nil) == SQLITE_OK)
    {
        NSLog(@"the post is updated");
    }
    
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Update failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error upadating table");
    }
    sqlite3_finalize(selectStmt);
}

- (void)editLocation :(Post*) post {
    //Place *place = post.place;
    NSString *stringLocationsForUpdate = [NSString stringWithFormat:[self createStringLocationsForUpdate],post.userId, post.place.placeID, post.place.longitude,post.place.latitude, post.place.fullName, post.locationId];
    
    
    const char *update_stmt = [stringLocationsForUpdate UTF8String];
    
    sqlite3_stmt *selectStmt;
    
    if(sqlite3_prepare_v2(_database, update_stmt, -1, &selectStmt, nil) == SQLITE_OK)
    {
        NSLog(@"the post is updated");
    }
    
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Update failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error upadating table");
    }
    sqlite3_finalize(selectStmt);
}

- (void)editUser :(User*) user {
    NSString *stringUsersForUpdate = [NSString stringWithFormat:[self createStringUsersForUpdate], user.username, user.firstName, user.lastName, user.dateOfBirth, user.city, user.networkType, user.clientID, user.photoURL, user.isVisible, user.isLogin, user.networkType, user.clientID];
    
    const char *update_stmt = [stringUsersForUpdate UTF8String];
    sqlite3_stmt *selectStmt;
    
    if(sqlite3_prepare_v2(_database, update_stmt, -1, &selectStmt, nil) == SQLITE_OK)
    {
        NSLog(@"the user is updated");
    }
    
    if(sqlite3_step(selectStmt) != SQLITE_DONE){
        NSLog(@"Update failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error upadating table");
    }
    sqlite3_finalize(selectStmt);
}

- (void)deleteUserByClientId :(NSString*) clientId {
    
    sqlite3_stmt *statement = nil;
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from Users WHERE clientID=\"%@\"",clientId];
    
    const char *delete_stmt = [deleteSQL UTF8String];
    
    if( sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL ) == SQLITE_OK){
        NSLog(@" the User is deleted ");
    }
    if (sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"delete failed: %s", sqlite3_errmsg(_database));
        NSAssert(0, @"Error delete from table");
    }
    [self deletePostByUserId:clientId];
    sqlite3_finalize(statement);
}

- (NSString *) createStringUsersForUpdate {
    NSString *stringUsersForUpdate = @"UPDATE Users set ";
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"username = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"firstName = \"%@\", "];/////////////////
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"lastName = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"dateOfBirth = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"city = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"networkType = \"%d\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"clientID = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"photoURL = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"isVisible = \"%d\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"isLogin = \"%d\" "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"WHERE networkType = \"%d\" AND clientID = \"%@\""];
    return stringUsersForUpdate;
}

- (NSString *) createStringPostsForUpdate {
    NSString *stringPostsForUpdate = @"UPDATE Posts set ";
    
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"locationID = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"postDescription = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"arrayImagesUrl = \"%@\", "];/////////////////
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"likesCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"commentsCount = \"%d\", "];
    //stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"placeID = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"networkType = \"%d\", "];
    // stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"longitude = \"%@\", "];
    //stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"latitude = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"dateCreate = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"reson = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"userId = \"%@\" "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"WHERE id = \"%d\""];
    return stringPostsForUpdate;
}

- (NSString *) createStringLocationsForUpdate {
    
    NSString *stringLocationsForUpdate = @"UPDATE Locations set ";
    
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"userID = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"placeID = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"longitude = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"latitude = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"placeName = \"%@\" "];
    //stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"locationID = \"%d\", "];
    
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"WHERE locationID = \"%@\""];
    return stringLocationsForUpdate;
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
    stringUsersTable = [stringUsersTable stringByAppendingString:@"isVisible INTEGER, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"isLogin INTEGER, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"networkType INTEGER)"];
    return stringUsersTable;
}

- (NSString *) createStringLocationsTable {
    NSString *stringLocationsTable = @"CREATE TABLE IF NOT EXISTS Locations (";
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"userID TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"placeID TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"longitude TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"latitude TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"placeName TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"locationID TEXT)"];
    return stringLocationsTable;
}

- (NSString *) createStringPostsTable {
    NSString *stringPostsTable = @"CREATE TABLE IF NOT EXISTS Posts (";
    stringPostsTable = [stringPostsTable stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"locationID TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"postDescription TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"arrayImagesUrl TEXT,"];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"likesCount INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"commentsCount INTEGER, "];
    //stringPostsTable = [stringPostsTable stringByAppendingString:@"placeID TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"networkType INTEGER, "];
    //stringPostsTable = [stringPostsTable stringByAppendingString:@"longitude TEXT, "];
    //stringPostsTable = [stringPostsTable stringByAppendingString:@"latitude TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"dateCreate TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"reson INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"userId TEXT)"];
    return stringPostsTable;
}

- (void)dealloc {
    sqlite3_close(_database);
}

@end
