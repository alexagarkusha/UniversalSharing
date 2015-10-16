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
typedef void (^ProgressLoadingBlock)(float result);
typedef void (^LoadingBlock)(id currentNetworkType, float result);
typedef void (^UpdateNetworkPostsBlock)(id result);

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


#pragma mark DataBase Constants

FOUNDATION_EXPORT NSString *const MUSNameDataBase;

#pragma mark - General Constants

FOUNDATION_EXPORT NSString *const MUSNetworkPost_Update_Error_Data;
FOUNDATION_EXPORT NSString *const MUSNetworkPost_Update_Already_Update;
FOUNDATION_EXPORT NSString *const MUSNetworkPost_Update_Error_Update;
FOUNDATION_EXPORT NSString *const MUSNetworkPost_Update_Updated;
FOUNDATION_EXPORT NSString *const MUSInfoPostsDidUpDateNotification;

#pragma mark Error Constants

FOUNDATION_EXPORT NSString *const MUSConnectionError;
FOUNDATION_EXPORT NSInteger const MUSConnectionErrorCode;

FOUNDATION_EXPORT NSString *const MUSErrorWithDomainUniversalSharing;

#pragma mark - ReachabilityManager

FOUNDATION_EXPORT NSString *const MUSReachabilityManager_Host_Name;



