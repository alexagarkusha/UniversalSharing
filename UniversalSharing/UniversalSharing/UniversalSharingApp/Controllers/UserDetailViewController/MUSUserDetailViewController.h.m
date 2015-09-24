//
//  UserScreenViewController.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSUserDetailViewController.h"
#import "MUSTopUserProfileCell.h"
#import "MUSUserProfileCell.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "DataBaseManager.h"
@interface MUSUserDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
/*!
 @property
 @abstract button in navigation bar
 */
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
/*!
 @property
 @abstract initialization by socialnetwork(facebook or twitter or VK) getting from AccountViewController
 */
@property (nonatomic, strong) SocialNetwork *socialNetwork;
/*!
 @property
 @abstract initialization by current info of current user
 */
@property (strong, nonatomic) NSArray *userPropertyArray;
//===
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@end

@implementation MUSUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isLogoutButtonHide) {
        self.logoutButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout" style: 1 target:self action: @selector(logoutFromSocialNetwork)];
        self.navigationItem.rightBarButtonItem = self.logoutButton;
    }
    self.userPropertyArray = @[@"profile", @"dateOfBirth", @"city", @"clientID"];
}

- (void)setNetwork:(id)socialNetwork {
    self.socialNetwork = socialNetwork;
}
/*!
 @method
 @abstract logout from current network and leave this viewcontroller
 @param without
 */
- (void) logoutFromSocialNetwork {
    [self.socialNetwork loginOut];
    [self.navigationController popViewControllerAnimated:YES];
     self.navigationController.navigationBar.translucent = YES;
    [self.delegate changeArrays:self.socialNetwork];
    }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userPropertyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     XIB
     */
    if (indexPath.row == 0) {
        MUSTopUserProfileCell* cell = [tableView dequeueReusableCellWithIdentifier: [MUSTopUserProfileCell cellID]];
        if (!cell) {
            cell = [MUSTopUserProfileCell profileUserTableViewCell];
        }
        [cell configurationProfileUserTableViewCellWithUser: self.socialNetwork.currentUser];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        MUSUserProfileCell* cell = [tableView dequeueReusableCellWithIdentifier: [MUSUserProfileCell cellID]];
        if (!cell) {
            cell = [MUSUserProfileCell generalUserInfoTableViewCell];
        }
        [cell configurationGeneralUserInfoTableViewCellWithUser: self.socialNetwork.currentUser andCurrentProperty: [self.userPropertyArray objectAtIndex: indexPath.row]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    NSString *valueOfUserPropertyInfo = [self.socialNetwork.currentUser valueForKey: [self.userPropertyArray objectAtIndex: indexPath.row]];
    return [MUSUserProfileCell heightForGeneralUserInfoWithCurrentPropertyOfUser:valueOfUserPropertyInfo];
}

@end
