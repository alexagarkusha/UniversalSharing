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

NSString *const kPlaceholderText = @"Write something...";
NSString *const goToLocationViewControllerSegueIdentifier = @"Location";
NSString *const goToDetailPostViewControllerSegueIdentifier = @"DetailPostViewController";
NSString *const collectionViewCellIdentifier = @"CollectionViewCellIdentifier";
NSString *const distanceEqual100 = @"100";
NSString *const distanceEqual1000 = @"1000";
NSString *const distanceEqual25000 = @"25000";
NSString *const titleActionSheet = @"Select account";
NSString *const musAppAlertTitle_NO_Pics_Anymore = @"You can not add pics anymore :[";
NSString *const titleCongratulatoryAlert = @"UniversalSharing congratulates You shared your POST";
NSString *const changePlaceholderWhenStartEditing = @"";

//===
NSInteger const countOfAllowedPics = 4;
NSInteger const countOfAllowedLettersInTextView = 500;
NSInteger const musApp_TextView_CountOfAllowedLetters_ForTwitter = 117;
NSInteger const musApp_TextView_CountOfAllowedLetters_ForTwitterWithoutPhoto = 140;


#pragma mark - Errors

NSString *const musAppError_With_Domain_Universal_Sharing = @"Universal Sharing application";
NSString *const musAppError_Internet_Connection = @"Please check your internet connection or try again later";
NSString *const musAppError_Logged_Into_Social_Networks = @"You are not logged into any of social networks";
NSString *const musAppError_Internet_Connection_Location = @"Could not find any locations. Check the Internet connection settings";
NSString *const musAppError_Empty_Post = @"This post could not be sent because it does not contain any information.";


#pragma mark - MUSPhotoManager

NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Height = 800;
NSInteger const MUSApp_MUSPhotoManager_CompressionSizePicture_By_Width = 800;

NSString *const MUSApp_MUSPhotoManager_Error_NO_Camera = @"Device has no camera";
NSInteger const MUSApp_MUSPhotoManager_Error_NO_Camera_Code = 1500;
NSString *const MUSApp_MUSPhotoManager_Alert_Title_Share_Photo = @"Share photo";



#pragma mark MUSAccountViewController Constants

#warning NEED TO DELETE CONSTANTS

NSString *const editButtonTitle = @"Edit";
NSString *const doneButtonTitle = @"Done";
NSString *const showButtonTitle = @"Show";
NSString *const hideButtonTitle = @"Hide";

NSString *const MUSApp_Button_Title_Edit = @"Edit";
NSString *const MUSApp_Button_Title_Done = @"Done";
NSString *const MUSApp_Button_Title_Show = @"Show";
NSString *const MUSApp_Button_Title_Hide = @"Hide";

#pragma mark - General constants
NSString *const notificationImagePickerForCollection = @"notificationImagePickerForCollection";
NSString *const notificationUpdateCollection = @"notificationUpdateCollection";
NSString *const musAppButtonTitle_Cancel = @"Cancel";
NSString *const musAppButtonTitle_OK = @"Ok";
NSString *const musAppButtonTitle_Album = @"Album";
NSString *const musAppButtonTitle_Camera = @"Camera";
NSString *const musAppButtonTitle_Edit = @"Edit";
NSString *const musAppButtonTitle_Share = @"Share";
NSString *const musAppButtonTitle_Action = @"Action";
NSString *const musAppButtonTitle_Back = @"Back";
NSString *const musAppButtonTitle_ShareLocation =  @"Share Location";
NSString *const Error = @"Error";

#pragma mark - MUSGaleryView
NSString *const loadNibNamed = @"MUSGaleryView";
NSString *const nibWithNibName = @"MUSCollectionViewCell";
NSString *const titleAlertDeletePicShow = @"Photo";
NSString *const messageAlertDeletePicShow = @"You want to delete a pic";
NSString *const cancelButtonTitleAlertDeletePicShow = @"NO";
NSString *const otherButtonTitlesAlertDeletePicShow = @"YES";

#pragma mark - UIButton+MUSSocial

NSString *const musAppButton_ImageName_UnknownUser = @"UnknownUser.jpg";

#pragma mark - MUSPostsViewController

NSString *const musApp_PostsViewController_NavigationBar_Title = @"Shared Posts";

#pragma mark - MUSPostCell

NSString *const musAppImage_Name_VKIconImage = @"VK_icon.png";
NSString *const musAppImage_Name_FBIconImage = @"Facebook_Icon.png";
NSString *const musAppImage_Name_TwitterIconImage = @"Twitter_icon.png";

NSString *const musAppImage_Name_VKLikeImage = @"VK_Likes.png";
NSString *const musAppImage_Name_FBLikeImage = @"Facebook_Like.png";
NSString *const musAppImage_Name_TwitterLikeImage = @"Twitter_Like.png";
NSString *const musAppImage_Name_TwitterCommentsImage = @"Twitter_Comment.png";
NSString *const musAppImage_Name_CommentsImage = @"Comments.png";

NSString *const musAppImage_Name_VKIconImage_grey = @"VK_icon_grey.png";
NSString *const musAppImage_Name_FBIconImage_grey = @"Facebook_Icon_grey.png";
NSString *const musAppImage_Name_TwitterIconImage_grey = @"Twitter_icon_grey.png";

NSString *const musAppImage_Name_VKLikeImage_grey = @"VK_Likes_grey.png";
NSString *const musAppImage_Name_FBLikeImage_grey = @"Facebook_Like_grey.png";
NSString *const musAppImage_Name_TwitterLikeImage_grey = @"Twitter_Like_grey.png";
NSString *const musAppImage_Name_TwitterCommentsImage_grey = @"Twitter_Comment_grey.png";
NSString *const musAppImage_Name_CommentsImage_grey = @"Comments_grey.png";

NSInteger const musAppPostsVC_HeightOfPostCell = 96;
NSString *const musApp_ActionSheet_Title_ChooseAction = @"Choose action";
NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos = 12;
NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos = 90;

#pragma mark - MUSReasonCommentsAndLikesCell

NSInteger const musAppCommentsAndLikesCell_HeightOfRow = 31;

#pragma mark - MUSGalleryViewOfPhotos

NSString *const musApp_GalleryOfPhotos_NibName = @"MUSGalleryViewOfPhotos";
NSString *const notificationShowImagesInCollectionView = @"notificationShowImagesInCollectionView";

#pragma mark - MUSGalleryOfPhotosCell

NSString *const musAppButton_ImageName_ButtonAdd = @"Button_Add.png";
NSString *const musAppButton_ImageName_AddPhoto = @"camera25.png";
NSInteger const musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithoutPhotos = -4;
NSInteger const musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithPhotos = 50;

#pragma mark - MUSPostDescriptionCell

NSInteger const musApp_PostDescriptionCell_TextView_TopConstraint = 8;
NSInteger const musApp_PostDescriptionCell_TextView_BottomConstraint = 8;
NSInteger const musApp_PostDescriptionCell_TextView_LeftConstraint = 8;
NSInteger const musApp_PostDescriptionCell_TextView_RightConstraint = 8;

NSString *const musApp_PostDescriptionCell_TextView_Font_Name = @"Times New Roman";
NSInteger const musApp_PostDescriptionCell_TextView_Font_Size = 20;


#pragma mark - MUSDetailPostViewController

NSInteger const musAppDetailPostVC_HeightOfCommentsAndLikesCell = 95;
NSInteger const musAppDetailPostVC_HeightOfPostLocationCell = 200;
NSInteger const musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithoutPhotos = 70;
NSInteger const musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos = 150;
NSString *const musAppDetailPostVC_UpdatePostAlert = @"Do you want to update your Post?";
NSInteger const musAppDetailPostVC_NumberOfRows = 3;



@end
