//
//  ConstantsSocialNetworkLibrary.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSSocialNetworkLibraryConstants.h"

#pragma mark Facebook Constants

NSString *const kRequestParametrsFacebook = @"name,id,picture,gender,birthday,email,first_name,last_name,location,friends";

#pragma mark Vkontakte Constants

NSString *const kVkAppID = @"5004830";
NSString *const ALL_USER_FIELDS = @"first_name,last_name,photo_200_orig,id,birthday";
NSString *const kTitleVkontakte = @"Login VKontakt";
NSString *const kIconNameVkontakte = @"VKimage.png";
NSString *const kVKKeyOfPlaceDictionary = @"items";



NSString *const kVkMethodPlacesSearch = @"places.search";




#pragma mark Twitter Contants

//NSString *const kConsumerSecret = @"gLZI37ssGqUcwr2RZlFoVcu5PO3rM0vodZ0teo3UuMLSdVoY1d";
//NSString *const kConsumerKey = @"YyvoW8VelrqrlO8f91xEvxdNe";

NSString *const kConsumerSecret = @"saz4WSOgOL6wFPFXuIq94zbkumbuZnkldHIKIaAsyhJpHAYdke";
NSString *const kConsumerKey = @"lGBCsHPLRVXB2kxQgzaZCdf1q";
NSString *const kTwitterUserName = @"twitterUserName";
NSString *const kTwitterUserCount = @"twitterUserCount";
NSString *const kRequestUrlTwitter = @"https://api.twitter.com/1.1/users/show.json";
NSString *const kTwitterRequestStatusUpdate = @"https://api.twitter.com/1.1/statuses/update.json";



#pragma mark General Constants
NSString *const kHttpMethodGET = @"GET";


#pragma mark Location Constants
NSString *const kLoactionQ = @"q";
NSString *const kLoactionLatitude = @"latitude";
NSString *const kLoactionLongitude = @"longitude";
NSString *const kLoactionRadius = @"radius";



