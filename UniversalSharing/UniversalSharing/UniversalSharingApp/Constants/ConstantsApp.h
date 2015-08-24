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

typedef NS_ENUM(NSInteger, FilterInColumnType) {
    ByNetworkType,
    ByShareReason,
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
FOUNDATION_EXPORT NSString *const titleActionSheet;
FOUNDATION_EXPORT NSString *const musAppAlertTitle_NO_Pics_Anymore;
FOUNDATION_EXPORT NSString *const titleCongratulatoryAlert;
FOUNDATION_EXPORT NSString *const changePlaceholderWhenStartEditing;

//===
FOUNDATION_EXPORT NSInteger const countOfAllowedPics;
FOUNDATION_EXPORT NSInteger const countOfAllowedLettersInTextView;

#pragma mark - Errors

FOUNDATION_EXPORT NSString *const musAppError_With_Domain_Universal_Sharing;
FOUNDATION_EXPORT NSString *const musAppError_Internet_Connection;
FOUNDATION_EXPORT NSString *const musAppError_Logged_Into_Social_Networks;


#pragma mark - MUSPhotoManager

FOUNDATION_EXPORT NSInteger const musAppCompressionSizePicture_By_Height;
FOUNDATION_EXPORT NSInteger const musAppCompressionSizePicture_By_Width;

FOUNDATION_EXPORT NSString *const musAppError_NO_Camera;
FOUNDATION_EXPORT NSInteger const musAppError_NO_Camera_Code;

FOUNDATION_EXPORT NSString *const musAppAlertTitle_Share_Photo;

#pragma mark MUSPhotoManager Constants

typedef void (^Complition)(id result, NSError *error);

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
FOUNDATION_EXPORT NSString *const Error;

#pragma mark - MUSGaleryView

FOUNDATION_EXPORT NSString *const loadNibNamed;
FOUNDATION_EXPORT NSString *const nibWithNibName;
FOUNDATION_EXPORT NSString *const titleAlertDeletePicShow;
FOUNDATION_EXPORT NSString *const messageAlertDeletePicShow;
FOUNDATION_EXPORT NSString *const cancelButtonTitleAlertDeletePicShow;
FOUNDATION_EXPORT NSString *const otherButtonTitlesAlertDeletePicShow;

#pragma mark - UIButton+MUSSocialNetwork

FOUNDATION_EXPORT NSString *const musAppButton_ImageName_UnknownUser;

#pragma mark - MUSPostCell

FOUNDATION_EXPORT NSString *const musAppImage_Name_Comment;
FOUNDATION_EXPORT NSString *const musAppImage_Name_Like;
FOUNDATION_EXPORT NSString *const musAppImage_Name_VKIconImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_FBIconImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterIconImage;

FOUNDATION_EXPORT NSString *const musAppFilter_Title_Shared;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Offline;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Error;


@end
