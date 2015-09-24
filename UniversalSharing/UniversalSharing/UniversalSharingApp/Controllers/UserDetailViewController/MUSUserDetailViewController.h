//
//  UserScreenViewController.h
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUSUserDetailViewControllerDelegate <NSObject>

- (void) changeArrays : (id) socialNetwork;

@end

@interface MUSUserDetailViewController: UIViewController
@property (nonatomic, assign) id <MUSUserDetailViewControllerDelegate> delegate;
/*!
 @method
 @abstract set current user in order to get info about current user
 @param current user(facebook or twitter or VK)
 */
- (void)setNetwork:(id)socialNetwork;

@property (assign, nonatomic) BOOL isLogoutButtonHide;

@end
