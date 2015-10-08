//
//  MUSPostsViewController.m
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostsViewController.h"
#import "MUSDetailPostViewController.h"
#import "MUSPostCell.h"
#import "ConstantsApp.h"
#import "SocialManager.h"
#import "DataBaseManager.h"
#import "MUSDetailPostViewController.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "SSARefreshControl.h"
#import "MUSReasonCommentsAndLikesCell.h"

@interface MUSPostsViewController () <UITableViewDataSource, UITableViewDelegate, MUSDetailPostViewControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, SSARefreshControlDelegate>

@property (nonatomic, strong) NSMutableArray *arrayOfLoginSocialNetworks;
///*!
// @abstract array of posts. Getting an array of posts from the database
// */
//@property (nonatomic, strong) NSMutableArray *arrayPosts;
/*!
 @abstract array of users. Getting an array of users from the database
 */
@property (nonatomic, strong) NSArray *arrayOfUsers;
/*!
 @abstract array of share reasons.
 */
@property (nonatomic, strong) NSArray *arrayOfShareReason;
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

@property (strong, nonatomic) NSMutableSet *setWithUniquePrimaryKeysOfPost ;

@property (nonatomic, strong) SSARefreshControl *refreshControl;

@end

@implementation MUSPostsViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self initiationTableView];
    [self initiationSSARefreshControl];
    self.setWithUniquePrimaryKeysOfPost = [[NSMutableSet alloc] init];
    [self.navigationController.navigationBar setTintColor: DARK_BROWN_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName: DARK_BROWN_COLOR}];
    self.title = musApp_PostsViewController_NavigationBar_Title;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
    [self updateNetworkPostsInPost];
    self.view.userInteractionEnabled = YES;
    // Notification for updating likes and comments in posts.
    [[NSNotificationCenter defaultCenter]
                            addObserver : self
                               selector : @selector(updateArrayPosts)
                                   name : MUSInfoPostsDidUpDateNotification
                                 object : nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: YES];
    [self.refreshControl endRefreshing];
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


#pragma mark initiation UITableView
/*!
 @method
 @abstract Initiation Table view - a table that contains an array of posts.
 */

- (void) initiationTableView {
    self.tableView = ({
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,  [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, screenSize.width, screenSize.height - self.tabBarController.tabBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = BROWN_COLOR_WITH_ALPHA_01;
        [self.view addSubview:tableView];
        tableView;
    });
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  [MUSPostManager manager].arrayOfPosts.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSPostCell *postCell = (MUSPostCell*) cell;
//    Post *currentPost = [self.arrayPosts objectAtIndex: indexPath.section];
//    [currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
//    postCell.arrayWithNetworkPosts = currentPost.arrayWithNetworkPosts;
    [postCell configurationPostCell : [[MUSPostManager manager].arrayOfPosts objectAtIndex: indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
        MUSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostCell cellID]];
        if(!cell) {
            cell = [MUSPostCell postCell];
        }
        Post *currentPost = [[MUSPostManager manager].arrayOfPosts objectAtIndex: indexPath.section];
        [currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
        cell.arrayWithNetworkPosts = currentPost.arrayWithNetworkPosts;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // disable the cell selection highlighting
        return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *currentPost = [[MUSPostManager manager].arrayOfPosts objectAtIndex: indexPath.section];
    return [MUSPostCell heightForPostCell: currentPost];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [[MUSPostManager manager].arrayOfPosts objectAtIndex: indexPath.section];
    self.view.userInteractionEnabled = NO;
//    if (![self.setWithUniquePrimaryKeysOfPost containsObject: [NSString stringWithFormat: @"%ld", (long)post.primaryKey]]) {
    [self performSegueWithIdentifier: goToDetailPostViewControllerSegueIdentifier sender: post];
//    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.contentOffset.y >= 0) {
        MUSPostCell *cell = (MUSPostCell *)[tableView cellForRowAtIndexPath:indexPath];
        //cell.backgroundViewOfCell.backgroundColor = BROWN_COLOR_Light;
        [self setCellColor: BROWN_COLOR_WITH_ALPHA_05 ForCell: cell];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSPostCell *cell = (MUSPostCell *)[tableView cellForRowAtIndexPath:indexPath];
    //cell.backgroundViewOfCell.backgroundColor = BROWN_COLOR_Light;
    [self setCellColor: [UIColor clearColor] ForCell: cell];
}

- (void) setCellColor: (UIColor *) color ForCell: (MUSPostCell *) cell {
    [UIView animateWithDuration: 0.3 animations:^{
        cell.backgroundViewOfCell.backgroundColor = color;
        //cell.contentView.backgroundColor = color;
    }];
    [UIView commitAnimations];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:goToDetailPostViewControllerSegueIdentifier]) {
        MUSDetailPostViewController * detailPostViewController = (MUSDetailPostViewController*)[segue destinationViewController];
        detailPostViewController.delegate = self;
        detailPostViewController = [segue destinationViewController];
        [detailPostViewController setCurrentPost: sender];
    }
}


#pragma mark - NetworkTypeFromMenuTitle
/*!
 @method
 @abstract return a Network type of the drop down menu title.
 @param string takes title of the drop down menu.
 */
- (NSInteger) networkTypeFromTitle : (NSString*) title {
    if ([title isEqual: MUSVKName]) {
        return MUSVKontakt;
    } else if ([title isEqual: MUSFacebookName]) {
        return MUSFacebook;
    } else {
        return MUSTwitters;
    }
}

/*!
 @method
 @abstract Obtain posts from Data Base.
 */
- (void) obtainArrayPosts {
    [self checkArrayOfPosts];
    [self.tableView reloadData];
}

- (void) checkArrayOfPosts {
    if (![MUSPostManager manager].arrayOfPosts.count) {
        self.tableView.scrollEnabled = NO;
    } else {
        self.tableView.scrollEnabled = YES;
    }
}


#pragma Update all posts in array

- (void) updateArrayPosts {
    [[MUSPostManager manager] updateArrayOfPost];
    //self.arrayPosts = [[[MUSPostManager manager] arrayOfAllPosts] mutableCopy];
    [self checkArrayOfPosts];
    [self.tableView reloadData];
}

#pragma Update network posts in array

- (void) updateNetworkPostsInPost {
    [[MultySharingManager sharedManager] updateNetworkPostsWithComplition:^(id result, NSError *error) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (BOOL) isArrayOfPostsNotEmpty {
    if (![MUSPostManager manager].arrayOfPosts.count) {
        return NO;
    } else {
        return YES;
    }
}

- (void) updatePostByPrimaryKey:(NSString *)primaryKey {
    [self.setWithUniquePrimaryKeysOfPost addObject: primaryKey];
}


#pragma mark - SSARefreshControlDelegate

- (void) beganRefreshing {
    
    if ([MUSPostManager manager].needToRefreshPosts || ![MUSPostManager manager].arrayOfPosts.count) {
        [self obtainArrayPosts];
        [self.refreshControl endRefreshing];
        return;
    }
    
    if (!self.isEditing) {
        [self updateNetworkPostsInPost];
    } else {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - dealloc

- (void) dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end






