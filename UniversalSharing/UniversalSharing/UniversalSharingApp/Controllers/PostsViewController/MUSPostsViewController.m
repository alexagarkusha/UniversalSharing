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
#import "SSARefreshControl.h"

@interface MUSPostsViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, MUSDetailPostViewControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, MUSPostCellDelegate, SSARefreshControlDelegate>

@property (nonatomic, strong) NSMutableArray *arrayOfLoginSocialNetworks;
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


@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectAllButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) UIToolbar *toolBar ;
@property (strong, nonatomic) UIBarButtonItem *barButtonDeletePost;
@property (strong, nonatomic) NSMutableIndexSet *mutableIndexSet ;
@property (nonatomic, strong) SSARefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableSet *setWithUniquePrimaryKeysOfPost ;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation MUSPostsViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self initiationDropDownMenu];
    [self initiationTableView];
    [self initiationLongPressGestureRecognizer];
    //[self obtainArrayPosts];
    
    self.setWithUniquePrimaryKeysOfPost = [[NSMutableSet alloc] init];
    self.title = musApp_PostsViewController_NavigationBar_Title;
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setTintColor: [UIColor clearColor]];
    self.mutableIndexSet = [[NSMutableIndexSet alloc] init];
    [self initiationToolBarForRemove];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(stopUpdatingPostInTableView:)
                                                 name : MUSNotificationStopUpdatingPost
                                               object : nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
    [self initiationArrayOfActiveSocialNetwork];
    // Notification for updating likes and comments in posts.
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(obtainArrayPosts)
                                                 name : MUSNotificationPostsInfoWereUpDated
                                               object : nil];
    [self initiationSSARefreshControl];
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initiation SSARefreshControl

- (void) initiationSSARefreshControl {
    self.refreshControl = [[SSARefreshControl alloc] initWithScrollView:self.tableView andRefreshViewLayerType:SSARefreshViewLayerTypeOnScrollView];
    self.refreshControl.circleViewColor = [UIColor lightGrayColor];
    self.refreshControl.delegate = self;
        
    [self.refreshControl beginRefreshing];


}

#pragma mark - initiation LongPressGestureRecognizer

- (void) initiationLongPressGestureRecognizer {
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                 initWithTarget:self
                                         action:@selector(handleLongPress:)];
    self.longPressGestureRecognizer.minimumPressDuration = 0.5; //seconds
    self.longPressGestureRecognizer.delegate = self;
    [self.tableView addGestureRecognizer: self.longPressGestureRecognizer];
}


- (void) initiationToolBarForRemove {
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    _toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.barButtonDeletePost = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toolbarButtonDeleteTapped:)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:flexibleSpace, self.barButtonDeletePost, flexibleSpace,nil];
    
    [_toolBar setItems:toolbarItems animated:NO];
    self.barButtonDeletePost.enabled = NO;
    [_toolBar setHidden:YES];
    [self.view addSubview:_toolBar];
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
    self.arrayOfLoginSocialNetworks = [[NSMutableArray alloc] init];
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
            [weakSelf.arrayOfLoginSocialNetworks addObject : socialNetwork];
        }
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayPosts.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSPostCell *postCell = (MUSPostCell*) cell;
    Post *post = [self.arrayPosts objectAtIndex: indexPath.row];
    
    if (![self.setWithUniquePrimaryKeysOfPost containsObject: [NSString stringWithFormat: @"%ld", (long)post.primaryKey]]) {
        
        [postCell configurationPostCell : post
                         andFlagEditing : self.editing
                       andFlagForDelete : [self.mutableIndexSet containsIndex : indexPath.row]];
    } else {
        [postCell configurationUpdatingPostCell: post];
    }
    [self setCellColor: [UIColor whiteColor] ForCell: cell];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostCell cellID]];
    if(!cell) {
        cell = [MUSPostCell postCell];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // disable the cell selection highlighting
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MUSPostCell heightForPostCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.arrayPosts objectAtIndex: indexPath.row];
    if (![self.setWithUniquePrimaryKeysOfPost containsObject: [NSString stringWithFormat: @"%ld", (long)post.primaryKey]] && !self.editing) {
        [self performSegueWithIdentifier: goToDetailPostViewControllerSegueIdentifier sender: post];
    } else {
        MUSPostCell *postCell = (MUSPostCell*) [self.tableView cellForRowAtIndexPath: indexPath];
        [postCell checkIsSelectedPost];
        [self addIndexToIndexSet: indexPath];
    }
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.arrayPosts objectAtIndex: indexPath.row];
    if (![self.setWithUniquePrimaryKeysOfPost containsObject: [NSString stringWithFormat: @"%ld", (long)post.primaryKey]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing && self.tableView.contentOffset.y >= 0) {
        MUSPostCell *cell = (MUSPostCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor: [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha: 1.0] ForCell: cell];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing) {
        MUSPostCell *cell = (MUSPostCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor: [UIColor whiteColor] ForCell: cell];
    }
}

- (void) setCellColor: (UIColor *) color ForCell: (UITableViewCell *) cell {
    [UIView animateWithDuration: 0.3 animations:^{
        cell.contentView.backgroundColor = color;
    }];
    [UIView commitAnimations];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (IBAction)buttonEditTapped:(id)sender {
    if(self.editing) {
        [self notEditingTableView];
    } else {
        [self editingTableView];
    }
    [self.tableView reloadData];
}

- (void) notEditingTableView {
    [super setEditing:NO animated:NO];
    [self.editButton setTitle:editButtonTitle];
    self.menu.alpha = 1.0f;
    self.menu.userInteractionEnabled = YES;
    self.refreshControl.circleViewColor = nil;
    [self.tableView addGestureRecognizer: self.longPressGestureRecognizer];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setTintColor: [UIColor clearColor]];
    [_toolBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.mutableIndexSet removeAllIndexes];
}

- (void) editingTableView {
    [super setEditing:YES animated:YES];
    [self.selectAllButton setTitle: @"Select All"];
    [self.editButton setTitle:doneButtonTitle];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.leftBarButtonItem setTintColor: nil];
    self.menu.alpha = 0.5f;
    self.menu.userInteractionEnabled = NO;
    self.refreshControl.circleViewColor = [UIColor whiteColor];
    [self.tableView removeGestureRecognizer: self.longPressGestureRecognizer];
    [self.menu dismiss];
    [self.tabBarController.tabBar setHidden:YES];
    [_toolBar setHidden:NO];
}

#pragma mark - MUSPostCellDelegate

- (void) addIndexToIndexSetWithCell:(MUSPostCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self addIndexToIndexSet: indexPath];
}


- (void) addIndexToIndexSet :(NSIndexPath*) indexPath {
    if ([self.mutableIndexSet containsIndex:indexPath.row]) {
        [self.mutableIndexSet removeIndex:indexPath.row];
        [self.selectAllButton setTitle: @"Select All"];
        if (![self.mutableIndexSet count]) {
            self.barButtonDeletePost.enabled = NO;
        }
        return;
    }
    [self.mutableIndexSet addIndex:indexPath.row];
    self.barButtonDeletePost.enabled = YES;
    if ([self.mutableIndexSet count] == [self.arrayPosts count]) {
        [self.selectAllButton setTitle: @"Deselect All"];
    }
}

- (IBAction) buttonSelectAllTapped:(id)sender {
    
    if (![self.selectAllButton.title isEqualToString: @"Deselect All"]) {
        [self.arrayPosts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            [self.mutableIndexSet addIndex:index];
        }];
        self.barButtonDeletePost.enabled = YES;
        [self.selectAllButton setTitle: @"Deselect All"];
    } else {
        [self.mutableIndexSet removeAllIndexes];
        self.barButtonDeletePost.enabled = NO;
        [self.selectAllButton setTitle: @"Select All"];
    }
    [self.tableView reloadData];
}

- (void) toolbarButtonDeleteTapped :(id) sender {
    if (![self.mutableIndexSet count]) {
        return;
    } else {
        [self showActionSheetDeletePosts];
    }
}

- (void) showActionSheetDeletePosts {
    NSString *stringButtonDeletePostsFromDataBase;
    if ([self.mutableIndexSet count] > 1) {
        stringButtonDeletePostsFromDataBase = [NSString stringWithFormat:@"Delete %lu posts", (unsigned long)[self.mutableIndexSet count]];
    } else {
        stringButtonDeletePostsFromDataBase = [NSString stringWithFormat: @"Delete post"];
    }
    UIActionSheet *actionSheetDeletePosts = [[UIActionSheet alloc]
                                             initWithTitle: nil
                                             delegate: self
                                             cancelButtonTitle: musAppButtonTitle_Cancel
                                             destructiveButtonTitle: stringButtonDeletePostsFromDataBase
                                             otherButtonTitles: nil];
    [actionSheetDeletePosts showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        [self deleteAllocatedPostsFromDataBase];
    }
}

- (void) deleteAllocatedPostsFromDataBase {
    [self.mutableIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [[DataBaseManager sharedManager] deletePostByPrimaryKey: self.arrayPosts[index]];
    }];
    self.arrayPosts = [[NSMutableArray alloc] initWithArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForPostWithReason: self.predicateReason andNetworkType: self.predicateNetworkType]]];
    [self.mutableIndexSet removeAllIndexes];
    self.editButton.enabled = [self isArrayOfPostsNotEmpty];
    if (![self isArrayOfPostsNotEmpty]) {
        [self notEditingTableView];
    }
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //MUSDetailPostViewController *detailPostViewController = [[MUSDetailPostViewController alloc] init];
    if ([[segue identifier] isEqualToString:goToDetailPostViewControllerSegueIdentifier]) {
        MUSDetailPostViewController * detailPostViewController = (MUSDetailPostViewController*)[segue destinationViewController];
        detailPostViewController.delegate = self;
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
    [self obtainArrayPosts];
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
- (void) obtainArrayPosts {
    self.arrayPosts = [[NSMutableArray alloc] initWithArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForPostWithReason: self.predicateReason andNetworkType: self.predicateNetworkType]]];
    self.editButton.enabled = [self isArrayOfPostsNotEmpty];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

- (BOOL) isArrayOfPostsNotEmpty {
    if (!self.arrayPosts.count) {
        return NO;
    } else {
        return YES;
    }
}

- (void) stopUpdatingPostInTableView: (NSNotification*) notification {
    [self.setWithUniquePrimaryKeysOfPost removeObject: [NSString stringWithFormat: @"%ld", (long)[notification.object integerValue]]];
    [self obtainArrayPosts];
}

- (void) updatePostByPrimaryKey:(NSString *)primaryKey {
    [self.setWithUniquePrimaryKeysOfPost addObject: primaryKey];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (!self.editing) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint p = [gestureRecognizer locationInView: self.tableView];
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
            if (indexPath != nil) {
                MUSPostCell *cell = (MUSPostCell *) [self.tableView cellForRowAtIndexPath:indexPath];
                if (cell.isHighlighted) {
                    [self.mutableIndexSet addIndex: indexPath.row];
                    self.barButtonDeletePost.enabled = YES;
                    [self editingTableView];
                    [self.tableView reloadData];
                    [self setCellColor: [UIColor whiteColor] ForCell: cell];
                }
            }
        }
    }
}

#pragma mark - SSARefreshControlDelegate

- (void) beganRefreshing {
    
    if (!self.arrayOfLoginSocialNetworks.count || !self.arrayPosts.count) {
        [self obtainArrayPosts];
        return;
    }
    
    if (!self.isEditing) {
        [self.arrayOfLoginSocialNetworks enumerateObjectsUsingBlock:^(SocialNetwork *socialNetwork, NSUInteger idx, BOOL *stop) {
            [socialNetwork updatePost];
        }];
    } else {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - dealloc

- (void) dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
