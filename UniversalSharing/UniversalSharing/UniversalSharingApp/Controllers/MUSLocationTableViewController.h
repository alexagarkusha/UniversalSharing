//
//  MUSLocationTableViewController.h
//  UniversalSharing
//
//  Created by Roman on 8/3/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import "SocialNetwork.h"
/*
 @class MUSLocationTableViewController
 
 */
@interface MUSLocationTableViewController : UITableViewController

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
- (void)setCurrentUser:(SocialNetwork*)socialNetwork;

@end
