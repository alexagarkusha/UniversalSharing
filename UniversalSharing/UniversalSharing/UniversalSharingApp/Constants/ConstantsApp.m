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
NSInteger const musApp_TextView_CountOfAllowedLetters_ForTwitter = 140;


#pragma mark - Errors

NSString *const musAppError_With_Domain_Universal_Sharing = @"Universal Sharing application";
NSString *const musAppError_Internet_Connection = @"Please check your internet connection or try again later";
NSString *const musAppError_Logged_Into_Social_Networks = @"You are not logged into any of social networks";
NSString *const musAppError_Internet_Connection_Location = @"Could not find any locations. Check the Internet connection settings";

#pragma mark - MUSPhotoManager

NSInteger const musAppCompressionSizePicture_By_Height = 800;
NSInteger const musAppCompressionSizePicture_By_Width = 800;

NSString *const musAppError_NO_Camera = @"Device has no camera";
NSInteger const musAppError_NO_Camera_Code = 1500;
NSString *const musAppAlertTitle_Share_Photo = @"Share photo";



#pragma mark MUSAccountViewController Constants

NSString *const editButtonTitle = @"Edit";
NSString *const doneButtonTitle = @"Done";
NSString *const showButtonTitle = @"Show";
NSString *const hideButtonTitle = @"Hide";

#pragma mark - General constants
NSString *const notificationUpdateCollection = @"notificationUpdateCollection";
NSString *const musAppButtonTitle_Cancel = @"Cancel";
NSString *const musAppButtonTitle_OK = @"Ok";
NSString *const musAppButtonTitle_Album = @"Album";
NSString *const musAppButtonTitle_Camera = @"Camera";
NSString *const musAppButtonTitle_Edit = @"Edit";
NSString *const musAppButtonTitle_Share = @"Share";
NSString *const musAppButtonTitle_Action = @"Action";
NSString *const musAppButtonTitle_Back = @"Back";

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
NSString *const musApp_PostsViewController_AllShareReasons = @"Status";
NSString *const musApp_PostsViewController_AllSocialNetworks = @"All";
NSInteger const musApp_DropDownMenu_Height = 40;


#pragma mark - MUSPostCell

NSString *const musAppImage_Name_Comment = @"Comment.png";
NSString *const musAppImage_Name_Like = @"Like.png";
NSString *const musAppImage_Name_VKIconImage = @"VKimage.png";
NSString *const musAppImage_Name_FBIconImage = @"FBimage.jpg";
NSString *const musAppImage_Name_TwitterIconImage = @"TWimage.jpeg";


NSString *const musAppFilter_Title_Shared = @"Success";
NSString *const musAppFilter_Title_Offline = @"Offline";
NSString *const musAppFilter_Title_Error = @"Failed";
NSInteger const musAppPostsVC_HeightOfPostCell = 100;
NSString *const musApp_ActionSheet_Title_ChooseAction = @"Choose action";
NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos = 8;
NSInteger const musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos = 58;
NSString *const musApp_PostCell_Image_Name_CheckMarkTaken = @"checkMarkTaken.jpeg";
NSString *const musApp_PostCell_Image_Name_CheckMark = @"checkMark.jpeg";

#pragma mark - MUSGalleryViewOfPhotos

NSString *const musApp_GalleryOfPhotos_NibName = @"MUSGalleryViewOfPhotos";
NSString *const notificationShowImagesInCollectionView = @"notificationShowImagesInCollectionView";

#pragma mark - MUSGalleryOfPhotosCell

NSString *const musAppButton_ImageName_ButtonAdd = @"Button_Add.png";
NSString *const musAppButton_ImageName_AddPhoto = @"Button_addPhoto.png";
NSInteger const musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithoutPhotos = -4;
NSInteger const musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithPhotos = 50;

#pragma mark - MUSPostDescriptionCell

NSInteger const musApp_PostDescriptionCell_TextView_TopConstraint = 8;
NSInteger const musApp_PostDescriptionCell_TextView_BottomConstraint = 8;
NSInteger const musApp_PostDescriptionCell_TextView_LeftConstraint = 8;
NSInteger const musApp_PostDescriptionCell_TextView_RightConstraint = 8;

NSString *const musApp_PostDescriptionCell_TextView_Font_Name = @"Times New Roman";
NSInteger const musApp_PostDescriptionCell_TextView_Font_Size = 17;


#pragma mark - MUSDetailPostViewController

NSInteger const musAppDetailPostVC_HeightOfCommentsAndLikesCell = 95;
NSInteger const musAppDetailPostVC_HeightOfPostLocationCell = 200;
NSInteger const musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithoutPhotos = 70;
NSInteger const musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos = 150;
NSString *const musAppDetailPostVC_UpdatePostAlert = @"Do you want to update your Post?";
NSInteger const musAppDetailPostVC_NumberOfRows = 4;

#pragma mark - MUSCustomMapView

NSInteger const musAppCustomMapView_maxZoomDistance = 450000;
NSString *const musAppButton_ImageName_ButtonDeleteLocation = @"Button_Delete_Location.png";
NSString *const musAppCustomMapView_PinAnnotationViewIdentifier = @"MUSAnnotation";


@end
