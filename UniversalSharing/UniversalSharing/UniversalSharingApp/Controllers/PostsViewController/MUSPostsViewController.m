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
/*!
 @abstract array of posts. Getting an array of posts from the database
 */
@property (nonatomic, strong) NSMutableArray *arrayPosts;
/*!
 @abstract array of users. Getting an array of users from the database
 */
@property (nonatomic, strong) NSArray *arrayOfUsers;
/*!
 @abstract array of share reasons.
 */
@property (nonatomic, strong) NSArray *arrayOfShareReason;
/*!
 @abstract array of active social networks.
 */
@property (nonatomic, strong) NSMutableArray *arrayOfActiveSocialNetwork;
/*!
 @abstract custom drop down menu for filtering posts by network type or by reason type.
 */
@property (nonatomic, strong) DOPDropDownMenu *menu;
/*!
 @abstract table view for presenting array of posts.
 */
@property (nonatomic, strong) UITableView *tableView;
/*!
 @abstract type of column in custom drop down menu for filtering posts.
 */
@property (nonatomic, assign) FilterInColumnType columnType;
/*!
 @abstract predicate Network Type.
 */
@property (nonatomic, assign) NSInteger predicateNetworkType;
/*!
 @abstract predicate Reason Type.
 */
@property (nonatomic, assign) NSInteger predicateReason;

@end

@implementation MUSPostsViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self initiationDropDownMenu];
    [self initiationTableView];
    self.title = musApp_PostsViewController_NavigationBar_Title;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
#warning "Twice?"
    [self initiationArrayOfActiveSocialNetwork];
    [self obtainPosts];
    // Notification for updating likes and comments in posts.
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(obtainPosts)
                                                 name : MUSNotificationPostsInfoWereUpDated
                                               object : nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initiation DOPDropDownMenu 

/*!
 @method
 @abstract Initiation DropDownMenu - filters for posts.
 */

- (void) initiationDropDownMenu {
    [super viewDidLoad];
    [self initiationArrayOfActiveSocialNetwork];
    [self initiationArrayOfShareReason];
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height) andHeight: musApp_DropDownMenu_Height];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    [self.view addSubview : self.menu];
}

#pragma mark initiation UITableView
/*!
 @method
 @abstract Initiation Table view - a table that contains an array of posts.
 */

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
/*!
 @method
 @abstract Initiation Array of share reason - it is needed for "reason filter" of DropDownMenu .
 */
- (void) initiationArrayOfShareReason {
    self.arrayOfShareReason = [[NSArray alloc] initWithObjects: musApp_PostsViewController_AllShareReasons, musAppFilter_Title_Shared, musAppFilter_Title_Offline, musAppFilter_Title_Error,  nil];
}

#pragma mark initiation ArrayOfPostsType
/*!
 @method
 @abstract Initiation Array of share reason - it is needed for "network filter" of DropDownMenu .
 */

- (void) initiationArrayOfActiveSocialNetwork {
    
    self.arrayOfActiveSocialNetwork = [[NSMutableArray alloc] init];
    [self.arrayOfActiveSocialNetwork addObject: musApp_PostsViewController_AllSocialNetworks];
    self.arrayOfUsers = [[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForAllUsers]];
    NSMutableArray *arrayWithNetworks = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.arrayOfUsers.count; i++) {
        User *currentUser = [self.arrayOfUsers objectAtIndex: i];
        [arrayWithNetworks addObject: @(currentUser.networkType)];
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // disable the cell selection highlighting
    [cell configurationPostCell: [self.arrayPosts objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MUSPostCell heightForPostCell];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[DataBaseManager sharedManager] deletePostByPrimaryKey: [self.arrayPosts objectAtIndex:indexPath.row]];
    // Remove the row from data model
    [self.arrayPosts removeObjectAtIndex:indexPath.row];
    // Request table view to reload
    [tableView reloadData];
}

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
    [self.arrayPosts removeAllObjects];
    [self obtainPosts];
}

#pragma mark - ReasonFromMenuTitle
/*!
 @method
 @abstract return a Reason type of the drop down menu title.
 @param string takes title of the drop down menu.
*/
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
/*!
 @method
 @abstract return a Network type of the drop down menu title.
 @param string takes title of the drop down menu.
*/
- (NSInteger) networkTypeFromTitle : (NSString*) title {
    if ([title isEqual: musVKName]) {
        return VKontakt;
    } else if ([title isEqual: musFacebookName]) {
        return Facebook;
    } else {
        return Twitters;
    }
}

/*!
 @method
 @abstract Obtain posts from Data Base.
 */
- (void) obtainPosts {
    self.arrayPosts = [[NSMutableArray alloc] initWithArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForPostWithReason: self.predicateReason andNetworkType: self.predicateNetworkType]]];
    [self.tableView reloadData];
}

@end
