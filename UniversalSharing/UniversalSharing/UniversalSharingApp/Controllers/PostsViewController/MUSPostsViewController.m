//
//  MUSPostsViewController.m
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostsViewController.h"
#import "MUSDetailPostViewController.h"
#import "DOPDropDownMenu.h"
#import "MUSPostCell.h"
#import "ConstantsApp.h"
#import "SocialManager.h"
#import "DataBaseManager.h"
#import "MUSDetailPostViewController.h"
#import "MUSDatabaseRequestStringsHelper.h"

@interface MUSPostsViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *arrayPosts;
@property (nonatomic, strong) NSArray *arrayOfUsers;

@property (nonatomic, strong) NSArray *arrayOfShareReason;
@property (nonatomic, strong) NSMutableArray *arrayOfActiveSocialNetwork;
@property (nonatomic, strong) DOPDropDownMenu *menu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) FilterInColumnType columnType;

@property (nonatomic, assign) NSInteger predicateNetworkType;
@property (nonatomic, assign) NSInteger predicateReason;


@end

@implementation MUSPostsViewController

- (void)viewDidLoad {
    //[self POSTS]; // DELETE THIS AFTER Connect SQLite
    [self initiationArrayOfShareReason];
    [self initiationArrayOfActiveSocialNetwork];
    [self initiationDropDownMenu];
    [self initiationTableView];

    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
#warning "Twice?"
    [self initiationArrayOfActiveSocialNetwork];
    self.arrayPosts = [NSArray arrayWithArray: [[DataBaseManager sharedManager] obtainAllPosts]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initiation DOPDropDownMenu 

- (void) initiationDropDownMenu {
    [super viewDidLoad];
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height) andHeight: 40];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    [self.view addSubview : self.menu];
}

#pragma mark initiation UITableView

- (void) initiationTableView {
    self.tableView = ({
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,  [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height + self.menu.frame.size.height, screenSize.width, screenSize.height - self.menu.frame.origin.y - self.menu.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark initiation ArrayOfShareReason

- (void) initiationArrayOfShareReason {
    self.arrayOfShareReason = [[NSArray alloc] initWithObjects: @"All share reasons", musAppFilter_Title_Shared, musAppFilter_Title_Offline, musAppFilter_Title_Error,  nil];
}

#pragma mark initiation ArrayOfPostsType

- (void) initiationArrayOfActiveSocialNetwork {
    
    self.arrayOfActiveSocialNetwork = [[NSMutableArray alloc] init];
    [self.arrayOfActiveSocialNetwork addObject: @"All social networks"];
    ////////////////////////////////////////////////////////////////////////////////////////////// it was changed by roman
    self.arrayOfUsers = [[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForAllUsers]];
    NSMutableArray *arrayWithNetworks = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.arrayOfUsers.count; i++) {
        User *currentUser = [self.arrayOfUsers objectAtIndex: i];
        [arrayWithNetworks addObject: @(currentUser.networkType)];
    }
//#warning "???"
    __weak MUSPostsViewController *weakSelf = self;
    [[[SocialManager sharedManager] networks: arrayWithNetworks] enumerateObjectsUsingBlock:^(SocialNetwork *socialNetwork, NSUInteger index, BOOL *stop) {
        if (socialNetwork.isLogin) {
            [weakSelf.arrayOfActiveSocialNetwork addObject : socialNetwork.name];
        }
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayPosts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostCell cellID]];
    if(!cell) {
        cell = [MUSPostCell postCell];
    }
    [cell configurationPostCell: [self.arrayPosts objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier: goToDetailPostViewControllerSegueIdentifier sender:[self.arrayPosts objectAtIndex: indexPath.row]];
}
     

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSDetailPostViewController *detailPostViewController = [[MUSDetailPostViewController alloc] init];
    if ([[segue identifier] isEqualToString:goToDetailPostViewControllerSegueIdentifier]) {
        detailPostViewController = [segue destinationViewController];
        [detailPostViewController setCurrentPost: sender];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//#warning "Cell knows it size"
    return [MUSPostCell heightForPostCell];
}



#pragma mark - DOPDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn : (NSInteger)column {
    self.columnType = column;
    NSInteger numberOfRowsInColumn;
    switch (self.columnType) {
        case ByNetworkType:
            numberOfRowsInColumn = self.arrayOfActiveSocialNetwork.count;
            break;
        case ByShareReason:
             numberOfRowsInColumn = self.arrayOfShareReason.count;
            break;
        default:
            break;
    }
    return numberOfRowsInColumn;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    self.columnType = indexPath.column;
    switch (self.columnType) {
        case ByNetworkType:
            return self.arrayOfActiveSocialNetwork [indexPath.row];
            break;
        case ByShareReason:
            return self.arrayOfShareReason [indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - DOPDropDownMenuDelegate

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    
    NSString *title = [menu titleForRowAtIndexPath:indexPath];

    self.columnType = indexPath.column;

    switch (self.columnType) {
        case ByNetworkType:{
            if (indexPath.row == 0) {
                self.predicateNetworkType = 0;
            } else {
                self.predicateNetworkType = [self networkTypeFromTitle: title];
            }
        }
            break;
        case ByShareReason:{
            if (indexPath.row == 0) {
                self.predicateReason = 0;
            } else {
                self.predicateReason = [self reasonFromTitle:title];
            }
        }
            break;
        default:
            break;
    }
    self.arrayPosts = [[DataBaseManager sharedManager] obtainPostsWithReason: self.predicateReason andNetworkType:self.predicateNetworkType];
    [self.tableView reloadData];
}

#pragma mark - ReasonFromMenuTitle

- (NSInteger) reasonFromTitle : (NSString*) title {
    if ([title isEqual: musAppFilter_Title_Error]) {
        return ErrorConnection;
    } else if ([title isEqual: musAppFilter_Title_Offline]) {
        return Offline;
    } else {
        return Connect;
    }
}

#pragma mark - NetworkTypeFromMenuTitle

- (NSInteger) networkTypeFromTitle : (NSString*) title {
    if ([title isEqual: musVKName]) {
        return VKontakt;
    } else if ([title isEqual: musFacebookName]) {
        return Facebook;
    } else {
        return Twitters;
    }
}

@end
