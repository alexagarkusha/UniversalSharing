//
//  MUSDatabaseRequestStringsHelper.m
//  UniversalSharing
//
//  Created by Roman on 8/27/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDatabaseRequestStringsHelper.h"

@implementation MUSDatabaseRequestStringsHelper


+ (NSString*)stringForNetworkPostWithReason :(ReasonType) reason andNetworkType :(NetworkType) networkType {
    
    NSString *requestString = [NSString stringWithFormat:@"SELECT * FROM %@",@"NetworkPosts"];
    
    if (networkType != AllNetworks) {
        requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@" WHERE networkType = \"%ld\"", (long)networkType]];
        
        if (reason != AllReasons) {
            requestString = [requestString stringByAppendingString: [NSString stringWithFormat: @" AND reson = \"%ld\"", (long)reason]];
        }
    } else if (reason != AllReasons && networkType == AllNetworks) {
        requestString = [requestString stringByAppendingString: [NSString stringWithFormat: @" WHERE reson=\"%ld\"", (long)reason]];
    }
    //requestString = [requestString stringByAppendingString: [NSString stringWithFormat:@" ORDER BY dateCreate DESC"]];
    return requestString;
}



+ (NSString*) stringForSavePost {
    return [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?)",@"Posts",@"postDescription",@"arrayImagesUrl",@"networkPostsId",@"longitude",@"latitude",@"dateCreate"];
}

+ (NSString*) stringSaveNetworkPost {
    return [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?)",@"NetworkPosts",@"likesCount",@"commentsCount",@"networkType",@"reson",@"dateCreate",@"postId"];
}



+ (NSString*) stringForSaveUser {
    return [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?,?)",@"Users",@"username",@"firstName",@"lastName",@"dateOfBirth",@"city",@"clientID",@"photoURL",@"isVisible",@"isLogin",@"indexPosition",@"networkType"];
}

+ (NSString*) stringForAllPosts {
    return [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY dateCreate DESC",@"Posts"];
}

+ (NSString*) stringForUserWithNetworkType :(NSInteger) networkType {
    return [NSString stringWithFormat:@"SELECT * FROM Users WHERE networkType = %ld", (long)networkType];
}

+ (NSString*) stringForDeleteUserByClientId :(NSString*) clientId {
    return [NSString stringWithFormat:@"DELETE from Users WHERE clientID = \"%@\"",clientId];
}

+ (NSString*) stringForDeletePostByPrimaryKey :(NSInteger) primaryKey {
    return [NSString stringWithFormat:@"DELETE from Posts WHERE id = \"%ld\"",(long)primaryKey];
}

+ (NSString *) stringForUpdateUser:(User *)user {
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
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"indexPosition = \"%d\", "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"isLogin = \"%d\" "];
    stringUsersForUpdate = [stringUsersForUpdate stringByAppendingString:@"WHERE networkType = \"%d\" AND clientID = \"%@\""];
    
    NSString *finalStringUsersForUpdate = [NSString stringWithFormat:stringUsersForUpdate, user.username, user.firstName, user.lastName, user.dateOfBirth, user.city, user.networkType, user.clientID, user.photoURL, user.isVisible, user.indexPosition, user.isLogin, user.networkType, user.clientID];
    return finalStringUsersForUpdate;
}

+ (NSString*) stringCreateTableOfUsers {
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
    stringUsersTable = [stringUsersTable stringByAppendingString:@"indexPosition INTEGER, "];
    stringUsersTable = [stringUsersTable stringByAppendingString:@"networkType INTEGER)"];
    return stringUsersTable;
}

///////////////////////////////////////////////////////////////////////////////////////////////// brandnew tables
+ (NSString*) stringCreateTableOfPosts {
    NSString *stringPostsTable = @"CREATE TABLE IF NOT EXISTS Posts (";
    stringPostsTable = [stringPostsTable stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    //stringPostsTable = [stringPostsTable stringByAppendingString:@"locationID TEXT, "];// it will be needed later, perhaps
    stringPostsTable = [stringPostsTable stringByAppendingString:@"postDescription TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"arrayImagesUrl TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"networkPostsId TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"longitude TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"latitude TEXT, "];
    stringPostsTable = [stringPostsTable stringByAppendingString:@"dateCreate TEXT)"];
    return stringPostsTable;
}

+ (NSString*) stringCreateTableOfNetworkPosts {
    NSString *stringNetworkPostsTable = @"CREATE TABLE IF NOT EXISTS NetworkPosts (";
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"likesCount INTEGER, "];
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"commentsCount INTEGER, "];
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"networkType INTEGER, "];
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"reson INTEGER, "];
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"dateCreate TEXT, "];
    stringNetworkPostsTable = [stringNetworkPostsTable stringByAppendingString:@"postId TEXT)"];
    
    return stringNetworkPostsTable;
}

+ (NSString*) stringForNetworkPostWithPrimaryKey :(NSInteger) primaryKey {
    return [NSString stringWithFormat:@"SELECT * FROM NetworkPosts WHERE id = %ld", (long)primaryKey];
}

+ (NSString*) stringForVKUpdateNetworkPost :(NetworkPost*) networkPost {
    NSString *stringPostsForUpdate = @"UPDATE NetworkPosts set ";
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"likesCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"commentsCount = \"%d\" "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"WHERE networkType = \"%d\" AND postId = \"%@\""];
    
    NSString *finalStringPostsForUpdate = [NSString stringWithFormat:stringPostsForUpdate, networkPost.likesCount, networkPost.commentsCount, networkPost.networkType, networkPost.postID];
    
    return finalStringPostsForUpdate;
}

+ (NSString*) stringForUpdateNetworkPost :(NetworkPost*) networkPost {
    NSString *stringPostsForUpdate = @"UPDATE NetworkPosts set ";
    
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"likesCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"commentsCount = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"networkType = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"reson = \"%d\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"dateCreate = \"%@\", "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"postId = \"%@\" "];
    stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"WHERE id = \"%d\""];
    
    NSString *finalStringPostsForUpdate = [NSString stringWithFormat:stringPostsForUpdate, networkPost.likesCount, networkPost.commentsCount, networkPost.networkType, networkPost.reason, networkPost.dateCreate, networkPost.postID, networkPost.primaryKey];
    
    return finalStringPostsForUpdate;
}

+ (NSString*) stringForDeleteNetworkPost : (NetworkPost*) networkPost {
    return [NSString stringWithFormat:@"DELETE from NetworkPosts WHERE id = \"%ld\"",(long)networkPost.primaryKey];
}

+ (NSString*) stringForUpdatePost :(Post*) post {
    NSString *stringPostsForUpdate = @"UPDATE Posts set ";
        stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"networkPostsId = \"%@\" "];
        stringPostsForUpdate = [stringPostsForUpdate stringByAppendingString:@"WHERE id = \"%d\""];
        [post convertArrayWithNetworkPostsIdsToString];
        NSString *finalStringPostsForUpdate = [NSString stringWithFormat:stringPostsForUpdate, post.postID, post.primaryKey];
        return finalStringPostsForUpdate;
}

@end
