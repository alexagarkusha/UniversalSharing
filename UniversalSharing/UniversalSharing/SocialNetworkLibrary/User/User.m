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





+ (User*) createFromDictionary:(id) dict andNetworkType :(NetworkType) networkType
{
   // User *user = [[User alloc] init];
    
    switch (networkType) {
        case MUSFacebook:
            return [User createUserFromFB: dict];
            break;
        case MUSVKontakt:
           return [User createUserFromVK: dict];
            break;
        case MUSTwitters:
            return [User createUserFromTwitter: dict];
            break;
        default:
            break;
    }
    return nil;
}

/*!
 @abstract return an instance of the User for facebook network.
 @param dictionary takes dictionary from facebook network.
 */

+ (User*) createUserFromFB:(id)userDictionary {
    User* currentUser = [[User alloc] init];
    
    if ([userDictionary isKindOfClass: [NSDictionary class]]) {
        currentUser.clientID = [userDictionary objectForKey : MUSFacebookParseUser_ID];
        currentUser.username = [userDictionary objectForKey : MUSFacebookParseUser_Name];
        currentUser.firstName = [userDictionary objectForKey :MUSFacebookParseUser_First_Name];
        currentUser.lastName = [userDictionary objectForKey : MUSFacebookParseUser_Last_Name];
        currentUser.networkType = MUSFacebook;
        NSDictionary *pictureDictionary = [userDictionary objectForKey : MUSFacebookParseUser_Picture];
        NSDictionary *pictureDataDictionary = [pictureDictionary objectForKey : MUSFacebookParseUser_Data];
        currentUser.photoURL = [pictureDataDictionary objectForKey : MUSFacebookParseUser_Photo_Url];
    }
    return currentUser;
}

/*!
 @abstract return an instance of the User for vkontakte network.
 @param dictionary takes dictionary from vkontakte network.
 */

+ (User*) createUserFromVK : (id) userDictionary {
    User *currentUser = [[User alloc] init];
    if ([userDictionary isKindOfClass:[NSDictionary class]]){
        currentUser.firstName = [userDictionary objectForKey : MUSVKParseUser_First_Name];
        currentUser.lastName = [userDictionary objectForKey : MUSVKParseUser_Last_Name];
        currentUser.networkType = MUSVKontakt;
        currentUser.clientID = [NSString stringWithFormat: @"%@", [userDictionary objectForKey : MUSVKParseUser_ID]];
        currentUser.photoURL = [userDictionary objectForKey : MUSVKParseUser_Photo_Url];
    }
    return currentUser;
}

/*!
 @abstract return an instance of the User for twitter network.
 @param dictionary takes dictionary from twitter network.
 */

+ (User*) createUserFromTwitter:(TWTRUser*)userDictionary {
    User *currentUser = [[User alloc] init];
    currentUser.clientID = userDictionary.userID;
    currentUser.lastName = userDictionary.screenName;
    currentUser.firstName = userDictionary.name;
    currentUser.networkType = MUSTwitters;
    NSString *photoURL_max = userDictionary.profileImageURL;
    photoURL_max = [photoURL_max stringByReplacingOccurrencesOfString:@"_normal"
                                                           withString:@""];
    currentUser.photoURL = photoURL_max;
    return currentUser;
    
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
