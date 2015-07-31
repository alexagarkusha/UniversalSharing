//
//  User.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "User.h"
#import <TwitterKit/TwitterKit.h>

@implementation User

//#warning "Merge me better"

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
    
    
//    User *user = [User new];
//    switch (networkType) {
//            
//        case Facebook:
//            
//            user.userName = [dict objectForKey:@"username"];
//            user.firstName = [dict objectForKey:@"first_name"];
//            user.lastName = [dict objectForKey:@"last_name"];
//            user.dateOfBirth = [dict objectForKey:@"birthday"];
//            user.city = [dict objectForKey:@"location"];
//            user.clientId = [dict objectForKey:@"id"];
//            user.photoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.clientId];
//            user.friends = [dict objectForKey:@"friends"];
//            user.networkType = Facebook;
//            break;
//            
//        case VKontakt:
//            
//            user.firstName = [dict objectForKey:@"first_name"];
//            user.lastName = [dict objectForKey:@"last_name"];
//            //user.dateOfBirth = [dict objectForKey:@"birthday"];
//            //user.city = [dict objectForKey:@"location"];
//            user.clientId = [[dict objectForKey:@"id"] stringValue];
//            user.photoURL = [dict objectForKey:@"photo_200_orig"];
//            break;
//            
//        case Twitter:
//            
//            user.firstName = [dict objectForKey:@"name"];
//            user.lastName = [dict objectForKey:@"screen_name"];
//            //user.dateOfBirth = [dict objectForKey:@"birthday"];
//            //user.city = [dict objectForKey:@"location"];
//            user.clientId = [[dict objectForKey:@"id"]stringValue];
//            user.photoURL = [dict objectForKey:@"profile_image_url_https"];
//            break;
//            
//        default:
//            break;
//    }
//    
    return user;
    
}

- (User*) createUserFromFB:(id)userDictionary {
    User* currentUser = [[User alloc] init];
    
    
    if ([userDictionary isKindOfClass: [NSDictionary class]]) {
        currentUser.clientID = [userDictionary objectForKey:@"id"];
        currentUser.username = [userDictionary objectForKey:@"name"];
        currentUser.firstName = [userDictionary objectForKey:@"first_name"];
        currentUser.lastName = [userDictionary objectForKey:@"last_name"];
        currentUser.networkType = Facebook;
        
        NSDictionary *pictureDictionary = [userDictionary objectForKey: @"picture"];
        NSDictionary *pictureDataDictionary = [pictureDictionary objectForKey:@"data"];
        
        currentUser.photoURL = [pictureDataDictionary objectForKey:@"url"];
        
        /*
         BOOL isSilhouette = (BOOL)[pictureDataDictionary objectForKey:@"is_silhouette"];
         
         if (isSilhouette) {
         currentUser.photoURL_max = [pictureDataDictionary objectForKey:@"url"];
         };
         */
    }
    return currentUser;
}


- (User*) createUserFromVK : (id) userDictionary {
    User *currentUser = [[User alloc] init];
        if ([userDictionary isKindOfClass:[NSDictionary class]]){
            currentUser.dateOfBirth = [userDictionary objectForKey:@"bdate"];
            NSDictionary *cityDictionary = [userDictionary objectForKey: @"city"];
            currentUser.city = [cityDictionary objectForKey: @"title"];
            
            currentUser.firstName = [userDictionary objectForKey:@"first_name"];
            currentUser.lastName = [userDictionary objectForKey:@"last_name"];
            currentUser.networkType = VKontakt;
            currentUser.clientID = [NSString stringWithFormat: @"%@", [userDictionary objectForKey:@"id"]];
            currentUser.photoURL = [userDictionary objectForKey: @"photo_200_orig"];
        }
   
    return currentUser;
}


- (User*) createUserFromTwitter:(TWTRUser*)userDictionary {
    User *currentUser = [[User alloc] init];
    //if ([userDictionary isKindOfClass:[TWTRUser class]]) {
    currentUser.clientID = userDictionary.userID;
    currentUser.lastName = userDictionary.screenName;
        currentUser.firstName = userDictionary.name;
        //currentUser.lastName = [userDictionary objectForKey:@"last_name"];
        currentUser.networkType = Twitters;
        
        NSString *photoURL_max = userDictionary.profileImageLargeURL;
        photoURL_max = [photoURL_max stringByReplacingOccurrencesOfString:@"_normal"
                                                              withString:@""];
        currentUser.photoURL = photoURL_max;
    
        
        //currentUser.photoURL_max = @"http://pbs.twimg.com/profile_images/624165685976039425/2ea7-TL8.jpg";
        
        //currentUser.photoURL_max = [userDictionary objectForKey: @"profile_image_url" ];
        //currentUser.city = [userDictionary objectForKey: @"location"];
        //currentUser.dateOfBirth
    //}
    
    
    
    return currentUser;
    
    
}


@end
