//
//  ConstantsSocialNetworkLibrary.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSSocialNetworkLibraryConstants.h"

#pragma mark Facebook Constants

NSString *const MUSFacebookTitle = @"Login Facebook";
NSString *const MUSFacebookIconName = @"Facebook_Icon.png";
NSString *const MUSFacebookName = @"Facebook";

NSString *const MUSFacebookPermission_Email = @"email";
NSString *const MUSFacebookPermission_Publish_Actions = @"publish_actions";

NSString *const MUSFacebookGraphPath_Me = @"/me";
NSString *const MUSFacebookGraphPath_Me_Feed = @"me/feed";
NSString *const MUSFacebookGraphPath_Me_Photos = @"me/photos";
NSString *const MUSFacebookGraphPath_Search = @"/search?";

NSString *const MUSFacebookParametrsRequest = @"name,id,picture.type(large),gender,birthday,email,first_name,last_name,location,friends";
NSString *const MUSFacebookParameter_Fields = @"fields";
NSString *const MUSFacebookParameter_Message = @"message";
NSString *const MUSFacebookParameter_Place = @"place";
NSString *const MUSFacebookParameter_Picture = @"picture";

NSString *const MUSFacebookLocationParameter_Q = @"q";
NSString *const MUSFacebookLocationParameter_Type = @"type";
NSString *const MUSFacebookLocationParameter_Center = @"center";
NSString *const MUSFacebookLocationParameter_Distance = @"distance";

NSString *const MUSFacebookKeyOfPlaceDictionary = @"data";

NSString *const MUSFacebookError = @"Facebook error. Please retry again.";
NSInteger const MUSFacebookErrorCode = 1300;

NSString *const MUSFacebookSuccessUpdateNetworkPost = @"Facebook update all network posts";

#pragma mark Vkontakte Constants

NSString *const MUSVKAppID = @"5004830";
NSString *const MUSVKAllUserFields = @"first_name,last_name,photo_200_orig,id,birthday";
NSString *const MUSVKTitle = @"Login VK";
NSString *const MUSVKIconName = @"VK_icon.png";
NSString *const MUSVKName = @"VKontakt";

NSString *const MUSVKMethodPlacesSearch = @"places.search";

NSString *const MUSVKLocationParameter_Q = @"q";
NSString *const MUSVKLocationParameter_Latitude = @"latitude";
NSString *const MUSVKLocationParameter_Longitude = @"longitude";
NSString *const MUSVKLocationParameter_Radius = @"radius";

NSString *const MUSVKKeyOfPlaceDictionary = @"items";

NSInteger const MUSVKDistanceEqual300 = 300;
NSInteger const MUSVKDistanceEqual2400 = 2400;
NSInteger const MUSVKDistanceEqual18000 = 18000;

NSString *const MUSVKError = @"Vkontakte error. Please retry again.";
NSInteger const MUSVKErrorCode = 1100;


#pragma mark Twitter Contants
//keys from twitter

//NSString *const musTwitterConsumerSecret = @"saz4WSOgOL6wFPFXuIq94zbkumbuZnkldHIKIaAsyhJpHAYdke";
//NSString *const musTwitterConsumerKey = @"lGBCsHPLRVXB2kxQgzaZCdf1q";

//keys from fabric

NSString *const MUSTwitterConsumerSecret = @"sQNqSfSGW5lksTvqTCqn407pSQXUNCBvIsHJrOYlNKMhREtyT2";
NSString *const MUSTwitterConsumerKey = @"lUY36ubrBYXpYsZhJJvg8CYdf";



NSString *const MUSTwitterTitle = @"Login Twitter";
NSString *const MUSTwitterIconName = @"Twitter_icon.png";
NSString *const MUSTwitterName = @"Twitter";

NSString *const MUSTwitterError = @"Twitter error. Please retry again.";
NSInteger const MUSTwitterErrorCode = 1200;

NSString* const MUSTwitterLocationParameter_Latitude = @"lat";
NSString* const MUSTwitterLocationParameter_Longituge = @"long";

NSString *const MUSTwitterURL_Statuses_Show = @"https://api.twitter.com/1.1/statuses/show.json";
//NSString *const MUSTwitterURL_Users_Show = @"https://api.twitter.com/1.1/users/show.json";
NSString* const MUSTwitterURL_Geo_Search = @"https://api.twitter.com/1.1/geo/search.json";
NSString* const MUSTwitterURL_Statuses_Update = @"https://api.twitter.com/1.1/statuses/update.json";
NSString* const MUSTwitterURL_Media_Upload = @"https://upload.twitter.com/1.1/media/upload.json";


NSString* const MUSTwitterParameter_Status = @"status";
//NSString* const MUSTwitterParameter_PlaceID = @"place_id";
NSString* const MUSTwitterParameter_MediaID = @"media_ids";
NSString* const MUSTwitterParameter_Media = @"media";

NSString* const MUSTwitterJSONParameterForMediaID = @"media_id_string";


#pragma mark General Constants

NSString *const MUSGET = @"GET";
NSString *const MUSPOST = @"POST";
NSString *const MUSPostSuccess = @"Your post has been sent";
NSString *const MUSErrorWithDomainUniversalSharing = @"Universal Sharing library";
NSString *const MUSInfoPostsDidUpDateNotification = @"MUSInfoPostsDidUpDateNotification";
//NSString *const MUSNotificationStartUpdatingPost = @"MUSNotificationStartUpdatingPost";
//NSString *const MUSNotificationStopUpdatingPost = @"MUSNotificationStopUpdatingPost";
//NSString *const MUSNetworkPostsDidUpdateNotification = @"MUSUpdateNetworkPostNotification";




#pragma mark Error Constants

NSString *const MUSLocationDistanceError = @"Please, change distance of your current location! And try again!";
NSInteger const MUSLocationDistanceErrorCode = 1010;

NSString *const MUSLocationPropertiesError = @"One of the parameters specified was missing or invalid. Please check next Location properties: \n 1) string search; \n 2) distance;";
NSInteger const MUSLocationPropertiesErrorCode = 1011;

NSString *const MUSAccessError = @"Access denied!";
NSInteger const MUSAccessErrorCode = 1020;

NSString *const MUSConnectionError = @"NO INTERNET CONNECTION. You can resend this post from shared posts";
NSInteger const MUSConnectionErrorCode = 1030;

#pragma mark DataBase Constants

NSString *const MUSNameDataBase = @"UniversalSharing.sql";

#pragma mark Categories

NSString *const MUSReasonName_Shared = @"Success";
NSString *const MUSReasonName_Offline = @"Offline";
NSString *const MUSReasonName_Error = @"Failed";
