//
//  ViewController.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSAccountsViewController.h"
#import "MUSUserDetailViewController.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "MUSAccountTableViewCell.h"
#import "ConstantsApp.h"
#import "ReachabilityManager.h"
#import "UIButton+CornerRadiusButton.h"


@interface MUSAccountsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEditOutlet;
/*!
 @property error view - shows error Internet connection
 */
@property (weak, nonatomic) IBOutlet UIView *errorView;

@property (weak, nonatomic) IBOutlet UIButton *updateNetworkConnectionOutlet;
/*!
 @property
 @abstract initialization by socialnetwork objects from socialmanager(facebook or twitter or VK)
 */
@property (strong, nonatomic) NSMutableArray *arrayWithNetworksObj;
/*!
 @property
 @abstract initialization by NSIndexPath in method didSelectRowAtIndexPath in order to get current socialnetwork in method prepareForSegue from arrayWithNetworksObj
 */
@property (strong, nonatomic) NSIndexPath * selectedIndexPath;
/*!
 @method check access to the Internet connection
 */
- (IBAction)updateNetworkConnection:(id)sender;

@end

@implementation MUSAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkInternetConnection];
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
        self.btnEditOutlet.enabled = NO;
        [self.updateNetworkConnectionOutlet cornerRadius:CGRectGetHeight(self.updateNetworkConnectionOutlet.frame) / 2];
    } else {
        self.errorView.hidden = YES;
        self.btnEditOutlet.enabled = YES;
        [self obtanObjectsOfSocialNetworks];
        [self.tableView reloadData];
    }
}

- (IBAction)btnEditTapped:(id)sender {
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.navigationItem.leftBarButtonItem setTitle:editButtonTitle];
    } else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.leftBarButtonItem setTitle:doneButtonTitle];
    }
    [self.tableView reloadData];
    
}

/*!
 @method
 @abstract get objects of social network from socialManager, we pass array with NetworkType
 @param without
 */
- (void) obtanObjectsOfSocialNetworks {
    NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
    self.arrayWithNetworksObj = [[SocialManager sharedManager] networks : arrayWithNetworks];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWithNetworksObj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSAccountTableViewCell cellID]];
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    if(!cell) {
        cell = [MUSAccountTableViewCell accountTableViewCell];
    }
    [cell configurateCellForNetwork:socialNetwork];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    /*!
     when cell is tapped we check this social network is login and existed a currentuser object  if YES we go to ditailviewcontroller, else to do login than go to ditailviewcontroller
     */
    if (socialNetwork.isLogin && socialNetwork.currentUser) {
        [self performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
        
    } else {
        __weak MUSAccountsViewController *weakSelf = self;
        [socialNetwork loginWithComplition:^(id result, NSError *error) {
            if (result) {
                [weakSelf performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
            } else {
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    MUSAccountTableViewCell *cell = (MUSAccountTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    /*!
     in order to set bool property isVisible for configurating color of cell
     */
    [cell changeColorOfCell:socialNetwork];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    /*
     change socialnetwork objects when cells are changed
     */
    [self.arrayWithNetworksObj exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    return socialNetwork.isVisible ?  showButtonTitle : hideButtonTitle;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeCell = 50.0f;
    return sizeCell;
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSUserDetailViewController *vc = [MUSUserDetailViewController new];
    if ([[segue identifier] isEqualToString:goToUserDetailViewControllerSegueIdentifier]) {
        vc = [segue destinationViewController];
        [vc setNetwork:self.arrayWithNetworksObj[self.selectedIndexPath.row]];
    }
}

- (IBAction)updateNetworkConnection:(id)sender {
    [self checkInternetConnection];
}
@end
