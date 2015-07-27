//
//  User.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "User.h"

@implementation User

#warning "Merge me better"

+ (User*) createFromDictionary:(NSDictionary*) dict andNetworkType :(NetworkType) networkType
{
    User *user = [[User alloc] init];
    
    switch (networkType) {
        case Facebook:
            user = [user createUserFromFB: dict];
            break;
        case VKontakt:
            user = [user createUserFromVK: dict];
            break;
        case Twitter:
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
    if ([userDictionary isKindOfClass:[NSArray class]]) {
        NSArray *currentUserArray = userDictionary;
        if ([[currentUserArray firstObject] isKindOfClass:[NSDictionary class]]){
            NSDictionary *currentUserDictionary = [currentUserArray firstObject];
            currentUser.dateOfBirth = [currentUserDictionary objectForKey:@"bdate"];
            
            NSDictionary *cityDictionary = [currentUserDictionary objectForKey: @"city"];
            currentUser.city = [cityDictionary objectForKey: @"title"];
            
            currentUser.firstName = [currentUserDictionary objectForKey:@"first_name"];
            currentUser.lastName = [currentUserDictionary objectForKey:@"last_name"];
            currentUser.networkType = VKontakt;
            currentUser.clientID = [NSString stringWithFormat: @"%@", [currentUserDictionary objectForKey:@"id"]];
            currentUser.photoURL = [currentUserDictionary objectForKey: @"photo_max"];
        }
    }
    return currentUser;
}


- (User*) createUserFromTwitter:(id)userDictionary {
    User *currentUser = [[User alloc] init];
    if ([userDictionary isKindOfClass:[NSDictionary class]]) {
        currentUser.clientID = [NSString stringWithFormat: @"%@", [userDictionary objectForKey:@"id"]];
        currentUser.username = [userDictionary objectForKey:@"screen_name"];
        currentUser.firstName = [userDictionary objectForKey:@"name"];
        //currentUser.lastName = [userDictionary objectForKey:@"last_name"];
        currentUser.networkType = Twitter;
        
        NSString *photoURL_max = [userDictionary objectForKey: @"profile_image_url"];
        photoURL_max = [photoURL_max stringByReplacingOccurrencesOfString:@"_normal"
                                                               withString:@""];
        currentUser.photoURL = photoURL_max;
        
        
        //currentUser.photoURL_max = @"http://pbs.twimg.com/profile_images/624165685976039425/2ea7-TL8.jpg";
        
        //currentUser.photoURL_max = [userDictionary objectForKey: @"profile_image_url" ];
        currentUser.city = [userDictionary objectForKey: @"location"];
        //currentUser.dateOfBirth
    }
    
    
    
    return currentUser;
    
    
}


@end
