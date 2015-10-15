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
/*!
 @property error view - shows error Internet connection
 */
@property (weak, nonatomic) IBOutlet UIView   *errorView;

@property (weak, nonatomic) IBOutlet UIButton *updateNetworkConnectionButton;
@property (weak, nonatomic) IBOutlet UIButton *useAnywayButton;

/*!
 @property
 @abstract initialization by socialnetwork objects from socialmanager(facebook or twitter or VK)
 */
@property (strong, nonatomic) NSMutableArray *socialNetworksArray;
/*!
 @method check access to the Internet connection
 */
- (IBAction)updateNetworkConnection:(id)sender;

@end

@implementation MUSAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpColors];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self obtainSocialNetworks];
    [self checkInternetConnection];
}

- (void) setUpColors {
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: DARK_BROWN_COLOR}];
    [self.navigationController.navigationBar setTintColor: DARK_BROWN_COLOR];
    self.errorView.backgroundColor = BROWN_COLOR;
    self.updateNetworkConnectionButton.backgroundColor = DARK_BROWN_COLOR;
    self.useAnywayButton.backgroundColor = DARK_BROWN_COLOR;
}

/*!
 @method
 @abstract checking internet connection
 @param without
 */
- (void) checkInternetConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    if (!isReachableViaWiFi && !isReachable) {
        self.errorView.hidden = NO;
    } else {
        self.errorView.hidden = YES;
        [self.tableView reloadData];
    }
}

- (IBAction) useAnywayButtonTapped :(id)sender {
    self.errorView.hidden = YES;
    [self obtainSocialNetworks];
    [self.tableView reloadData];
}

/*!
 @method
 @abstract get objects of social network from socialManager, we pass array with NetworkType
 @param without
 */
- (void) obtainSocialNetworks {
    self.socialNetworksArray = [[MUSSocialManager sharedManager] allNetworks];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.socialNetworksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSAccountTableViewCell cellID]];
    MUSSocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    if(!cell) {
        cell = [MUSAccountTableViewCell accountTableViewCell];
    }
    [cell configurateCellForNetwork:socialNetwork];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSSocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    
    /*!
     when cell is tapped we check this social network is login and existed a currentuser object  if YES we go to ditailviewcontroller, else to do login than go to ditailviewcontroller
     */
    
    if (socialNetwork.isLogin && socialNetwork.currentUser) {
        [self performSegueWithIdentifier: MUSApp_SegueIdentifier_GoToUserDetailViewController sender:socialNetwork];
        
    } else {
        __weak MUSAccountsViewController *weakSelf = self;
        [socialNetwork loginWithComplition:^(MUSSocialNetwork* result, NSError *error) {
            if (result) {
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeCell = 50.0f;
    return sizeCell;
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSUserDetailViewController *vc = [MUSUserDetailViewController new];
    if ([[segue identifier] isEqualToString:MUSApp_SegueIdentifier_GoToUserDetailViewController]) {
        vc = [segue destinationViewController];
        [vc setNetwork:sender];
    }
}

- (IBAction)updateNetworkConnection:(id)sender {
    [self checkInternetConnection];
}

- (MUSSocialNetwork*) obtainCurrentSocialNetwork : (NSIndexPath*) indexPath {
    return self.socialNetworksArray[indexPath.row];
}


@end
