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


@interface MUSUserDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UIBarButtonItem *logoutButton;
}

@property (nonatomic, strong) SocialNetwork *socialNetwork;

@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *userPropertyArray;


@end

@implementation MUSUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:2 target:self action: @selector(logoutFromSocialNetwork)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    self.userPropertyArray = [[NSArray alloc] initWithObjects:@"profile", @"dateOfBirth", @"city", @"clientID", nil];
}

- (void)setNetwork:(id)socialNetwork {
    self.socialNetwork = socialNetwork;
}


#pragma mark - UIAlertViewDelegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    switch (buttonIndex) {
//        case 1:
//            [[SocialManager sharedManager] changeProfileFromSocialNetworkForTypeNetwork:self.socialNetwork.currentUser.networkType];
//            break;
//        default:
//            [self logout];
//            break;
//    }
//}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex) {
//        [self.socialNetwork loginWithComplition:^(id result, NSError *error) {
//            [self.socialNetwork  loginOut];
//            [self.userTableView reloadData];
//            
//        }];
//    }
//    else {
//        [self logout];
//    }
//}


#pragma mark - UINavigationItems

//- (void) logoutFromSocialNetwork {
//    
//    if (self.socialNetwork.currentUser.networkType == Twitters) {
//        
//        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout"
//                                                        message:@"Do you want to change account"
//                                                       delegate:self
//                                              cancelButtonTitle:@"NO"
//                                              otherButtonTitles:@"YES",nil];
//       
//        [logoutAlert show];
//    } else {
//        [self logout];
//    }
//}

- (void) logoutFromSocialNetwork {
    [self.socialNetwork loginOut];
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.translucent = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userPropertyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return 50;
}


@end
