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
typedef void (^ProgressLoadingComplition)(float result);
typedef void (^ProgressLoadingImagesToVK)(int objectOfLoading, long long bytesLoaded, long long bytesTotal);
typedef void (^ProgressLoading)(id currentNetworkType, float result);
typedef void (^UpdateNetworkPostsComplition)(id result);
////go apptypedef void (^ComplitionWithArrays)(id arrayLogin, id arrayHidden, id arrayUnactive, NSError *error);

#pragma mark Types

typedef NS_ENUM (NSInteger, NetworkType) {
    MUSAllNetworks,
    MUSFacebook,
    MUSTwitters,
    MUSVKontakt
};

typedef NS_ENUM (NSInteger, ImageType) {
    MUSPNG,
    MUSJPEG
};


typedef NS_ENUM (NSInteger, DistanceType) {
    MUSDistanceType1,
    MUSDistanceType2,
    MUSDistanceType3,
    MUSDistanceType4
};

typedef NS_ENUM (NSInteger, ReasonType) {
    MUSAllReasons,
    MUSOffline,
    MUSErrorConnection,
    MUSConnect
};

//go app
#pragma mark Facebook Constants

FOUNDATION_EXPORT NSString *const MUSFacebookTitle;
FOUNDATION_EXPORT NSString *const MUSFacebookIconName;
FOUNDATION_EXPORT NSString *const MUSFacebookName;

FOUNDATION_EXPORT NSString *const MUSFacebookPermission_Email;
FOUNDATION_EXPORT NSString *const MUSFacebookPermission_Publish_Actions;

FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Me;
FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Me_Feed;
FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Me_Photos;
FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Search;

FOUNDATION_EXPORT NSString *const MUSFacebookParametrsRequest;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Fields;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Message;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Place;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Picture;

FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Q;
FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Type;
FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Center;
FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Distance;

FOUNDATION_EXPORT NSString *const MUSFacebookKeyOfPlaceDictionary;

FOUNDATION_EXPORT NSString *const MUSFacebookError;
FOUNDATION_EXPORT NSInteger const MUSFacebookErrorCode;


#pragma mark Vkontakte Constants

FOUNDATION_EXPORT NSString *const MUSVKAppID;
FOUNDATION_EXPORT NSString *const MUSVKAllUserFields;
FOUNDATION_EXPORT NSString *const MUSVKTitle;
FOUNDATION_EXPORT NSString *const MUSVKIconName;
FOUNDATION_EXPORT NSString *const MUSVKName;

FOUNDATION_EXPORT NSString *const MUSVKMethodPlacesSearch;

FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Q;
FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Latitude;
FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Longitude;
FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Radius;

FOUNDATION_EXPORT NSString *const MUSVKKeyOfPlaceDictionary;

FOUNDATION_EXPORT NSInteger const MUSVKDistanceEqual300;
FOUNDATION_EXPORT NSInteger const MUSVKDistanceEqual2400;
FOUNDATION_EXPORT NSInteger const MUSVKDistanceEqual18000;

FOUNDATION_EXPORT NSString *const MUSVKError;
FOUNDATION_EXPORT NSInteger const MUSVKErrorCode;


#pragma mark Twitter Constants

FOUNDATION_EXPORT NSString *const MUSTwitterConsumerSecret;
FOUNDATION_EXPORT NSString *const MUSTwitterConsumerKey;

FOUNDATION_EXPORT NSString *const MUSTwitterTitle;
FOUNDATION_EXPORT NSString *const MUSTwitterIconName;
FOUNDATION_EXPORT NSString *const MUSTwitterName;

FOUNDATION_EXPORT NSString *const MUSTwitterError;
FOUNDATION_EXPORT NSInteger const MUSTwitterErrorCode;

FOUNDATION_EXPORT NSString *const MUSTwitterLocationParameter_Latitude;
FOUNDATION_EXPORT NSString *const MUSTwitterLocationParameter_Longituge;

FOUNDATION_EXPORT NSString *const MUSTwitterURL_Statuses_Show;
FOUNDATION_EXPORT NSString *const musTwitterURL_Users_Show;
FOUNDATION_EXPORT NSString *const musTwitterURL_Geo_Search;
FOUNDATION_EXPORT NSString *const musTwitterURL_Statuses_Update;
FOUNDATION_EXPORT NSString *const musTwitterURL_Media_Upload;

FOUNDATION_EXPORT NSString *const musTwitterParameter_Status;
FOUNDATION_EXPORT NSString *const musTwitterParameter_PlaceID;
FOUNDATION_EXPORT NSString *const musTwitterParameter_MediaID;
FOUNDATION_EXPORT NSString *const musTwitterParameter_Media;

FOUNDATION_EXPORT NSString *const musTwitterJSONParameterForMediaID;


#pragma mark General Constants

FOUNDATION_EXPORT NSString *const musGET;
FOUNDATION_EXPORT NSString *const musPOST;
FOUNDATION_EXPORT NSString *const musPostSuccess;
FOUNDATION_EXPORT NSString *const musErrorWithDomainUniversalSharing;
FOUNDATION_EXPORT NSString *const MUSNotificationPostsInfoWereUpDated;
FOUNDATION_EXPORT NSString *const MUSNotificationStartUpdatingPost;
FOUNDATION_EXPORT NSString *const MUSNotificationStopUpdatingPost;
FOUNDATION_EXPORT NSString *const MUSNetworkPostsWereUpdatedNotification;


#pragma mark Error Constants

FOUNDATION_EXPORT NSString *const musErrorLocationDistance;
FOUNDATION_EXPORT NSInteger const musErrorLocationDistanceCode;

FOUNDATION_EXPORT NSString *const musErrorLocationProperties;
FOUNDATION_EXPORT NSInteger const musErrorLocationPropertiesCode;

FOUNDATION_EXPORT NSString *const musErrorAccesDenied;
FOUNDATION_EXPORT NSInteger const musErrorAccesDeniedCode;

FOUNDATION_EXPORT NSString *const musErrorConnection;
FOUNDATION_EXPORT NSInteger const musErrorConnectionCode;

#pragma mark DataBase Constants

FOUNDATION_EXPORT NSString *const nameDataBase;

#pragma mark Categories

FOUNDATION_EXPORT NSString *const musReasonName_Shared;
FOUNDATION_EXPORT NSString *const musReasonName_Offline;
FOUNDATION_EXPORT NSString *const musReasonName_Error;



