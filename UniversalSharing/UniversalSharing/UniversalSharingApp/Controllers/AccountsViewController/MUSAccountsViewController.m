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

@interface MUSAccountsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *arrayWithNetworksObj;
@property (strong, nonatomic) NSIndexPath * selectedIndexPath;

@end

@implementation MUSAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:notificationReloadTableView object:nil];
    //self.tableView.contentInset = UIEdgeInsetsMake(-70,0,0,0);
    self.arrayWithNetworksObj = [[SocialManager sharedManager] networks];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return self.arrayWithNetworksObj.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSAccountTableViewCell cellID]];
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    
    if(!cell){        
        cell = [MUSAccountTableViewCell accountTableViewCell];
    }
    
    [cell configurateCellForNetwork:socialNetwork];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    if (socialNetwork.isLogin && socialNetwork.currentUser) {
        [self performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
    }
    else{
        __weak MUSAccountsViewController *weakSelf = self;
        
        [socialNetwork loginWithComplition:^(id result, NSError *error) {
            if (result) {
                [weakSelf performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
            }
        }];
        
//        [[SocialManager sharedManager]loginForTypeNetwork:socialNetwork.networkType :^(id result, NSError *error) {
//            
//            if (result) {
//                [weakSelf performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
//            }
//        }];
    }
}

- (void) reloadTableView {
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sizeCell = 50;
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
