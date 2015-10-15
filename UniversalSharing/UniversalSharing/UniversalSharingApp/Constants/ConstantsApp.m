//
//  Constants.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "ConstantsApp.h"
#import "MUSSocialNetworkLibraryHeader.h"

@implementation ConstantsApp

#pragma mark SegueIdentifier

NSString *const MUSApp_SegueIdentifier_GoToUserDetailViewController = @"goToInfo";
NSString *const MUSApp_SegueIdentifier_GoToDetailPostViewController = @"DetailPostViewController";
NSString *const MUSApp_SegueIdentifier_GoToMediaGalleryViewController = @"goToDitailPostCollectionViewController";

#pragma mark TextView

NSString *const MUSApp_TextView_PlaceholderText = @"Write something...";
NSString *const MUSApp_TextView_PlaceholderWhenStartEditingTextView = @"";
NSInteger const MUSApp_TextView_Twitter_NumberOfAllowedLetters = 117;

#pragma mark - UIImage+SocialNetworkIcons

NSString *const MUSApp_Image_Name_VKIconImage_grey = @"VK_icon_grey.png";
NSString *const MUSApp_Image_Name_FBIconImage_grey = @"Facebook_Icon_grey.png";
NSString *const MUSApp_Image_Name_TwitterIconImage_grey = @"Twitter_icon_grey.png";
NSString *const MUSApp_Image_Name_VKLikeImage_grey = @"VK_Likes_grey.png";
NSString *const MUSApp_Image_Name_FBLikeImage_grey = @"Facebook_Like_grey.png";
NSString *const MUSApp_Image_Name_TwitterLikeImage_grey = @"Twitter_Like_grey.png";
NSString *const MUSApp_Image_Name_TwitterCommentsImage_grey = @"Twitter_Comment_grey.png";
NSString *const MUSApp_Image_Name_CommentsImage_grey = @"Comments_grey.png";
NSString *const MUSApp_Image_Name_AddPhoto = @"camera25.png";

#pragma mark - UIButton

NSString *const MUSApp_Button_Title_Cancel = @"Cancel";
NSString *const MUSApp_Button_Title_OK = @"Ok";
NSString *const MUSApp_Button_Title_Album = @"Album";
NSString *const MUSApp_Button_Title_Camera = @"Camera";
NSString *const MUSApp_Button_Title_Share = @"Share";
NSString *const MUSApp_Button_Title_NO = @"NO";
NSString *const MUSApp_Button_Title_YES = @"YES";
NSString *const MUSApp_Button_Title_Logout = @"Logout";


#pragma mark - Errors

NSString *const MUSApp_Error_With_Domain_Universal_Sharing = @"Universal Sharing application";

#pragma mark - MUSShareViewController

NSString *const MUSApp_MUSShareViewController_Alert_Message_No_Pics_Anymore = @"You can not add pictures anymore!";
NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedPics = 4;
NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedLettersInTextView = 500;

#pragma mark - MUSPhotoManager

NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Height = 800;
NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Width = 800;

NSString *const MUSApp_MUSPhotoManager_Error_NO_Camera = @"Device has no camera";
NSInteger const MUSApp_MUSPhotoManager_Error_NO_Camera_Code = 1500;
NSString *const MUSApp_MUSPhotoManager_Alert_Title_Share_Photo = @"Share photo";

#warning NEED TO DELETE THIS NOTIFICATIONS AND NEED TO CHANGE LOGIC IN SHARESCREEN AND COLLECTIONVC

NSString *const notificationImagePickerForCollection = @"notificationImagePickerForCollection";
NSString *const notificationUpdateCollection = @"notificationUpdateCollection";

#pragma mark - MUSGaleryView

NSString *const MUSApp_MUSGaleryView_NibName = @"MUSGaleryView";
NSString *const MUSApp_MUSGaleryView_Alert_Title_DeletePic = @"Photo";
NSString *const MUSApp_MUSGaleryView_Alert_Message_DeletePic = @"Do you want to delete a picture?";

#pragma mark - MUSPostsViewController

NSString *const MUSApp_MUSPostsViewController_NavigationBar_Title = @"Shared Posts";

#pragma mark - MUSPostCell

NSInteger const MUSApp_MUSPostCell_HeightOfCell = 96;
NSInteger const MUSApp_MUSPostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos = 12;
NSInteger const MUSApp_MUSPostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos = 90;

#pragma mark - MUSReasonCommentsAndLikesCell

NSInteger const MUSApp_ReasonCommentsAndLikesCell_HeightOfRow = 31;

#pragma mark - MUSPostDescriptionCell

NSInteger const MUSApp_MUSPostDescriptionCell_TextView_TopConstraint = 8;
NSInteger const MUSApp_MUSPostDescriptionCell_TextView_BottomConstraint = 8;
NSInteger const MUSApp_MUSPostDescriptionCell_TextView_LeftConstraint = 8;
NSInteger const MUSApp_MUSPostDescriptionCell_TextView_RightConstraint = 8;
NSString *const MUSApp_MUSPostDescriptionCell_TextView_Font_Name = @"Times New Roman";
NSInteger const MUSApp_MUSPostDescriptionCell_TextView_Font_Size = 20;

#pragma mark - MUSDetailPostViewController

NSInteger const MUSApp_MUSDetailPostViewController_NumberOfRowsInTableView = 3;
CGFloat const MUSApp_MUSDetailPostViewController_HeightOfHeader = 250.0f;

#pragma mark - MUSPostLocationCell

NSInteger const MUSApp_MUSPostLocationCell_HeightOfCell = 200;
double const MUSApp_MUSPostLocationCell_CLLocationDistance = 500;
NSString *const MUSApp_MUSPostLocationCell_StringNull = @"(null)";

#pragma mark - MUSUserDetailViewController

NSString *const MUSApp_MUSUserDetailViewController_User_Profile = @"profile";
NSString *const MUSApp_MUSUserDetailViewController_User_ClientID = @"clientID";

#pragma mark - MUSProgressBar

NSString *const MUSApp_MUSProgressBar_NibName = @"MUSProgressBar";
NSString *const MUSApp_MUSProgressBarEndLoading_NibName = @"MUSProgressBarEndLoading";
NSString *const MUSApp_MUSProgressBarEndLoading_Label_Title_Published = @"Published";
NSString *const MUSApp_MUSProgressBarEndLoading_Label_Title_Failed = @"Failed";
NSInteger const MUSApp_MUSProgressBar_DefaultValueProgress = 0;
NSInteger const MUSApp_MUSProgressBar_ValueProgress = 1;
NSInteger const MUSApp_MUSProgressBar_View_DefaultHeightConstraint = 0;
NSInteger const MUSApp_MUSProgressBar_View_HeightConstraint = 42;
NSInteger const MUSApp_MUSProgressBar_Label_DefaultWidthConstraint = 50;
NSInteger const MUSApp_MUSProgressBar_Label_WidthConstraint = 8;

#pragma mark - MUSToolBarForMediaGalleryViewController

NSString *const MUSApp_MUSToolBarForMediaGalleryViewController_NibName = @"MUSToolBarForMediaGalleryViewController";

#pragma mark - MUSTopBarForMediaGalleryViewController

NSString *const MUSApp_MUSTopBarForMediaGalleryViewController_NibName = @"MUSTopBarForMediaGalleryViewController";

#pragma mark - MUSDeleteButton

NSString *const MUSApp_MUSDeleteButton_Image_Name = @"Button_Delete.png";

#pragma mark - ReachabilityManager

NSString *const MUSApp_ReachabilityManager_Host_Name = @"www.google.com";

#pragma mark - MUSLocationManager

NSString *const MUSApp_MUSLocationManager_Address_Unknown = @"Location is not defined";

@end
