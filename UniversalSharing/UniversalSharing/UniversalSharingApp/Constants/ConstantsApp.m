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
NSString *const collectionViewCellIdentifier = @"CollectionViewCellIdentifier";
NSString *const distanceEqual100 = @"100";
NSString *const distanceEqual1000 = @"1000";
NSString *const distanceEqual25000 = @"25000";
//===
NSInteger const countOfAllowedPics = 4;


#pragma mark - Errors

NSString *const musAppError_With_Domain_Universal_Sharing = @"Universal Sharing application";
NSString *const musAppError_Internet_Connection = @"Please check your internet connection or try again later";

#pragma mark - MUSPhotoManager

NSInteger const musAppCompressionSizePicture_By_Height = 800;
NSInteger const musAppCompressionSizePicture_By_Width = 800;

NSString *const musAppError_NO_Camera = @"Device has no camera";
NSInteger const musAppError_NO_Camera_Code = 1500;

NSString *const musAppAlertTitle_Share_Photo = @"Share photo";
NSString *const musAppAlertTitle_NO_Pics_Anymore = @"You can not add pics anymore :[";



#pragma mark MUSAccountViewController Constants

NSString *const editButtonTitle = @"Edit";
NSString *const doneButtonTitle = @"Done";
NSString *const showButtonTitle = @"Show";
NSString *const hideButtonTitle = @"Hide";

#pragma mark - General constants

NSString *const musAppButtonTitle_Cancel = @"Cancel";
NSString *const musAppButtonTitle_OK = @"Ok";
NSString *const musAppButtonTitle_Album = @"Album";
NSString *const musAppButtonTitle_Camera = @"Camera";



@end
