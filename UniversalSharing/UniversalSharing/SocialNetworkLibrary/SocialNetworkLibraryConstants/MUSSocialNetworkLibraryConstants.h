//
//  ConstantsSocialNetworkLibrary.h
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Blocks

typedef void (^Complition)(id result, NSError *error);

typedef void (^ComplitionPlaces)(NSMutableArray *places, NSError *error);


#pragma mark Types

typedef NS_ENUM (NSInteger, NetworkType) {
    Facebook,
    VKontakt,
    Twitters
};

typedef NS_ENUM (NSInteger, ImageType) {
    PNG,
    JPEG
};

typedef NS_ENUM (NSInteger, DistanceType) {
    DistanceType1,
    DistanceType2,
    DistanceType3,
    DistanceType4
};



#pragma mark Facebook Constants

FOUNDATION_EXPORT NSString *const kRequestParametrsFacebook;

#pragma mark Vkontakte Constants

FOUNDATION_EXPORT NSString *const kVkAppID;
FOUNDATION_EXPORT NSString *const ALL_USER_FIELDS;
FOUNDATION_EXPORT NSString *const kTitleVkontakte;
FOUNDATION_EXPORT NSString *const kIconNameVkontakte;
FOUNDATION_EXPORT NSString *const kVKKeyOfPlaceDictionary;



FOUNDATION_EXPORT NSString *const kVkMethodPlacesSearch;

FOUNDATION_EXPORT NSInteger const kVKDistanceEqual300;
FOUNDATION_EXPORT NSInteger const kVKDistanceEqual2400;
FOUNDATION_EXPORT NSInteger const kVKDistanceEqual18000;



#pragma mark Twitter Constants

FOUNDATION_EXPORT NSString *const kConsumerSecret;
FOUNDATION_EXPORT NSString *const kConsumerKey;
FOUNDATION_EXPORT NSString *const kTwitterUserName;
FOUNDATION_EXPORT NSString *const kTwitterUserCount;
FOUNDATION_EXPORT NSString *const kRequestUrlTwitter;
FOUNDATION_EXPORT NSString *const kTwitterRequestStatusUpdate;


#pragma mark General Constants
FOUNDATION_EXPORT NSString *const kHttpMethodGET;




#pragma mark Location Constants
FOUNDATION_EXPORT NSString *const kLoactionQ;
FOUNDATION_EXPORT NSString *const kLoactionLatitude;
FOUNDATION_EXPORT NSString *const kLoactionLongitude;
FOUNDATION_EXPORT NSString *const kLoactionRadius;



