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
    //GalleryOfPhotosCellType,
    PostDescriptionCellType,
    CommentsAndLikesCellType,
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
FOUNDATION_EXPORT NSInteger const musApp_TextView_CountOfAllowedLetters_ForTwitterWithoutPhoto;


#pragma mark - Errors

FOUNDATION_EXPORT NSString *const musAppError_With_Domain_Universal_Sharing;
FOUNDATION_EXPORT NSString *const musAppError_Internet_Connection;
FOUNDATION_EXPORT NSString *const musAppError_Logged_Into_Social_Networks;
FOUNDATION_EXPORT NSString *const musAppError_Internet_Connection_Location;
FOUNDATION_EXPORT NSString *const musAppError_Empty_Post;

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

#define BROWN_COLOR_Lightly [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.1]
#define BROWN_COLOR_Light [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.25]
#define BROWN_COLOR_LightMID [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.5]
#define BROWN_COLOR_LightHIGHT [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 1.0]

#define BROWN_COLOR_MIDLight [UIColor colorWithRed: 155.0/255.0 green: 101.0/255.0 blue: 79.0/255.0 alpha: 0.7]
#define BROWN_COLOR_MIDLightHIGHT [UIColor colorWithRed: 155.0/255.0 green: 101.0/255.0 blue: 79.0/255.0 alpha: 1.0]


//#define YELLOW_COLOR_Light [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 220.0/255.0 alpha: 1.0]
//#define YELLOW_COLOR_MidLight [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 190.0/255.0 alpha: 1.0]
//#define YELLOW_COLOR_UpperMid [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 100.0/255.0 alpha: 1.0]
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Cancel;
FOUNDATION_EXPORT NSString *const notificationUpdateCollection;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_OK;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Album;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Camera;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Edit;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Share;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Action;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_Back;
FOUNDATION_EXPORT NSString *const musAppButtonTitle_ShareLocation;
FOUNDATION_EXPORT NSString *const Error;
FOUNDATION_EXPORT NSString *const notificationImagePickerForCollection;


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
FOUNDATION_EXPORT NSInteger const musApp_DropDownMenu_Height;

#pragma mark - MUSPostCell

//FOUNDATION_EXPORT NSString *const musAppImage_Name_Comment;
//FOUNDATION_EXPORT NSString *const musAppImage_Name_Like;
FOUNDATION_EXPORT NSString *const musAppImage_Name_VKIconImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_FBIconImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterIconImage;

FOUNDATION_EXPORT NSString *const musAppImage_Name_VKLikeImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_FBLikeImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterLikeImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterCommentsImage;
FOUNDATION_EXPORT NSString *const musAppImage_Name_CommentsImage;


FOUNDATION_EXPORT NSString *const musAppImage_Name_VKIconImage_grey;
FOUNDATION_EXPORT NSString *const musAppImage_Name_FBIconImage_grey;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterIconImage_grey;

FOUNDATION_EXPORT NSString *const musAppImage_Name_VKLikeImage_grey;
FOUNDATION_EXPORT NSString *const musAppImage_Name_FBLikeImage_grey;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterLikeImage_grey;
FOUNDATION_EXPORT NSString *const musAppImage_Name_TwitterCommentsImage_grey;
FOUNDATION_EXPORT NSString *const musAppImage_Name_CommentsImage_grey;


FOUNDATION_EXPORT NSString *const musAppFilter_Title_Shared;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Offline;
FOUNDATION_EXPORT NSString *const musAppFilter_Title_Error;
FOUNDATION_EXPORT NSInteger const musAppPostsVC_HeightOfPostCell;
FOUNDATION_EXPORT NSString *const musApp_ActionSheet_Title_ChooseAction;
FOUNDATION_EXPORT NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
FOUNDATION_EXPORT NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
FOUNDATION_EXPORT NSString *const musApp_PostCell_Image_Name_CheckMarkTaken;
FOUNDATION_EXPORT NSString *const musApp_PostCell_Image_Name_CheckMark;

#pragma mark - MUSReasonCommentsAndLikesCell

FOUNDATION_EXPORT NSInteger const musAppCommentsAndLikesCell_HeightOfRow;

#pragma mark - MUSGalleryViewOfPhotos

FOUNDATION_EXPORT NSString *const musApp_GalleryOfPhotos_NibName;
FOUNDATION_EXPORT NSString *const notificationShowImagesInCollectionView;

#pragma mark - MUSGalleryOfPhotosCell

FOUNDATION_EXPORT NSString *const musAppButton_ImageName_ButtonAdd;
FOUNDATION_EXPORT NSString *const musAppButton_ImageName_AddPhoto;

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
FOUNDATION_EXPORT NSInteger const musAppDetailPostVC_NumberOfRows;

#pragma mark - MUSCustomMapView

FOUNDATION_EXPORT NSInteger const musAppCustomMapView_maxZoomDistance;
FOUNDATION_EXPORT NSString *const musAppButton_ImageName_ButtonDeleteLocation;
FOUNDATION_EXPORT NSString *const musAppCustomMapView_PinAnnotationViewIdentifier;

#pragma mark - MUSLocationCell

FOUNDATION_EXPORT NSInteger const musAppLocationCell_LeftConstraintOfLabel;
FOUNDATION_EXPORT NSInteger const musAppLocationCell_RightConstraintOfLabel;
FOUNDATION_EXPORT NSInteger const musAppLocationCell_RightConstraintOfLabelWithDeletePlaceButton;

@end
