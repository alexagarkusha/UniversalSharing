//
//  MUSLocationViewController.h
//  UniversalSharing
//
//  Created by U 2 on 07.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@interface MUSLocationViewController : UIViewController

/*!
 @property
 @abstract return object Place from arrayLocations
 */
@property (copy, nonatomic) Complition placeComplition;

/*!
 @method
 @abstract set current user in order to get array places
 @param current user(facebook or twitter or VK)
 */
- (void)currentUser:(SocialNetwork*)socialNetwork;

@end