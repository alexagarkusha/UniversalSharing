//
//  MUSDetailPostViewController.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostViewController.h"
#import "MUSCommentsAndLikesCell.h"
#import "MUSPostDescriptionCell.h"
#import "MUSPostLocationCell.h"
#import "ConstantsApp.h"
#import "MUSMediaGalleryViewController.h"
#import "MEExpandableHeaderView.h"
#import "MUSPopUpForSharing.h"

@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate,  UIActionSheetDelegate, UIAlertViewDelegate, MEExpandableHeaderViewDelegate, UIScrollViewDelegate, MUSPopUpForSharingDelegate>
/*!
 @abstract tableview frame size of the detail post
 */
@property (nonatomic, assign) CGRect tableViewFrame;

@property (nonatomic, strong) UIBarButtonItem *shareButton;
/*!
 @abstract table view of detail post
 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger indexPicTapped;

@property (nonatomic, strong) MEExpandableHeaderView *headerView;

@property (nonatomic, strong) MUSPopUpForSharing *popUpForSharing;

@end

@implementation MUSDetailPostViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self.currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
    [self initiationTableView];
    [self initiationHeaderView];
    [self initiationNavigationBar];
    
    self.tableViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initiation UITableView
/*!
 @method
 @abstract initiation Table view
 */
- (void) initiationTableView {
    self.tableView = ({
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, screenSize.width, screenSize.height - self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    //self.isEditableTableView = NO;
}

#pragma mark - initiationHeaderViewForTableView

- (void) initiationHeaderView
{
    ImageToPost *firstImage = [self.currentPost.arrayImages firstObject];
    
    if (!self.currentPost.arrayImages.count || !firstImage.image) {
        self.currentPost.arrayImages = nil;
    } else {
        NSMutableArray *pagesArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.currentPost.arrayImages.count; i++) {
            [pagesArray addObject: [self createPageViewWithImageView: [self.currentPost.arrayImages objectAtIndex: i]]];
        }
        CGSize headerViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MUSApp_MUSDetailPostViewController_HeightOfHeader);
        MEExpandableHeaderView *headerView = [[MEExpandableHeaderView alloc]
                                              initWithSize : headerViewSize
                                              backgroundImage : nil
                                              contentPages : pagesArray];
        headerView.delegate = self;
        self.tableView.tableHeaderView = headerView;
        self.headerView = headerView;
    }
}

- (UIView*) createPageViewWithImageView: (ImageToPost*) imageToPost
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, MUSApp_MUSDetailPostViewController_HeightOfHeader)];
    imageView.image = imageToPost.image;
    imageView.clipsToBounds = YES;
    if (imageView.image.size.height < MUSApp_MUSDetailPostViewController_HeightOfHeader || imageView.image.size.width <  [UIScreen mainScreen].bounds.size.width ) {
        [imageView setContentMode: UIViewContentModeScaleAspectFill];
    } else {
        [imageView setContentMode: UIViewContentModeTop];
    }
    return imageView;
}

#pragma mark initiation UINavigationBar
/*!
 @method
 @abstract initiation Navigation Bar
 */
- (void) initiationNavigationBar {
    BOOL isPostConnect = YES;
    for (NetworkPost *currentNetworkPost in self.currentPost.arrayWithNetworkPosts) {
        if (currentNetworkPost.reason != MUSConnect) {
            isPostConnect = NO;
        }
    }
    
    if (!isPostConnect && ![[MultySharingManager sharedManager] queueOfPosts: self.currentPost.primaryKey]) {
        self.shareButton = [[UIBarButtonItem alloc] initWithTitle : MUSApp_Button_Title_Share style:2 target:self action: @selector(sharePost)];
        self.navigationItem.rightBarButtonItem = self.shareButton;
    }
}

#pragma mark sharePost
/*!
 @method
 @abstract send post to social network
 */
- (void) sharePost {
    self.popUpForSharing = [MUSPopUpForSharing new];
    self.popUpForSharing.arrayOfNetworksPost = self.currentPost.arrayWithNetworkPosts;
    self.popUpForSharing.delegate = self;
    [self.navigationController addChildViewController: self.popUpForSharing];
    self.popUpForSharing.view.frame = self.view.bounds;//CGRectMake(0, 100, 200, 200);//
    [self.navigationController.view addSubview: self.popUpForSharing.view];
    [self.popUpForSharing didMoveToParentViewController:self];
    [self.view endEditing:YES];
}

- (void) closePopUpForSharing {
    [self.popUpForSharing removeFromParentViewController];
    [self.popUpForSharing.view removeFromSuperview];
    self.popUpForSharing = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MUSApp_MUSDetailPostViewController_NumberOfRowsInTableView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPostVC_CellType detailPostVC_CellType = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (detailPostVC_CellType) {
        case CommentsAndLikesCellType: {
            MUSCommentsAndLikesCell *commentsAndLikesCell = (MUSCommentsAndLikesCell*) cell;
            commentsAndLikesCell.arrayWithNetworkPosts = self.currentPost.arrayWithNetworkPosts;
            [commentsAndLikesCell configurationCommentsAndLikesCell];
            break;
        }
        case PostDescriptionCellType: {
            MUSPostDescriptionCell *postDescriptionCell = (MUSPostDescriptionCell*) cell;
            [postDescriptionCell configurationPostDescriptionCell: self.currentPost.postDescription];
            break;
        }
        default: {
            MUSPostLocationCell *postLocationCell = (MUSPostLocationCell*) cell;
            [postLocationCell configurationPostLocationCellByPostPlace: self.currentPost];
            break;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPostVC_CellType detailPostVC_CellType = indexPath.row;
    switch (detailPostVC_CellType) {
        case CommentsAndLikesCellType: {
            MUSCommentsAndLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSCommentsAndLikesCell cellID]];
            if(!cell) {
                cell = [MUSCommentsAndLikesCell commentsAndLikesCell];
            }
            return cell;
            break;
        }
        case PostDescriptionCellType: {
            MUSPostDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostDescriptionCell cellID]];
            if(!cell) {
                cell = [MUSPostDescriptionCell postDescriptionCell];
            }
            return cell;
            break;
        }
        default: {
            MUSPostLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostLocationCell cellID]];
            if(!cell) {
                cell = [MUSPostLocationCell postLocationCell];
            }
            return cell;
            break;
        }
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailPostVC_CellType  detailPostVC_CellType = indexPath.row;
    switch (detailPostVC_CellType) {
        case CommentsAndLikesCellType:
            return [MUSCommentsAndLikesCell heightForCommentsAndLikesCell: self.currentPost.arrayWithNetworkPosts];;
            break;
        case PostDescriptionCellType:
        {
            return [MUSPostDescriptionCell heightForPostDescriptionCell: self.currentPost.postDescription];
            break;
        }
        default:
            return [MUSPostLocationCell heightForPostLocationCell: self.currentPost];
            break;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString : MUSApp_SegueIdentifier_GoToMediaGalleryViewController]) {
        MUSMediaGalleryViewController *vc = [MUSMediaGalleryViewController new];
        vc = [segue destinationViewController];
        [vc sendPost:self.currentPost andSelectedImageIndex:self.indexPicTapped];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [self.headerView offsetDidUpdate:scrollView.contentOffset];
    }
}

#pragma mark - MEExpandableHeaderViewDelegate 

- (void) currentPageIndex:(NSInteger)currentIndex {
    _indexPicTapped = currentIndex;
    [self performSegueWithIdentifier: MUSApp_SegueIdentifier_GoToMediaGalleryViewController sender:nil];
}

#pragma mark - Share Post to Social network
- (void) sharePosts : (NSMutableArray*) arrayChosenNetworksForPost andFlagTwitter :(BOOL) flagTwitter {
    [self closePopUpForSharing];
    
    if (arrayChosenNetworksForPost) {
        __weak MUSDetailPostViewController *weakSelf = self;
        self.shareButton.enabled = NO;
        [[MultySharingManager sharedManager] sharePost: self.currentPost toSocialNetworks: arrayChosenNetworksForPost withComplition:^(id result, NSError *error) {

            [weakSelf.currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
            [weakSelf.tableView reloadData];

            for (NetworkPost *networkPost in weakSelf.currentPost.arrayWithNetworkPosts) {
                if (networkPost.reason != MUSConnect) {
                    weakSelf.shareButton.enabled = YES;
                } else {
                    [weakSelf.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
                    [weakSelf.navigationItem.rightBarButtonItem setEnabled:NO];
                }
            }
        } andProgressLoadingComplition:^(float result) {
#warning CHANGE METHOD - PROGRESS BAR SHOULD BE SINGLETON
            //[weakSelf.progressBar setProgressViewSize:result];
        }];
    }
}


@end