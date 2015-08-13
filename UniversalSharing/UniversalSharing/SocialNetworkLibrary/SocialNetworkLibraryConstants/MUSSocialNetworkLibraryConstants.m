//
//  ConstantsSocialNetworkLibrary.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSSocialNetworkLibraryConstants.h"

#pragma mark Facebook Constants

NSString *const musFacebookTitle = @"Login Facebook";
NSString *const musFacebookIconName = @"FBimage.jpg";
NSString *const musFacebookName = @"Facebook";

NSString *const musFacebookPermission_Email = @"email";
NSString *const musFacebookPermission_Publish_Actions = @"publish_actions";

NSString *const musFacebookGraphPath_Me = @"/me";
NSString *const musFacebookGraphPath_Me_Feed = @"me/feed";
NSString *const musFacebookGraphPath_Me_Photos = @"me/photos";
NSString *const musFacebookGraphPath_Search = @"/search?";

NSString *const musFacebookParametrsRequest = @"name,id,picture.type(large),gender,birthday,email,first_name,last_name,location,friends";
NSString *const musFacebookParameter_Fields = @"fields";
NSString *const musFacebookParameter_Message = @"message";
NSString *const musFacebookParameter_Place = @"place";
NSString *const musFacebookParameter_Picture = @"picture";

NSString *const musFacebookLoactionParameter_Q = @"q";
NSString *const musFacebookLoactionParameter_Type = @"type";
NSString *const musFacebookLoactionParameter_Center = @"center";
NSString *const musFacebookLoactionParameter_Distance = @"distance";

NSString *const musFacebookKeyOfPlaceDictionary = @"data";

NSString *const musFacebookError = @"Facebook error. Please retry againe.";
NSInteger const musFacebookErrorCode = 1300;


#pragma mark Vkontakte Constants

NSString *const musVKAppID = @"5004830";
NSString *const musVKAllUserFields = @"first_name,last_name,photo_200_orig,id,birthday";
NSString *const musVKTitle = @"Login VKontakt";
NSString *const musVKIconName = @"VKimage.png";
NSString *const musVKName = @"VK";

NSString *const musVKMethodPlacesSearch = @"places.search";

NSString *const musVKLoactionParameter_Q = @"q";
NSString *const musVKLoactionParameter_Latitude = @"latitude";
NSString *const musVKLoactionParameter_Longitude = @"longitude";
NSString *const musVKLoactionParameter_Radius = @"radius";

NSString *const musVKKeyOfPlaceDictionary = @"items";

NSInteger const musVKDistanceEqual300 = 300;
NSInteger const musVKDistanceEqual2400 = 2400;
NSInteger const musVKDistanceEqual18000 = 18000;

NSString *const musVKError = @"Vkontakte error. Please retry againe.";
NSInteger const musVKErrorCode = 1100;


#pragma mark Twitter Contants
//keys from twitter

//NSString *const musTwitterConsumerSecret = @"saz4WSOgOL6wFPFXuIq94zbkumbuZnkldHIKIaAsyhJpHAYdke";
//NSString *const musTwitterConsumerKey = @"lGBCsHPLRVXB2kxQgzaZCdf1q";

//keys from fabric

NSString *const musTwitterConsumerSecret = @"sQNqSfSGW5lksTvqTCqn407pSQXUNCBvIsHJrOYlNKMhREtyT2";
NSString *const musTwitterConsumerKey = @"lUY36ubrBYXpYsZhJJvg8CYdf";



NSString *const musTwitterTitle = @"Login Twitter";
NSString *const musTwitterIconName = @"TWimage.jpeg";
NSString *const musTwitterName = @"Twitter";

NSString *const musTwitterError = @"Twitter error. Please retry againe.";
NSInteger const musTwitterErrorCode = 1200;

NSString* const musTwitterLocationParameter_Latitude = @"lat";
NSString* const musTwitterLocationParameter_Longituge = @"long";

NSString *const musTwitterURL_Users_Show = @"https://api.twitter.com/1.1/users/show.json";
NSString* const musTwitterURL_Geo_Search = @"https://api.twitter.com/1.1/geo/search.json";
NSString* const musTwitterURL_Statuses_Update = @"https://api.twitter.com/1.1/statuses/update.json";
NSString* const musTwitterURL_Media_Upload = @"https://upload.twitter.com/1.1/media/upload.json";


NSString* const musTwitterParameter_Status = @"status";
NSString* const musTwitterParameter_PlaceID = @"place_id";
NSString* const musTwitterParameter_MediaID = @"media_ids";
NSString* const musTwitterParameter_Media = @"media";

NSString* const musTwitterJSONParameterForMediaID = @"media_id_string";


#pragma mark General Constants

NSString *const musGET = @"GET";
NSString *const musPOST = @"POST";
NSString *const musPostSuccess = @"Your post has been sent";
NSString *const musErrorWithDomainUniversalSharing = @"Universal Sharing library";

#pragma mark Error Constants

NSString *const musErrorLocationDistance = @"Please, change distance of your current location! And try again!";
NSInteger const musErrorLocationDistanceCode = 1010;

NSString *const musErrorLocationProperties = @"One of the parameters specified was missing or invalid. Please check next Location properties: \n 1) string search; \n 2) distance;";
NSInteger const musErrorLocationPropertiesCode = 1011;

NSString *const musErrorAccesDenied = @"Access denied!";
NSInteger const musErrorAccesDeniedCode = 1020;

NSString *const musErrorConnection = @"Error connection to social network. Please, retry again";
NSInteger const musErrorConnectionCode = 1030;



