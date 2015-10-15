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

typedef NS_ENUM(NSInteger, AlertButtonIndex) {
    Cancel,
    Album,
    Camera,
    Remove,
};


typedef NS_ENUM(NSInteger, DetailPostVC_CellType) {
    PostDescriptionCellType,
    CommentsAndLikesCellType,
    PostLocationCellType,
};

typedef void (^ProgressLoadingImagesToVK)(int objectOfLoading, long long bytesLoaded, long long bytesTotal);

typedef void (^Complition)(id result, NSError *error);

#pragma mark SegueIdentifier

FOUNDATION_EXPORT NSString *const MUSApp_SegueIdentifier_GoToUserDetailViewController;
FOUNDATION_EXPORT NSString *const MUSApp_SegueIdentifier_GoToDetailPostViewController;
FOUNDATION_EXPORT NSString *const MUSApp_SegueIdentifier_GoToMediaGalleryViewController;


#pragma mark TextView

FOUNDATION_EXPORT NSString *const MUSApp_TextView_PlaceholderText;
FOUNDATION_EXPORT NSString *const MUSApp_TextView_PlaceholderWhenStartEditingTextView;
FOUNDATION_EXPORT NSInteger const MUSApp_TextView_Twitter_NumberOfAllowedLetters;

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

#pragma mark - UIButton

FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Cancel;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_OK;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Album;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Camera;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Share;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_NO;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_YES;
FOUNDATION_EXPORT NSString *const MUSApp_Button_Title_Logout;

#pragma mark - Errors

FOUNDATION_EXPORT NSString *const MUSApp_Error_With_Domain_Universal_Sharing;

#pragma mark - Color

#define BROWN_COLOR_WITH_ALPHA_01 [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.1]
#define BROWN_COLOR_WITH_ALPHA_025 [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.25]
#define BROWN_COLOR_WITH_ALPHA_05 [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 0.5]
#define BROWN_COLOR [UIColor colorWithRed: 199.0/255.0 green: 176.0/255.0 blue: 163.0/255.0 alpha: 1.0]
#define DARK_BROWN_COLOR_WITH_ALPHA_07 [UIColor colorWithRed: 155.0/255.0 green: 101.0/255.0 blue: 79.0/255.0 alpha: 0.7]
#define DARK_BROWN_COLOR [UIColor colorWithRed: 155.0/255.0 green: 101.0/255.0 blue: 79.0/255.0 alpha: 1.0]

#pragma mark - MUSShareViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSShareViewController_Alert_Message_No_Pics_Anymore;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedPics;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedLettersInTextView;

#pragma mark - MUSPhotoManager

FOUNDATION_EXPORT NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Height;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Width;

FOUNDATION_EXPORT NSString *const MUSApp_MUSPhotoManager_Error_NO_Camera;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSPhotoManager_Error_NO_Camera_Code;

FOUNDATION_EXPORT NSString *const MUSApp_MUSPhotoManager_Alert_Title_Share_Photo;


#pragma mark - Notifications

FOUNDATION_EXPORT NSString *const MUSShowImagePickerForAddImageInCollectionView;
FOUNDATION_EXPORT NSString *const MUSUpdateCollectionViewNotification;

#pragma mark - MUSGaleryView

FOUNDATION_EXPORT NSString *const MUSApp_MUSGaleryView_NibName;
FOUNDATION_EXPORT NSString *const MUSApp_MUSGaleryView_Alert_Title_DeletePic;
FOUNDATION_EXPORT NSString *const MUSApp_MUSGaleryView_Alert_Message_DeletePic;

#pragma mark - MUSPostsViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSPostsViewController_NavigationBar_Title;

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
FOUNDATION_EXPORT CGFloat const MUSApp_MUSDetailPostViewController_HeightOfHeader;

#pragma mark - MUSPostLocationCell

FOUNDATION_EXPORT NSInteger const MUSApp_MUSPostLocationCell_HeightOfCell;
FOUNDATION_EXPORT double const MUSApp_MUSPostLocationCell_CLLocationDistance;
FOUNDATION_EXPORT NSString *const MUSApp_MUSPostLocationCell_StringNull;

#pragma mark - MUSUserDetailViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSUserDetailViewController_User_Profile;
FOUNDATION_EXPORT NSString *const MUSApp_MUSUserDetailViewController_User_ClientID;

#pragma mark - MUSProgressBar

FOUNDATION_EXPORT NSString *const MUSApp_MUSProgressBar_NibName;
FOUNDATION_EXPORT NSString *const MUSApp_MUSProgressBarEndLoading_NibName;
FOUNDATION_EXPORT NSString *const MUSApp_MUSProgressBarEndLoading_Label_Title_Published;
FOUNDATION_EXPORT NSString *const MUSApp_MUSProgressBarEndLoading_Label_Title_Failed;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSProgressBar_DefaultValueProgress;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSProgressBar_ValueProgress;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSProgressBar_View_DefaultHeightConstraint;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSProgressBar_View_HeightConstraint;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSProgressBar_Label_DefaultWidthConstraint;
FOUNDATION_EXPORT NSInteger const MUSApp_MUSProgressBar_Label_WidthConstraint;

#pragma mark - MUSToolBarForMediaGalleryViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSToolBarForMediaGalleryViewController_NibName;

#pragma mark - MUSTopBarForMediaGalleryViewController

FOUNDATION_EXPORT NSString *const MUSApp_MUSTopBarForMediaGalleryViewController_NibName;

#pragma mark - MUSDeleteButton

FOUNDATION_EXPORT NSString *const MUSApp_MUSDeleteButton_Image_Name;

#pragma mark - ReachabilityManager

FOUNDATION_EXPORT NSString *const MUSApp_ReachabilityManager_Host_Name;

#pragma mark - MUSLocationManager

FOUNDATION_EXPORT NSString *const MUSApp_MUSLocationManager_Address_Unknown;

#pragma mark - AppDelegate

FOUNDATION_EXPORT NSString *const MUSApp_AppDelegate_Url_Facebook;
FOUNDATION_EXPORT NSString *const MUSApp_AppDelegate_Url_Vk;

@end
