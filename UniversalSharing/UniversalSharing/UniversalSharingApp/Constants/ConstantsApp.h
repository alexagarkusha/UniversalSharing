//
//  Constants.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

typedef NS_ENUM(NSInteger, DetailPostVC_CellType) {
    GalleryOfPhotosCellType,
    CommentsAndLikesCellType,
    PostDescriptionCellType,
    PostLocationCellType,
};



#pragma mark AccountsViewController Constants

FOUNDATION_EXPORT NSString *const goToUserDetailViewControllerSegueIdentifier;

#pragma mark MUSShareViewController Constants

FOUNDATION_EXPORT NSString *const kPlaceholderText;
FOUNDATION_EXPORT NSString *const goToLocationViewControllerSegueIdentifier;
FOUNDATION_EXPORT NSString *const goToDetailPostViewControllerSegueIdentifier;
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
FOUNDATION_EXPORT NSInteger const musApp_TextView_CountOfAllowedLetters_ForTwitter;


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

#define YELLOW_COLOR_Slightly [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 240.0/255.0 alpha: 1.0]
#define YELLOW_COLOR_Light [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 220.0/255.0 alpha: 1.0]
#define YELLOW_COLOR_MidLight [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 190.0/255.0 alpha: 1.0]
#define YELLOW_COLOR_UpperMid [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 100.0/255.0 alpha: 1.0]

FOUNDATION_EXPORT NSString *const musAppButtonTitle_Cancel;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_OK;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Album;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Camera;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Edit;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Share;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Action;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Back;
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


#pragma mark - MUSPostsViewController

FOUNDATION_EXPORT NSString *const musApp_PostsViewController_NavigationBar_Title;
FOUNDATION_EXPORT NSString *const musApp_PostsViewController_AllShareReasons;
FOUNDATION_EXPORT NSString *const musApp_PostsViewController_AllSocialNetworks;

#pragma mark - MUSPostCell

FOUNDATION_EXPORT NSString *const musAppImage_Name_Comment;
FOUNDATION_EXPORT NSString *const musAppImage_Name_Like;
FOUNDATION_EXPORT NSString *const musAppImage_Name_VKIconImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_FBIconImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterIconImage;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Shared;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Offline;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Error;
FOUNDATION_EXPORT NSInteger const musAppPostsVC_HeightOfPostCell;
FOUNDATION_EXPORT NSString *const musApp_ActionSheet_Title_ChooseAction;
FOUNDATION_EXPORT NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
FOUNDATION_EXPORT NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;

#pragma mark - MUSGalleryViewOfPhotos

FOUNDATION_EXPORT NSString *const musApp_GalleryOfPhotos_NibName;

#pragma mark - MUSGalleryOfPhotosCell

FOUNDATION_EXPORT NSString *const musAppButton_ImageName_ButtonAdd;
FOUNDATION_EXPORT NSInteger const musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithoutPhotos;
FOUNDATION_EXPORT NSInteger const musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithPhotos;

#pragma mark - MUSPostDescriptionCell

FOUNDATION_EXPORT NSInteger const musApp_PostDescriptionCell_TextView_TopConstraint;
FOUNDATION_EXPORT NSInteger const musApp_PostDescriptionCell_TextView_BottomConstraint;
FOUNDATION_EXPORT NSInteger const musApp_PostDescriptionCell_TextView_LeftConstraint;
FOUNDATION_EXPORT NSInteger const musApp_PostDescriptionCell_TextView_RightConstraint;

FOUNDATION_EXPORT NSString *const musApp_PostDescriptionCell_TextView_Font_Name;
FOUNDATION_EXPORT NSInteger const musApp_PostDescriptionCell_TextView_Font_Size;


#pragma mark - MUSDetailPostViewController

FOUNDATION_EXPORT NSInteger const musAppDetailPostVC_HeightOfCommentsAndLikesCell;
FOUNDATION_EXPORT NSInteger const musAppDetailPostVC_HeightOfPostLocationCell;
FOUNDATION_EXPORT NSInteger const musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithoutPhotos;
FOUNDATION_EXPORT NSInteger const musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos;
FOUNDATION_EXPORT NSString *const musAppDetailPostVC_UpdatePostAlert;




@end
