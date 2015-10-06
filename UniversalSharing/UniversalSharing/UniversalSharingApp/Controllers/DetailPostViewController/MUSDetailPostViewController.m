//
//  MUSDetailPostViewController.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostViewController.h"
#import "MUSGalleryOfPhotosCell.h"
#import "MUSCommentsAndLikesCell.h"
#import "MUSPostDescriptionCell.h"
#import "MUSPostLocationCell.h"
#import "ConstantsApp.h"
#import "MUSPhotoManager.h"
#import "MUSLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "UIImage+LoadImageFromDataBase.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "MUSDetailPostCollectionViewController.h"
//#import "SSARefreshControl.h"
#import "MUSUserDetailViewController.h"
#import "MEExpandableHeaderView.h"
#import "MUSPopUpForSharing.h"
#import "MUSProgressBar.h"
#import "MUSProgressBarEndLoading.h"

@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate,  UIActionSheetDelegate, UIAlertViewDelegate, MEExpandableHeaderViewDelegate, UIScrollViewDelegate, MUSPopUpForSharingDelegate>
/*!
 @abstract tableview frame size of the detail post
 */
@property (nonatomic, assign) CGRect tableViewFrame;
///*!
// @abstract social network of the current post
// */
@property (nonatomic, strong) SocialNetwork *currentSocialNetwork;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIBarButtonItem *shareButton;
/*!
 @abstract user of the current post
 */
@property (nonatomic, strong) User *currentUser;
/*!
 @abstract table view of detail post
 */
@property (nonatomic, strong) UITableView *tableView;
/*!
 @abstract number of rows in Detail Table View
 */
@property (nonatomic, assign) NSInteger numberOfRowsInTable;

@property (nonatomic, assign) NSInteger indexPicTapped;

@property (nonatomic, strong) NSIndexPath *postDescriptionCellIndexPath;

@property (nonatomic, strong) MEExpandableHeaderView *headerView;

@property (nonatomic, strong) MUSPopUpForSharing *popUpForSharing;

@property (strong, nonatomic)                MUSProgressBar * progressBar ;
@property (strong, nonatomic)                MUSProgressBarEndLoading * progressBarEndLoading ;


@end


@implementation MUSDetailPostViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self.currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
    [self initiationTableView];
    [self setupHeaderView];
    //[self initiationCurrentSocialNetwork];
    [self initiationNavigationBar];
    [self initiationActivityIndicator];
    [self initiationProgressBar];
    
    
    self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForUsersWithNetworkType: self.currentSocialNetwork.networkType]] firstObject];
    self.tableViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear : YES];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(showPhotosOnCollectionView :)
                                                 name : notificationShowImagesInCollectionView
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

#pragma mark - SetupHeaderForTableView

- (void)setupHeaderView
{
    ImageToPost *firstImage = [self.currentPost.arrayImages firstObject];
    
    if (!self.currentPost.arrayImages.count || !firstImage.image) {
        self.currentPost.arrayImages = nil;
    } else {
        NSMutableArray *arrayOfPagesForHeader = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.currentPost.arrayImages.count; i++) {
            [arrayOfPagesForHeader addObject: [self createPageViewWithText: [self.currentPost.arrayImages objectAtIndex: i]]];
        }
        CGSize headerViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 250);
        MEExpandableHeaderView *headerView = [[MEExpandableHeaderView alloc]
                                              initWithSize : headerViewSize
                                              backgroundImage : nil
                                              contentPages : arrayOfPagesForHeader];
        headerView.delegate = self;
        self.tableView.tableHeaderView = headerView;
        self.headerView = headerView;
    }
}

- (UIView*)createPageViewWithText:(ImageToPost*) imageToPost
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    imageView.image = imageToPost.image;
    imageView.clipsToBounds = YES;
    
    
    if (imageView.image.size.height < 250.0f || imageView.image.size.width <  [UIScreen mainScreen].bounds.size.width ) {
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
        if (currentNetworkPost.reason != Connect) {
            isPostConnect = NO;
        }
    }
    
    if (!isPostConnect && ![[MultySharingManager sharedManager] isPostInQueueOfPosts: self.currentPost.primaryKey]) {
        self.shareButton = [[UIBarButtonItem alloc] initWithTitle : musAppButtonTitle_Share style:2 target:self action: @selector(sendPost)];
        self.navigationItem.rightBarButtonItem = self.shareButton;
    }
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: musAppButtonTitle_Back style:2 target:self action: @selector(backToThePostsViewController)];
//    self.navigationItem.leftBarButtonItem = backButton;
//    self.title = self.currentSocialNetwork.name;
}

#pragma mark initiation CurrentSocialNetwork
/*!
 @method
 @abstract initiation Current social network
 */
//- (void) initiationCurrentSocialNetwork {
//    self.currentSocialNetwork = //[SocialNetwork sharedManagerWithType:self.currentPost.networkType];
//}

- (void) showPhotosOnCollectionView :(NSNotification *)notification{
    _indexPicTapped = [[[notification userInfo] objectForKey:@"index"] integerValue];
    [self performSegueWithIdentifier: @"goToDitailPostCollectionViewController" sender:nil];

}

#pragma mark  initiation Activity Indicator
/*!
 @method
 @abstract initiation activity indicator
 */
- (void) initiationActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
}

- (void) initiationProgressBar {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.progressBar = [[MUSProgressBar alloc]initWithFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight)];
    self.progressBarEndLoading = [[MUSProgressBarEndLoading alloc]initWithFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight)];
    self.progressBar.viewHeightConstraint.constant = 0;
    self.progressBarEndLoading.viewHeightConstraint.constant = 0;
}

#pragma mark  start Activity Indicator Animating
/*!
 @method
 @abstract start activity indicator animating
 */
- (void) startActivityIndicatorAnimating {
    self.activityIndicator.color = BROWN_COLOR_MIDLightHIGHT;
    [self.shareButton setCustomView : self.activityIndicator];
    [self.activityIndicator startAnimating];
    self.shareButton.enabled = NO;
}

#pragma mark  stop Activity Indicator Animating
/*!
 @method
 @abstract stop activity indicator animating
 */
- (void) stopActivityIndicatorAnimating {
    [self.activityIndicator stopAnimating];
    [self.shareButton setCustomView : nil];
    self.shareButton.enabled = YES;
}


#pragma mark SendPost
/*!
 @method
 @abstract send post to social network
 */
- (void) sendPost {
    self.popUpForSharing = [MUSPopUpForSharing new];
    self.popUpForSharing.arrayOfNetworksPost = self.currentPost.arrayWithNetworkPosts;
    self.popUpForSharing.delegate = self;
    [self.navigationController addChildViewController: self.popUpForSharing];
    self.popUpForSharing.view.frame = self.view.bounds;//CGRectMake(0, 100, 200, 200);//
    [self.navigationController.view addSubview: self.popUpForSharing.view];
    [self.popUpForSharing didMoveToParentViewController:self];
    [self.view endEditing:YES];
}


- (BOOL) isPostEmpty {
    if ([self.currentPost.postDescription isEqualToString:@""] && !self.currentPost.arrayImagesUrl.count) {
        [self showAlertWithMessage: musAppError_Empty_Post];
        self.view.userInteractionEnabled = YES;
        [self stopActivityIndicatorAnimating];
        return YES;
    }
    return NO;
}

#pragma mark BackToThePostsViewController
/*!
 @method
 @abstract back to the posts view controller
 */
- (void) backToThePostsViewController {
    // back to the Posts ViewController. If user did some changes in post - show alert. And then update post.
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musAppDetailPostVC_NumberOfRows;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPostVC_CellType detailPostVC_CellType = indexPath.row;
    
    switch (detailPostVC_CellType) {
        case CommentsAndLikesCellType: {
            MUSCommentsAndLikesCell *commentsAndLikesCell = (MUSCommentsAndLikesCell*) cell;
            commentsAndLikesCell.arrayWithNetworkPosts = self.currentPost.arrayWithNetworkPosts;
            [commentsAndLikesCell configurationCommentsAndLikesCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case PostDescriptionCellType: {
            MUSPostDescriptionCell *postDescriptionCell = (MUSPostDescriptionCell*) cell;
            postDescriptionCell.currentIndexPath = indexPath;
            [postDescriptionCell configurationPostDescriptionCell: self.currentPost.postDescription andNetworkType: self.currentSocialNetwork.networkType];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        default: {
            MUSPostLocationCell *postLocationCell = (MUSPostLocationCell*) cell;
            [postLocationCell configurationPostLocationCellByPostPlace: self.currentPost];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.arrayWithNetworkPosts = self.currentPost.arrayWithNetworkPosts;
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

#pragma mark - MUSPostLocationCellDelegate

- (void) changeLocationForPost {
    [self performSegueWithIdentifier: goToLocationViewControllerSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:goToLocationViewControllerSegueIdentifier]) {
        MUSLocationViewController *locationTableViewController = [MUSLocationViewController new];
        locationTableViewController = [segue destinationViewController];
        [locationTableViewController currentUser:_currentSocialNetwork];
        locationTableViewController.place = self.currentPost.place;
        __weak MUSDetailPostViewController *weakSelf = self;
        locationTableViewController.placeComplition = ^(Place* result, NSError *error) {
            /*
             back place object and we get id for network
             */
            if (result) {
                weakSelf.currentPost.place = result;
                [weakSelf.tableView reloadData];
            } else if (!result && !error) {
                weakSelf.currentPost.place = nil;
                [weakSelf.tableView reloadData];
            }

        };
    } else if ([[segue identifier]isEqualToString : @"goToDitailPostCollectionViewController"]) {
        MUSDetailPostCollectionViewController *vc = [MUSDetailPostCollectionViewController new];
        vc = [segue destinationViewController];
        [vc setObjectsWithPost: self.currentPost withCurrentSocialNetwork: self.currentSocialNetwork andIndexPicTapped: self.indexPicTapped];
    }
}

#pragma mark - error alert with error and alert with message

- (void) showErrorAlertWithError : (NSError*) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle : Error
                                                         message : [error localizedFailureReason]
                                                        delegate : nil
                                               cancelButtonTitle : musAppButtonTitle_OK
                                               otherButtonTitles : nil];
    [errorAlert show];
}

- (void) showAlertWithMessage : (NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle : musAppError_With_Domain_Universal_Sharing
                                                    message : message
                                                   delegate : nil
                                          cancelButtonTitle : musAppButtonTitle_OK
                                          otherButtonTitles : nil];
    [alert show];
}

- (void) showUpdateAlert  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle : musAppError_With_Domain_Universal_Sharing
                                                    message : musAppDetailPostVC_UpdatePostAlert
                                                   delegate : self
                                          cancelButtonTitle : musAppButtonTitle_Cancel
                                          otherButtonTitles : musAppButtonTitle_OK, nil];
    [alert show];
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
    [self performSegueWithIdentifier: @"goToDitailPostCollectionViewController" sender:nil];
}

#pragma mark - Share Post to Social network
- (void) sharePosts : (NSMutableArray*) arrayChosenNetworksForPost andFlagTwitter :(BOOL) flagTwitter {
    
    
    [self.tabBarController.view addSubview:self.progressBar.view];
    self.progressBar.progressView.progress = 0;
    [self.progressBar.viewWithPicsAndLable layoutIfNeeded];
    
    [self.popUpForSharing removeFromParentViewController];
    [self.popUpForSharing.view removeFromSuperview];
    self.popUpForSharing = nil;
    
    self.shareButton.enabled = NO;
    __weak MUSDetailPostViewController *weakSelf = self;
    
    
    weakSelf.progressBar.viewHeightConstraint.constant = 42;
    [UIView animateWithDuration:1 animations:^{
        
        [weakSelf.progressBar.viewWithPicsAndLable layoutIfNeeded];
    }];
    [UIView commitAnimations];
    
    [self.progressBar configurationProgressBar: nil :NO :0 :0];
    
    if (arrayChosenNetworksForPost) {
        
    [[MultySharingManager sharedManager] sharePost: self.currentPost toSocialNetworks: arrayChosenNetworksForPost withComplition:^(id result, NSError *error) {

        [weakSelf.currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];

        [weakSelf.tableView reloadData];

        for (NetworkPost *networkPost in weakSelf.currentPost.arrayWithNetworkPosts) {
            if (networkPost.reason != Connect) {
                weakSelf.shareButton.enabled = YES;
            } else {
                [weakSelf.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
                [weakSelf.navigationItem.rightBarButtonItem setEnabled:NO];
            }
            
            
            [weakSelf.progressBar.viewWithPicsAndLable layoutIfNeeded];
            
            weakSelf.progressBar.viewHeightConstraint.constant = 0;
            [UIView animateWithDuration:1 animations:^{
                
                [weakSelf.progressBar.viewWithPicsAndLable layoutIfNeeded];
            }];
            [UIView commitAnimations];
            
            [weakSelf.tabBarController.view addSubview:weakSelf.progressBarEndLoading.view];
            [weakSelf.progressBarEndLoading.viewWithPicsAndLable layoutIfNeeded];
            weakSelf.progressBarEndLoading.viewHeightConstraint.constant = 42;
            [UIView animateWithDuration:2 animations:^{
                [weakSelf.progressBarEndLoading.viewWithPicsAndLable layoutIfNeeded];
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [weakSelf.progressBar.view removeFromSuperview];
                    [weakSelf.progressBarEndLoading.view removeFromSuperview];
                    weakSelf.progressBarEndLoading.viewHeightConstraint.constant = 0;
                });
            }];
            [weakSelf.progressBarEndLoading configurationProgressBar: nil :[result intValue] :arrayChosenNetworksForPost.count];
 
            
            }
        } andComplitionProgressLoading:^(float result) {
            weakSelf.progressBar.progressView.progress = result;// arrayChosenNetworksForPost.count;
            //NSLog(@"result");
        }];
    }
}




@end
















//#pragma mark initiation current postDescription, arrayOfUsersPictures, postLocation
///*!
// @method
// @abstract initiation post description, array of pictures and location of the current post
// */
//- (void) initiationCurrentPostCopy {
//    
//    self.currentPostCopy = [self.currentPost copy];
//    self.currentPost.arrayImages = [[NSMutableArray alloc] init];
//    if (![[self.currentPost.arrayImagesUrl firstObject] isEqualToString: @""]) {
//        for (int i = 0; i < self.currentPost.arrayImagesUrl.count; i++) {
//            ImageToPost *currentImageToPost = [[ImageToPost alloc] init];
//            UIImage *image = [[UIImage alloc] init];
//            image = [image loadImageFromDataBase: [self.currentPost.arrayImagesUrl objectAtIndex: i]];
//            currentImageToPost.image = image;
//            currentImageToPost.imageType = JPEG;
//            currentImageToPost.quality = 1.0f;
//            [self.currentPost.arrayImages addObject: currentImageToPost];
//        }
//    }
//    self.currentPostCopy.arrayImages = [[NSMutableArray alloc] initWithArray: self.currentPost.arrayImages];
//    //    if (self.currentPostCopy.reason != Connect) {
//    //        self.isEditableTableView = YES;
//    //    }
//}







