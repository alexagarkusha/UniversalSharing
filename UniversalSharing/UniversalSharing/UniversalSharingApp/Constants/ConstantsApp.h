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

FOUNDATION_EXPORT NSString *const MUSApp_SegueIdentifier_GoToDetailPostViewController;


FOUNDATION_EXPORT NSString *const MUSApp_TextView_PlaceholderText;
FOUNDATION_EXPORT NSString *const MUSApp_TextView_PlaceholderWhenStartEditingTextView;
FOUNDATION_EXPORT NSInteger const MUSApp_TextView_Twitter_NumberOfAllowedLetters;

#pragma mark - MUSShareViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSShareViewController_Alert_Message_No_Pics_Anymore;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedPics;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedLettersInTextView;

#pragma mark - Errors

FOUNDATION_EXPORT NSString *const MUSApp_Error_With_Domain_Universal_Sharing;

#pragma mark - MUSPhotoManager

FOUNDATION_EXPORT NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Height;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Width;

FOUNDATION_EXPORT NSString *const MUSApp_MUSPhotoManager_Error_NO_Camera;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPhotoManager_Error_NO_Camera_Code;

FOUNDATION_EXPORT NSString *const MUSApp_MUSPhotoManager_Alert_Title_Share_Photo;

typedef void (^Complition)(id result, NSError *error);

#pragma mark MUSAccountViewController Constants

#warning NEED TO DELETE CONSTANTS

FOUNDATION_EXPORT NSString *const editButtonTitle;
FOUNDATION_EXPORT NSString *const doneButtonTitle;
FOUNDATION_EXPORT NSString *const showButtonTitle;
FOUNDATION_EXPORT NSString *const hideButtonTitle;

FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Edit;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Done;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Show;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Hide;

#pragma mark - General constants

#define BROWN_COLOR_WITH_ALPHA_01 [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.1]
#define BROWN_COLOR_WITH_ALPHA_025 [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.25]
#define BROWN_COLOR_WITH_ALPHA_05 [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.5]
#define BROWN_COLOR [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 1.0]
#define DARK_BROWN_COLOR_WITH_ALPHA_07 [UIColor colorWithRed: 155.0/255.0 green: 101.0/255.0 blue: 79.0/255.0 alpha: 0.7]
#define DARK_BROWN_COLOR [UIColor colorWithRed: 155.0/255.0 green: 101.0/255.0 blue: 79.0/255.0 alpha: 1.0]

FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Cancel;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_OK;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Album;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Camera;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Share;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_NO;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_YES;

//FOUNDATION_EXPORT NSString *const Error;


#warning NEED TO DELETE THIS NOTIFICATIONS AND NEED TO CHANGE LOGIC IN SHARESCREEN AND COLLECTIONVC
FOUNDATION_EXPORT NSString *const notificationUpdateCollection;
FOUNDATION_EXPORT NSString *const notificationImagePickerForCollection;


#pragma mark - MUSGaleryView

FOUNDATION_EXPORT NSString *const MUSApp_MUSGaleryView_NibName;
FOUNDATION_EXPORT NSString *const MUSApp_MUSGaleryView_Alert_Title_DeletePic;
FOUNDATION_EXPORT NSString *const MUSApp_MUSGaleryView_Alert_Message_DeletePic;

#pragma mark - MUSPostsViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSPostsViewController_NavigationBar_Title;

#pragma mark - UIImage+SocialNetworkIcons

FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_VKIconImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_FBIconImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_TwitterIconImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_VKLikeImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_FBLikeImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_TwitterLikeImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_TwitterCommentsImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_CommentsImage_grey;
FOUNDATION_EXPORT NSString *const MUSApp_Image_Name_AddPhoto;


#pragma mark - MUSPostCell

FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostCell_HeightOfCell;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;

#pragma mark - MUSReasonCommentsAndLikesCell

FOUNDATION_EXPORT NSInteger const MUSApp_ReasonCommentsAndLikesCell_HeightOfRow;

#pragma mark - MUSPostDescriptionCell

FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostDescriptionCell_TextView_TopConstraint;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostDescriptionCell_TextView_BottomConstraint;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostDescriptionCell_TextView_LeftConstraint;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostDescriptionCell_TextView_RightConstraint;
FOUNDATION_EXPORT NSString *const MUSApp_MUSPostDescriptionCell_TextView_Font_Name;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostDescriptionCell_TextView_Font_Size;


#pragma mark - MUSDetailPostViewController
FOUNDATION_EXPORT NSInteger const MUSApp_MUSDetailPostViewController_NumberOfRowsInTableView;

#pragma mark - MUSPostLocationCell
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostLocationCell_HeightOfCell;


@end
