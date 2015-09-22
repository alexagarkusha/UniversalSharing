//
//  MUSDatabaseRequestStringsHelper.m
//  UniversalSharing
//
//  Created by Roman on 8/27/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDatabaseRequestStringsHelper.h"

@implementation MUSDatabaseRequestStringsHelper

+ (NSString*)createStringForPostWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType {
    NSString *requestString = [NSString stringWithFormat:@"SELECT * FROM %@",@"Posts"];
    
    if (networkType != AllNetworks) {
        requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@" WHERE networkType = \"%ld\"", (long)networkType]];
        
        if (reason != AllReasons) {
            requestString = [requestString stringByAppendingString: [NSString stringWithFormat: @" AND reson = \"%ld\"", (long)reason]];
        }
    } else if (reason != AllReasons && networkType == AllNetworks) {
        requestString = [requestString stringByAppendingString: [NSString stringWithFormat: @" WHERE reson=\"%ld\"", (long)reason]];
    }
    requestString = [requestString stringByAppendingString: [NSString stringWithFormat:@" ORDER BY dateCreate DESC"]];
    return requestString;
}

+ (NSString*) createStringForSavePostToTable {
    return [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?)",@"Posts",@"locationID",@"postDescription",@"arrayImagesUrl",@"likesCount",@"commentsCount",@"networkType",@"dateCreate",@"reson",@"userId",@"postId"];
}

+ (NSString*) createStringForSaveLocationToTable {
    return [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?)",@"Locations",@"placeID",@"longitude",@"latitude",@"placeName",@"locationID",@"userID"];
}

+ (NSString*) createStringForSaveUserToTable {
    return [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?)",@"Users",@"username",@"firstName",@"lastName",@"dateOfBirth",@"city",@"clientID",@"photoURL",@"isVisible",@"isLogin",@"networkType"];
}

+ (NSString*) createStringForLocationId {
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}

+ (NSString*) createStringForPostWithUserId :(NSString*) userId {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = \"%@\" ",@"Posts",userId];
}

+ (NSString*) createStringForPostWithPostId :(NSString*) PostId {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE postId = \"%@\" ",@"Posts",PostId];
}

+ (NSString*) createStringForAllPosts {
    return [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY dateCreate DESC",@"Posts"];
}

+ (NSString*) createStringForAllUsers {
   return [NSString stringWithFormat:@"SELECT * FROM %@",@"Users"];
}

+ (NSString*) createStringForUsersWithNetworkType :(NSInteger) networkType {
    return [NSString stringWithFormat:@"SELECT * FROM Users WHERE networkType = %ld", (long)networkType];
}

+ (NSString*) createStringForLocationsWithLocationId :(NSString*) locationId {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE locationID = \"%@\"",@"Locations",locationId];
}

+ (NSString*) createStringForDeleteLocationWithLocationId :(NSString*) locationId {
    return [NSString stringWithFormat:@"DELETE from Locations WHERE locationID = \"%@\"",locationId];
}

+ (NSString*) createStringForDeleteLocationWithUserId :(NSString*) userId {
    return [NSString stringWithFormat:@"DELETE from Locations WHERE userId = \"%@\"",userId];
}

+ (NSString*) createStringForDeleteUserWithClientId :(NSString*) clientId {
    return [NSString stringWithFormat:@"DELETE from Users WHERE clientID = \"%@\"",clientId];
}

+ (NSString*) createStringForDeletePostWithPrimaryKey :(NSInteger) primaryKey {
    return [NSString stringWithFormat:@"DELETE from Posts WHERE id = \"%ld\"",(long)primaryKey];
}

+ (NSString*) createStringForDeletePostWithUserId :(NSString*) userId {
    return [NSString stringWithFormat:@"DELETE from Posts WHERE userId = \"%@\"",userId];
}

+ (NSString *) createStringUsersForUpdateWithObjectUser:(User *)user {
    NSString *stringUsersForUpdate = @"UPDATE Users set ";
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"username = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"firstName = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"lastName = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"dateOfBirth = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"city = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"networkType = \"%d\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"clientID = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"photoURL = \"%@\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"isVisible = \"%d\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"isLogin = \"%d\" "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"WHERE networkType = \"%d\" AND clientID = \"%@\""];
    
    NSString *finalStringUsersForUpdate = [NSString stringWithFormat:stringUsersForUpdate, user.username, user.firstName, user.lastName, user.dateOfBirth, user.city, user.networkType, user.clientID, user.photoURL, user.isVisible, user.isLogin, user.networkType, user.clientID];
    return finalStringUsersForUpdate;
}

+ (NSString*) createStringPostsForUpdateWithObjectPost :(Post*) post {
    NSString *stringPostsForUpdate = @"UPDATE Posts set ";
    
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"locationID = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"postDescription = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"arrayImagesUrl = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"likesCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"commentsCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"networkType = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"dateCreate = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"reson = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"userId = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"postId = \"%@\" "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"WHERE id = \"%d\""];
    NSString *postDescription = [post.postDescription stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    NSString *finalStringPostsForUpdate = [NSString stringWithFormat:stringPostsForUpdate, post.locationId, postDescription, [post convertArrayImagesUrlToString], post.likesCount, post.commentsCount, post.networkType, post.dateCreate, post.reason, post.userId, post.postID, post.primaryKey];
    
    return finalStringPostsForUpdate;
}

+ (NSString*) createStringPostsForUpdateWithObjectPostForVK :(Post*) post {
    NSString *stringPostsForUpdate = @"UPDATE Posts set ";
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"likesCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"commentsCount = \"%d\" "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"WHERE userId = \"%@\" AND postId = \"%@\""];
    
    NSString *finalStringPostsForUpdate = [NSString stringWithFormat:stringPostsForUpdate, post.likesCount, post.commentsCount,  post.userId, post.postID];
    
    return finalStringPostsForUpdate;
}

+ (NSString*) createStringLocationsForUpdateWithObjectPost :(Post*) post {
    
    NSString *stringLocationsForUpdate = @"UPDATE Locations set ";
    
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"userID = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"placeID = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"longitude = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"latitude = \"%@\", "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"placeName = \"%@\" "];
    stringLocationsForUpdate = [stringLocationsForUpdate stringByAppendingString:@"WHERE locationID = \"%@\""];
    
    NSString *placeId = [post.place.placeID stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *longitude = [post.place.longitude stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *latitude = [post.place.latitude stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *fullName = [post.place.fullName stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSString *finalStringLocationsForUpdate = [NSString stringWithFormat:stringLocationsForUpdate, post.userId, placeId, longitude, latitude, fullName, post.locationId];
    return finalStringLocationsForUpdate;
}

+ (NSString*) createStringUsersTable {
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

+ (NSString*) createStringLocationsTable {
    NSString *stringLocationsTable = @"CREATE TABLE IF NOT EXISTS Locations (";
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"userID TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"placeID TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"longitude TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"latitude TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"placeName TEXT, "];
    stringLocationsTable = [stringLocationsTable stringByAppendingString:@"locationID TEXT)"];
    return stringLocationsTable;
}

+ (NSString*) createStringPostsTable {
    NSString *stringPostsTable = @"CREATE TABLE IF NOT EXISTS Posts (";
    stringPostsTable = [stringPostsTable stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"locationID TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"postDescription TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"arrayImagesUrl TEXT,"];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"likesCount INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"commentsCount INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"networkType INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"dateCreate TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"reson INTEGER, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"userId TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"postId TEXT)"];

    return stringPostsTable;
}

@end
