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


+ (User*) createFromDictionary:(id) dict andNetworkType :(NetworkType) networkType
{
    User *user = [[User alloc] init];
    
    switch (networkType) {
        case Facebook:
            user = [user createUserFromFB: dict];
            break;
        case VKontakt:
            user = [user createUserFromVK: dict];
            break;
        case Twitters:
            user = [user createUserFromTwitter: dict];
            break;
        default:
            break;
    }
    return user;
}

/*!
 @abstract return an instance of the User for facebook network.
 @param dictionary takes dictionary from facebook network.
 */

- (User*) createUserFromFB:(id)userDictionary {
    #warning "One more init?"
    User* currentUser = [[User alloc] init];
    
    if ([userDictionary isKindOfClass: [NSDictionary class]]) {
        currentUser.clientID = [userDictionary objectForKey : musFacebookParseUser_ID];
        currentUser.username = [userDictionary objectForKey : musFacebookParseUser_Name];
        currentUser.firstName = [userDictionary objectForKey :musFacebookParseUser_First_Name];
        currentUser.lastName = [userDictionary objectForKey : musFacebookParseUser_Last_Name];
        currentUser.networkType = Facebook;
        /////////////////////////////////////for database
        currentUser.isLogin = 1;
        currentUser.isVisible = 1;
        ///////////////////////////////////////////
        NSDictionary *pictureDictionary = [userDictionary objectForKey : musFacebookParseUser_Picture];
        NSDictionary *pictureDataDictionary = [pictureDictionary objectForKey : musFacebookParseUser_Data];
        currentUser.photoURL = [pictureDataDictionary objectForKey : musFacebookParseUser_Photo_Url];
    }
    return currentUser;
}

/*!
 @abstract return an instance of the User for vkontakte network.
 @param dictionary takes dictionary from vkontakte network.
 */

- (User*) createUserFromVK : (id) userDictionary {
    #warning "One more init?"
    
    User *currentUser = [[User alloc] init];
    if ([userDictionary isKindOfClass:[NSDictionary class]]){
        currentUser.dateOfBirth = [userDictionary objectForKey : musVKParseUser_BirthDate];
        NSDictionary *cityDictionary = [userDictionary objectForKey : musVKParseUser_City];
        currentUser.city = [cityDictionary objectForKey : musVKParseUser_Title];
        
        currentUser.firstName = [userDictionary objectForKey : musVKParseUser_First_Name];
        currentUser.lastName = [userDictionary objectForKey : musVKParseUser_Last_Name];
        currentUser.networkType = VKontakt;
        currentUser.clientID = [NSString stringWithFormat: @"%@", [userDictionary objectForKey : musVKParseUser_ID]];
        currentUser.photoURL = [userDictionary objectForKey : musVKParseUser_Photo_Url];
        /////////////////////////////////////for database
        currentUser.isLogin = 1;
        currentUser.isVisible = 1;
        ///////////////////////////////////////////
    }
    return currentUser;
}

/*!
 @abstract return an instance of the User for twitter network.
 @param dictionary takes dictionary from twitter network.
 */

- (User*) createUserFromTwitter:(TWTRUser*)userDictionary {
    
    #warning "One more init?"
    User *currentUser = [[User alloc] init];
    currentUser.clientID = userDictionary.userID;
    currentUser.lastName = userDictionary.screenName;
    currentUser.firstName = userDictionary.name;
    currentUser.networkType = Twitters;
    /////////////////////////////////////for database
    currentUser.isLogin = 1;
    currentUser.isVisible = 1;
    ///////////////////////////////////////////
    NSString *photoURL_max = userDictionary.profileImageURL;
    photoURL_max = [photoURL_max stringByReplacingOccurrencesOfString:@"_normal"
                                                           withString:@""];
    currentUser.photoURL = photoURL_max;
    return currentUser;
    
    
}


@end
