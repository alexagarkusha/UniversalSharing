//
//  ViewController.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSAccountsViewController.h"
#import "MUSAccountTableViewCell.h"
#import "MUSUserDetailViewController.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "ConstantsApp.h"
#import "ReachabilityManager.h"
#import "MUSDatabaseRequestStringsHelper.h"


@interface MUSAccountsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet    UITableView *tableView;
//@property (weak, nonatomic) IBOutlet    UIBarButtonItem *btnEditOutlet;
/*!
 @property error view - shows error Internet connection
 */
@property (weak, nonatomic) IBOutlet UIView   *errorView;
@property (weak, nonatomic) IBOutlet UIButton *updateNetworkConnectionOutlet;
@property (weak, nonatomic) IBOutlet UIButton *buttonUseAnywayOutlet;

/*!
 @property
 @abstract initialization by socialnetwork objects from socialmanager(facebook or twitter or VK)
 */
@property (strong, nonatomic) NSMutableArray *arrayWithNetworksObj;
/*!
 @property
 @abstract initialization by NSIndexPath in method didSelectRowAtIndexPath and buttonsDidShowForCell in order to get current socialnetwork in method prepareForSegue from arrayWithNetworksObj and disappear button when editing
 */
@property (strong, nonatomic) NSIndexPath * selectedIndexPath;
/*!
 @property
 @abstract array with buttons
 */
/*!
 @property
 @abstract using in order to forbid to swipe second cell when one is swiped
 */
/*!
 @method check access to the Internet connection
 */
- (IBAction)updateNetworkConnection:(id)sender;

@end

@implementation MUSAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: BROWN_COLOR_MIDLightHIGHT}];
    [self.navigationController.navigationBar setTintColor: BROWN_COLOR_MIDLightHIGHT];
    [self obtanObjectsOfSocialNetworks];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self obtanObjectsOfSocialNetworks];
    [self checkInternetConnection];
}

//- (void) changeArrays : (SocialNetwork*) socialNetwork {
//    [self.arrayWithNetworksObj removeObjectAtIndex:self.selectedIndexPath.row];
//    //[self.arrayUnactive insertObject:socialNetwork atIndex:0];
//    [self.tableView reloadData];
//}

/*!
 @method
 @abstract checking internet connection
 @param without
 */
- (void) checkInternetConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (!isReachableViaWiFi && !isReachable) {
        self.errorView.hidden = NO;
    } else {
        self.errorView.hidden = YES;
        [self.tableView reloadData];
    }
}
- (IBAction) buttonUseAnyWayTapped :(id)sender {
    self.errorView.hidden = YES;
    [self obtanObjectsOfSocialNetworks];
    
    [self.tableView reloadData];
    
    
}

//- (IBAction)btnEditTapped:(id)sender {
//    [[self obtainCurrentCell:self.selectedIndexPath] hideButtonViewAnimated:YES];
//
//    if(self.editing) {
//        [super setEditing:NO animated:NO];
//        [self.tableView setEditing:NO animated:NO];
//        [self.navigationItem.leftBarButtonItem setTitle:editButtonTitle];
////        [self.arrayButtons removeAllObjects];
////        [self.tableView reloadData];
//
//    } else {
//        [super setEditing:YES animated:YES];
//        [self.tableView setEditing:YES animated:YES];
//        [self.navigationItem.leftBarButtonItem setTitle:doneButtonTitle];
//    }
//}

/*!
 @method
 @abstract get objects of social network from socialManager, we pass array with NetworkType
 @param without
 */
- (void) obtanObjectsOfSocialNetworks {
    //NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
    self.arrayWithNetworksObj = [[SocialManager sharedManager] allNetworks];//[[SocialManager sharedManager] networks : arrayWithNetworks];
    //    [[SocialManager sharedManager] obtainNetworksWithComplition:^(id arrayLogin, id arrayHidden, id arrayUnactive, NSError *error) {
    //        self.arrayLogin = arrayLogin;
    //        self.arrayHidden = arrayHidden;
    //        self.arrayUnactive = arrayUnactive;
    //
    //    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section == 0) {
    //        return [self.arrayLogin count];
    //    } else if(section == 1){
    //        return [self.arrayHidden count];
    //    }else{
    //        return [self.arrayUnactive count];
    //    }
    return [self.arrayWithNetworksObj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {//////////////////////////
    /*!
     XIB
     */
    MUSAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSAccountTableViewCell cellID]];
    SocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    
    if(!cell) {
        cell = [MUSAccountTableViewCell accountTableViewCell];
    }
    
    //    if (indexPath.section  == 0) {
    //        socialNetwork = self.arrayLogin[indexPath.row];
    //    } else  if (indexPath.section  == 1) {
    //        socialNetwork = self.arrayHidden[indexPath.row];
    //    } else{
    //        socialNetwork = self.arrayUnactive[indexPath.row];
    //    }
    //if(!self.editing){
    //if (indexPath.section  == 0 || indexPath.section  == 1) {
    ///////////////////////////////////////////////////////////////////////button delete
    //    __weak MUSAccountsViewController *weakSelf = self;
    //    [cell setDelegate:self];
    //    [cell addFirstButton:[self createButtonHideShow :indexPath :socialNetwork] withWidth:80.0 withTappedBlock:^(AFMSlidingCell *cell) {
    //        [cell hideButtonViewAnimated:YES];
    //        [weakSelf changeTitleButton:[weakSelf obtainIndexPath:cell]];
    //    }];
    ///////////////////////////////////////////////////////////////////////////////////////////
    // }
    // }
    [cell configurateCellForNetwork:socialNetwork];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    SocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    //    if (indexPath.section  == 0) {
    //        socialNetwork = self.arrayLogin[indexPath.row];
    //    } else  if (indexPath.section  == 1) {
    //        socialNetwork = self.arrayHidden[indexPath.row];
    //    } else{
    //        socialNetwork = self.arrayUnactive[indexPath.row];
    //    }
    //
    //    if(!socialNetwork.isVisible){
    //        return;
    //    }
    /*!
     when cell is tapped we check this social network is login and existed a currentuser object  if YES we go to ditailviewcontroller, else to do login than go to ditailviewcontroller
     */
    if (socialNetwork.isLogin && socialNetwork.currentUser) {
        [self performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:socialNetwork];
        
    } else {
        __weak MUSAccountsViewController *weakSelf = self;
        [socialNetwork loginWithComplition:^(SocialNetwork* result, NSError *error) {
            if (result) {
                //                [weakSelf.arrayUnactive removeObjectAtIndex:indexPath.row];
                //                [weakSelf.arrayLogin insertObject:result atIndex:0];
                [weakSelf.tableView reloadData];
                //[weakSelf performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:result];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeCell = 50.0f;
    return sizeCell;
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {////////////////////////////////////////////////////////////
    
    MUSUserDetailViewController *vc = [MUSUserDetailViewController new];
    if ([[segue identifier] isEqualToString:goToUserDetailViewControllerSegueIdentifier]) {
        vc = [segue destinationViewController];
        vc.delegate = self;
        [vc setNetwork:sender];//self.arrayWithNetworksObj[self.selectedIndexPath.row]];
    }
}

- (IBAction)updateNetworkConnection:(id)sender {
    [self checkInternetConnection];
}

- (SocialNetwork*) obtainCurrentSocialNetwork : (NSIndexPath*) indexPath {
    return self.arrayWithNetworksObj[indexPath.row];
}


@end
