//
//  User.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "User.h"
#import <TwitterKit/TwitterKit.h>
#import "MUSSocialNetworkLibraryConstantsForParseObjects.h"
#import "InternetConnectionManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "DataBaseManager.h"
#import "PostImagesManager.h"

@implementation User


+ (instancetype) create {
    User *user = [[User alloc] init];
    user.username = @"";
    user.firstName = @"";
    user.lastName = @"";
    user.clientID = @"";
    user.photoURL = @"";
    user.networkType = MUSAllNetworks;
    user.primaryKey = 0;
    return user;
}

- (void) insertIntoDataBase {
    [[DataBaseManager sharedManager] insertObjectIntoTable: self];
}


- (void) removeUser {
    [[PostImagesManager manager] removeImageFromFileManagerByImagePath: _photoURL];
    [[DataBaseManager sharedManager] deleteObjectFromDataBaseWithRequestStrings:[MUSDatabaseRequestStringsHelper stringForDeleteUserByClientId: _clientID]];
}


#pragma mark - GETTERS

- (NSString *)username {
    if (!_username || [_username isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _username;
}

- (NSString *)firstName {
    if (!_firstName || [_firstName isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _firstName;
}

- (NSString *)lastName {
    if (!_lastName || [_lastName isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _lastName;
}


@end
