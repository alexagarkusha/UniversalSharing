//
//  Constants.h
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConstantsApp : NSObject

#pragma mark AccountsViewController Constants

FOUNDATION_EXPORT NSString *const goToUserDetailViewControllerSegueIdentifier;
FOUNDATION_EXPORT NSString *const notificationReloadTableView;

#pragma mark MUSShareViewController Constants

FOUNDATION_EXPORT NSString *const kPlaceholderText;

typedef NS_ENUM(NSInteger, TabBarItemIndex) {
    Share_photo,
    Share_location,
};

typedef NS_ENUM(NSInteger, AlertButtonIndex) {
    Cancel,
    Album,
    Camera,
};


#pragma mark MUSPhotoManager Constants

typedef void (^ComplitionPhoto)(id result, NSError *error);
typedef void (^ComplitionLocation)(id result, NSError *error);


@end
