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

#pragma mark AccountsViewController Constants

NSString *const goToUserDetailViewControllerSegueIdentifier = @"goToInfo";

#pragma mark ShareViewController Constants

NSString *const MUSApp_SegueIdentifier_GoToDetailPostViewController = @"DetailPostViewController";

NSString *const MUSApp_TextView_PlaceholderText = @"Write something...";
NSString *const MUSApp_TextView_PlaceholderWhenStartEditingTextView = @"";
NSInteger const MUSApp_TextView_Twitter_NumberOfAllowedLetters = 117;

#pragma mark - MUSShareViewController

NSString *const MUSApp_MUSShareViewController_Alert_Message_No_Pics_Anymore = @"You can not add pictures anymore!";
NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedPics = 4;
NSInteger const MUSApp_MUSShareViewController_NumberOfAllowedLettersInTextView = 500;

#pragma mark - Errors

NSString *const MUSApp_Error_With_Domain_Universal_Sharing = @"Universal Sharing application";

#pragma mark - MUSPhotoManager

NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Height = 800;
NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Width = 800;

NSString *const MUSApp_MUSPhotoManager_Error_NO_Camera = @"Device has no camera";
NSInteger const MUSApp_MUSPhotoManager_Error_NO_Camera_Code = 1500;
NSString *const MUSApp_MUSPhotoManager_Alert_Title_Share_Photo = @"Share photo";



#pragma mark MUSAccountViewController Constants

NSString *const MUSApp_Button_Title_Edit = @"Edit";
NSString *const MUSApp_Button_Title_Done = @"Done";
NSString *const MUSApp_Button_Title_Show = @"Show";
NSString *const MUSApp_Button_Title_Hide = @"Hide";

#pragma mark - General constants
NSString *const MUSApp_Button_Title_Cancel = @"Cancel";
NSString *const MUSApp_Button_Title_OK = @"Ok";
NSString *const MUSApp_Button_Title_Album = @"Album";
NSString *const MUSApp_Button_Title_Camera = @"Camera";
NSString *const MUSApp_Button_Title_Share = @"Share";
NSString *const MUSApp_Button_Title_NO = @"NO";
NSString *const MUSApp_Button_Title_YES = @"YES";


//NSString *const Error = @"Error";

NSString *const notificationImagePickerForCollection = @"notificationImagePickerForCollection";
NSString *const notificationUpdateCollection = @"notificationUpdateCollection";


#pragma mark - MUSGaleryView
NSString *const MUSApp_MUSGaleryView_NibName = @"MUSGaleryView";
NSString *const MUSApp_MUSGaleryView_Alert_Title_DeletePic = @"Photo";
NSString *const MUSApp_MUSGaleryView_Alert_Message_DeletePic = @"Do you want to delete a picture?";

#pragma mark - MUSPostsViewController

NSString *const MUSApp_MUSPostsViewController_NavigationBar_Title = @"Shared Posts";

#pragma mark - MUSPostCell

NSString *const MUSApp_Image_Name_VKIconImage_grey = @"VK_icon_grey.png";
NSString *const MUSApp_Image_Name_FBIconImage_grey = @"Facebook_Icon_grey.png";
NSString *const MUSApp_Image_Name_TwitterIconImage_grey = @"Twitter_icon_grey.png";
NSString *const MUSApp_Image_Name_VKLikeImage_grey = @"VK_Likes_grey.png";
NSString *const MUSApp_Image_Name_FBLikeImage_grey = @"Facebook_Like_grey.png";
NSString *const MUSApp_Image_Name_TwitterLikeImage_grey = @"Twitter_Like_grey.png";
NSString *const MUSApp_Image_Name_TwitterCommentsImage_grey = @"Twitter_Comment_grey.png";
NSString *const MUSApp_Image_Name_CommentsImage_grey = @"Comments_grey.png";
NSString *const MUSApp_Image_Name_AddPhoto = @"camera25.png";


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

#pragma mark - MUSPostLocationCell

NSInteger const MUSApp_MUSPostLocationCell_HeightOfCell = 200;


@end
