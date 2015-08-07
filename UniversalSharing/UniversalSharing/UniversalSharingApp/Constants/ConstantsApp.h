//
//  Constants.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantsApp : NSObject

typedef NS_ENUM(NSInteger, TabBarItemIndex) {
    Share_photo,
    Share_location,
};

typedef NS_ENUM(NSInteger, AlertButtonIndex) {
    Cancel,
    Album,
    Camera,
    Remove,
};


#pragma mark AccountsViewController Constants

FOUNDATION_EXPORT NSString *const goToUserDetailViewControllerSegueIdentifier;

#pragma mark MUSShareViewController Constants

FOUNDATION_EXPORT NSString *const kPlaceholderText;
FOUNDATION_EXPORT NSString *const goToLocationViewControllerSegueIdentifier;
FOUNDATION_EXPORT NSString *const collectionViewCellIdentifier;
FOUNDATION_EXPORT NSString *const distanceEqual100;
FOUNDATION_EXPORT NSString *const distanceEqual1000;
FOUNDATION_EXPORT NSString *const distanceEqual25000;


//===
FOUNDATION_EXPORT NSInteger const countOfAllowedPics;

#pragma mark - Errors

FOUNDATION_EXPORT NSString *const musAppError_With_Domain_Universal_Sharing;
FOUNDATION_EXPORT NSString *const musAppError_Internet_Connection;


#pragma mark - MUSPhotoManager

FOUNDATION_EXPORT NSInteger const musAppCompressionSizePicture_By_Height;
FOUNDATION_EXPORT NSInteger const musAppCompressionSizePicture_By_Width;

FOUNDATION_EXPORT NSString *const musAppError_NO_Camera;
FOUNDATION_EXPORT NSInteger const musAppError_NO_Camera_Code;

FOUNDATION_EXPORT NSString *const musAppAlertTitle_Share_Photo;
FOUNDATION_EXPORT NSString *const musAppAlertTitle_NO_Pics_Anymore;

#pragma mark MUSPhotoManager Constants

typedef void (^Complition)(id result, NSError *error);
typedef void (^ComplitionLocation)(id result, NSError *error);

#pragma mark MUSAccountViewController Constants

FOUNDATION_EXPORT NSString *const editButtonTitle;
FOUNDATION_EXPORT NSString *const doneButtonTitle;
FOUNDATION_EXPORT NSString *const showButtonTitle;
FOUNDATION_EXPORT NSString *const hideButtonTitle;

#pragma mark - General constants

FOUNDATION_EXPORT NSString *const musAppButtonTitle_Cancel;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_OK;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Album;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Camera;


@end
