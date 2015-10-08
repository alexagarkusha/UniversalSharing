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

FOUNDATION_EXPORT NSString *const musFacebookTitle;
FOUNDATION_EXPORT NSString *const musFacebookIconName;
FOUNDATION_EXPORT NSString *const musFacebookName;

FOUNDATION_EXPORT NSString *const musFacebookPermission_Email;
FOUNDATION_EXPORT NSString *const musFacebookPermission_Publish_Actions;

FOUNDATION_EXPORT NSString *const musFacebookGraphPath_Me;
FOUNDATION_EXPORT NSString *const musFacebookGraphPath_Me_Feed;
FOUNDATION_EXPORT NSString *const musFacebookGraphPath_Me_Photos;
FOUNDATION_EXPORT NSString *const musFacebookGraphPath_Search;

FOUNDATION_EXPORT NSString *const musFacebookParametrsRequest;
FOUNDATION_EXPORT NSString *const musFacebookParameter_Fields;
FOUNDATION_EXPORT NSString *const musFacebookParameter_Message;
FOUNDATION_EXPORT NSString *const musFacebookParameter_Place;
FOUNDATION_EXPORT NSString *const musFacebookParameter_Picture;

FOUNDATION_EXPORT NSString *const musFacebookLoactionParameter_Q;
FOUNDATION_EXPORT NSString *const musFacebookLoactionParameter_Type;
FOUNDATION_EXPORT NSString *const musFacebookLoactionParameter_Center;
FOUNDATION_EXPORT NSString *const musFacebookLoactionParameter_Distance;

FOUNDATION_EXPORT NSString *const musFacebookKeyOfPlaceDictionary;

FOUNDATION_EXPORT NSString *const musFacebookError;
FOUNDATION_EXPORT NSInteger const musFacebookErrorCode;


#pragma mark Vkontakte Constants

FOUNDATION_EXPORT NSString *const musVKAppID;
FOUNDATION_EXPORT NSString *const musVKAllUserFields;
FOUNDATION_EXPORT NSString *const musVKTitle;
FOUNDATION_EXPORT NSString *const musVKIconName;
FOUNDATION_EXPORT NSString *const musVKName;

FOUNDATION_EXPORT NSString *const musVKMethodPlacesSearch;

FOUNDATION_EXPORT NSString *const musVKLoactionParameter_Q;
FOUNDATION_EXPORT NSString *const musVKLoactionParameter_Latitude;
FOUNDATION_EXPORT NSString *const musVKLoactionParameter_Longitude;
FOUNDATION_EXPORT NSString *const musVKLoactionParameter_Radius;

FOUNDATION_EXPORT NSString *const musVKKeyOfPlaceDictionary;

FOUNDATION_EXPORT NSInteger const musVKDistanceEqual300;
FOUNDATION_EXPORT NSInteger const musVKDistanceEqual2400;
FOUNDATION_EXPORT NSInteger const musVKDistanceEqual18000;

FOUNDATION_EXPORT NSString *const musVKError;
FOUNDATION_EXPORT NSInteger const musVKErrorCode;


#pragma mark Twitter Constants

FOUNDATION_EXPORT NSString *const musTwitterConsumerSecret;
FOUNDATION_EXPORT NSString *const musTwitterConsumerKey;

FOUNDATION_EXPORT NSString *const musTwitterTitle;
FOUNDATION_EXPORT NSString *const musTwitterIconName;
FOUNDATION_EXPORT NSString *const musTwitterName;

FOUNDATION_EXPORT NSString *const musTwitterError;
FOUNDATION_EXPORT NSInteger const musTwitterErrorCode;

FOUNDATION_EXPORT NSString *const musTwitterLocationParameter_Latitude;
FOUNDATION_EXPORT NSString *const musTwitterLocationParameter_Longituge;

FOUNDATION_EXPORT NSString *const musTwitterURL_Statuses_Show;
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



