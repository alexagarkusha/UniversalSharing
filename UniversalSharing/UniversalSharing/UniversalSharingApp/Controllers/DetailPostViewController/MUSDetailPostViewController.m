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
#import "SSARefreshControl.h"
#import "ReachabilityManager.h"
#import "MUSUserDetailViewController.h"

@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate, MUSPostDescriptionCellDelegate, MUSGalleryOfPhotosCellDelegate, MUSPostLocationCellDelegate,  UIActionSheetDelegate, UIAlertViewDelegate, SSARefreshControlDelegate, MUSCommentsAndLikesCellDelegate>
/*!
 @abstract flag of table view. User selects - table view is editable or not.
 */
@property (nonatomic, assign) BOOL isEditableTableView;
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

@property (nonatomic, strong) SSARefreshControl *refreshControl;

@property (nonatomic, strong) Post *currentPostCopy;

@end


@implementation MUSDetailPostViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self initiationCurrentPostCopy];
    [self initiationTableView];
    [self initiationCurrentSocialNetwork];
    [self initiationNavigationBar];
    [self initiationActivityIndicator];
    [self initiationSSARefreshControl];
    
    self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForUsersWithNetworkType: self.currentSocialNetwork.networkType]] firstObject];
    self.tableViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear : YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotosOnCollectionView :) name:notificationShowImagesInCollectionView object:nil];

    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardShow:)
                                                 name : UIKeyboardWillShowNotification
                                               object : nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillHide:)
                                                 name : UIKeyboardWillHideNotification
                                               object : nil];

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


- (void) obtainPosts {
    if (!self.isEditableTableView) {
        NSArray *thePost = [[NSMutableArray alloc] initWithArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForPostWithPostId: self.currentPost.postID]]];
        self.currentPost = [thePost firstObject];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
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

#pragma mark initiation UINavigationBar
/*!
 @method
 @abstract initiation Navigation Bar
 */
- (void) initiationNavigationBar {
    if (self.isEditableTableView) {
        self.shareButton = [[UIBarButtonItem alloc] initWithTitle : musAppButtonTitle_Share style:2 target:self action: @selector(sendPost)];
        self.navigationItem.rightBarButtonItem = self.shareButton;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: musAppButtonTitle_Back style:2 target:self action: @selector(backToThePostsViewController)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = self.currentSocialNetwork.name;
}

#pragma mark initiation CurrentSocialNetwork
/*!
 @method
 @abstract initiation Current social network
 */
- (void) initiationCurrentSocialNetwork {
    self.currentSocialNetwork = [SocialNetwork sharedManagerWithType:self.currentPost.networkType];
}


- (void) showPhotosOnCollectionView :(NSNotification *)notification{
    _indexPicTapped = [[[notification userInfo] objectForKey:@"index"] integerValue];
    [self performSegueWithIdentifier: @"goToDitailPostCollectionViewController" sender:nil];

}
#pragma mark initiation current postDescription, arrayOfUsersPictures, postLocation
/*!
 @method
 @abstract initiation post description, array of pictures and location of the current post
 */
- (void) initiationCurrentPostCopy {
    
    self.currentPostCopy = [self.currentPost copy];
    self.currentPost.arrayImages = [[NSMutableArray alloc] init];
    if (![[self.currentPost.arrayImagesUrl firstObject] isEqualToString: @""]) {
        for (int i = 0; i < self.currentPost.arrayImagesUrl.count; i++) {
            UIImage *currentImage = [[UIImage alloc] init];
            currentImage = [currentImage loadImageFromDataBase: [self.currentPost.arrayImagesUrl objectAtIndex: i]];
            [self.currentPost.arrayImages addObject: currentImage];
        }
    }
    self.currentPostCopy.arrayImages = [[NSMutableArray alloc] initWithArray: self.currentPost.arrayImages];
    
    
    
//    if ((!self.currentPostCopy.place.longitude.length > 0 && !self.currentPost.place.latitude.length > 0) || ([self.currentPostCopy.place.longitude isEqualToString: @"(null)"] || [self.currentPostCopy.place.longitude isEqualToString: @"(null)"])) {
//        self.currentPostCopy.place = nil;
//        self.currentPost.place = nil;
//    }
//
    if (self.currentPostCopy.reason != Connect) {
        self.isEditableTableView = YES;
    }
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

#pragma mark - initiation SSARefreshControl

- (void) initiationSSARefreshControl {
    self.refreshControl = [[SSARefreshControl alloc] initWithScrollView:self.tableView andRefreshViewLayerType:SSARefreshViewLayerTypeOnScrollView];
    self.refreshControl.delegate = self;
}

#pragma mark  start Activity Indicator Animating
/*!
 @method
 @abstract start activity indicator animating
 */
- (void) startActivityIndicatorAnimating {
    self.activityIndicator.color = [UIColor blueColor];
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


#pragma mark SentPost
/*!
 @method
 @abstract send post to social network
 */
- (void) sendPost {
    if (!_currentSocialNetwork.isVisible || !_currentSocialNetwork) {
        [self showAlertWithMessage: musAppError_Logged_Into_Social_Networks];
        return;
    }
    self.isEditableTableView = NO;
    [self.tableView reloadData];
    [self.delegate updatePostByPrimaryKey: [NSString stringWithFormat: @"%ld", (long)self.currentPost.primaryKey]];
    [self startActivityIndicatorAnimating];
    [self updatePost: self.currentPost];
    __weak MUSDetailPostViewController *weakSelf = self;
    [_currentSocialNetwork sharePost: self.currentPost withComplition:^(id result, NSError *error) {
        if (!error) {
            [self showAlertWithMessage : titleCongratulatoryAlert];
            weakSelf.isEditableTableView = NO;
            [weakSelf stopActivityIndicatorAnimating];
            weakSelf.navigationItem.rightBarButtonItem = nil;
            weakSelf.currentPost = [weakSelf.currentPostCopy copy];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf showErrorAlertWithError : error];
            weakSelf.isEditableTableView = YES;
            [weakSelf stopActivityIndicatorAnimating];
            weakSelf.currentPost = [weakSelf.currentPostCopy copy];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark BackToThePostsViewController
/*!
 @method
 @abstract back to the posts view controller
 */
- (void) backToThePostsViewController {
    // back to the Posts ViewController. If user did some changes in post - show alert. And then update post.
    if ((![self checkForChangesInTheArrayOfimagesInPost] || (self.currentPost.postDescription != self.currentPostCopy.postDescription) || (self.currentPost.place.placeID != self.currentPostCopy.place.placeID)) && self.isEditableTableView ) {
        [self showUpdateAlert];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
 }

- (BOOL) checkForChangesInTheArrayOfimagesInPost {
    BOOL isEqualArray = YES;
    if (self.currentPost.arrayImages.count != self.currentPostCopy.arrayImages.count) {
        return NO;
    } else {
        for (int i = 0; i < self.currentPostCopy.arrayImages.count; i ++) {
            if ([self.currentPostCopy.arrayImages objectAtIndex: i] != [self.currentPost.   arrayImages objectAtIndex: i]) {
                return NO;
            } else {
                isEqualArray = YES;
            }
        }
    }
    return isEqualArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musAppDetailPostVC_NumberOfRows;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPostVC_CellType detailPostVC_CellType = indexPath.row;
    
    switch (detailPostVC_CellType) {
        case GalleryOfPhotosCellType: {
            MUSGalleryOfPhotosCell *galleryOfPhotosCell = (MUSGalleryOfPhotosCell*) cell;
            galleryOfPhotosCell.delegate = self;
            galleryOfPhotosCell.isEditableCell = self.isEditableTableView;
            [galleryOfPhotosCell configurationGalleryOfPhotosCellByArrayOfImages : self.currentPostCopy.arrayImages];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case CommentsAndLikesCellType: {
            MUSCommentsAndLikesCell *commentsAndLikesCell = (MUSCommentsAndLikesCell*) cell;
            [commentsAndLikesCell configurationCommentsAndLikesCellByPost:self.currentPost socialNetworkIconName:self.currentSocialNetwork.icon andUser: self.currentUser];
            commentsAndLikesCell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case PostDescriptionCellType: {
            MUSPostDescriptionCell *postDescriptionCell = (MUSPostDescriptionCell*) cell;
            postDescriptionCell.delegate = self;
            postDescriptionCell.isEditableCell = self.isEditableTableView;
            postDescriptionCell.currentIndexPath = indexPath;
            [postDescriptionCell configurationPostDescriptionCell: self.currentPostCopy.postDescription andNetworkType: self.currentSocialNetwork.networkType];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        default: {
            MUSPostLocationCell *postLocationCell = (MUSPostLocationCell*) cell;
            postLocationCell.isEditableCell = self.isEditableTableView;
            postLocationCell.delegate = self;
            postLocationCell.isEditableCell = self.isEditableTableView;
            [postLocationCell configurationPostLocationCellByPostPlace: self.currentPostCopy.place];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPostVC_CellType detailPostVC_CellType = indexPath.row;
    switch (detailPostVC_CellType) {
        case GalleryOfPhotosCellType: {
            MUSGalleryOfPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSGalleryOfPhotosCell cellID]];
            if(!cell) {
                cell = [MUSGalleryOfPhotosCell galleryOfPhotosCell];
            }
            return cell;
            break;
        }
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
        case GalleryOfPhotosCellType:
            return [MUSGalleryOfPhotosCell heightForGalleryOfPhotosCell: self.currentPostCopy.arrayImages.count andIsEditableCell : self.isEditableTableView];
            break;
        case CommentsAndLikesCellType:
            return [MUSCommentsAndLikesCell heightForCommentsAndLikesCell];;
            break;
        case PostDescriptionCellType:
        {
            CGFloat heightOfPostDescriptionRow = [MUSPostDescriptionCell heightForPostDescriptionCell: self.currentPostCopy.postDescription andIsEditableCell: self.isEditableTableView];
            if (heightOfPostDescriptionRow < 100 && self.isEditableTableView) {
                heightOfPostDescriptionRow = 100;
            }
            return heightOfPostDescriptionRow;
            break;
        }
        default:
            return [MUSPostLocationCell heightForPostLocationCell: self.currentPostCopy.place andIsEditableCell: self.isEditableTableView];
            break;
    }
}

#pragma mark - MUSPostLocationCellDelegate

- (void) changeLocationForPost {
    //[self performSegueWithIdentifier:@"go" sender:nil];
    
    [self performSegueWithIdentifier: goToLocationViewControllerSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:goToLocationViewControllerSegueIdentifier]) {
        MUSLocationViewController *locationTableViewController = [MUSLocationViewController new];
        locationTableViewController = [segue destinationViewController];
        [locationTableViewController currentUser:_currentSocialNetwork];
        locationTableViewController.place = self.currentPostCopy.place;
        __weak MUSDetailPostViewController *weakSelf = self;
        locationTableViewController.placeComplition = ^(Place* result, NSError *error) {
            /*
             back place object and we get id for network
             */
            if (result) {
                weakSelf.currentPostCopy.place = result;
                [weakSelf.tableView reloadData];
            }
        };
    } else if ([[segue identifier]isEqualToString : @"goToDitailPostCollectionViewController"]) {
        MUSDetailPostCollectionViewController *vc = [MUSDetailPostCollectionViewController new];
        vc = [segue destinationViewController];
        [vc setObjectsWithPost:self.currentPostCopy andCurrentSocialNetwork:_currentSocialNetwork andIndexPicTapped:self.indexPicTapped];
        
    } else if ([[segue identifier]isEqualToString : goToUserDetailViewControllerSegueIdentifier]) {
        MUSUserDetailViewController *userDetailViewController = [MUSUserDetailViewController new];
        userDetailViewController = [segue destinationViewController];
        userDetailViewController.isLogoutButtonHide = YES;
        [userDetailViewController setNetwork: self.currentSocialNetwork];
    }
    
}


#pragma mark - MUSPostDescriptionCellDelegate

- (void) saveChangesInPostDescription:(NSString *)postDescription {
    self.currentPostCopy.postDescription = postDescription;
    [self.tableView reloadData];
}

- (void) beginEditingPostDescription:(NSIndexPath *)currentIndexPath {
    [self performSelector:@selector(scrollToCell:) withObject: currentIndexPath afterDelay:0.5f];
}
/*!
 @method
 @abstract scroll table view to the current cell
 @param current index path of cell
 */
-(void) scrollToCell:(NSIndexPath*) path {
    [_tableView scrollToRowAtIndexPath:path atScrollPosition : UITableViewScrollPositionNone animated:YES];
}

#pragma mark - MUSGalleryOfPhotosCellDelegate

- (void) editArrayOfPicturesInPost: (NSArray *)arrayOfImages {
    if (!arrayOfImages.firstObject) {
        [self.currentPostCopy.arrayImages removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    self.currentPostCopy.arrayImages = [NSMutableArray arrayWithArray: arrayOfImages];
}

- (void) showImagePicker {
    if ([self.currentPostCopy.arrayImages count] == countOfAllowedPics) {
        [self showAlertWithMessage : musAppAlertTitle_NO_Pics_Anymore];
        return;
    }
    __weak MUSDetailPostViewController *weakSelf = self;
    [[MUSPhotoManager sharedManager] photoShowFromViewController:self withComplition:^(id result, NSError *error) {
        if(!error) {
            ImageToPost *imageToPost = result;
            [weakSelf.currentPostCopy.arrayImages addObject: imageToPost.image];//////////////////////////////////////////////////
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf showErrorAlertWithError : error];
            return;
        }
    }];
}


#pragma mark - Keyboard Show/Hide
/*!
 @method
 @abstract scroll table view to the current cell
 @param current index path of cell
 */
-(void) keyboardShow:(NSNotification*) notification {
    
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    CGRect tvFrame = _tableView.frame;
    tvFrame.size.height = convertedFrame.origin.y - self.tabBarController.tabBar.frame.size.height - 14;
    _tableView.frame = tvFrame;
    
}

- (void) keyboardWillHide: (NSNotification*) notification {
    self.tableView.frame = CGRectMake(self.tableViewFrame.origin.x, self.tableViewFrame.origin.y, self.tableViewFrame.size.width, self.tableViewFrame.size.height);
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle : musErrorWithDomainUniversalSharing
                                                    message : message
                                                   delegate : nil
                                          cancelButtonTitle : musAppButtonTitle_OK
                                          otherButtonTitles : nil];
    [alert show];
}

- (void) showUpdateAlert  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle : musErrorWithDomainUniversalSharing
                                                    message : musAppDetailPostVC_UpdatePostAlert
                                                   delegate : self
                                          cancelButtonTitle : musAppButtonTitle_Cancel
                                          otherButtonTitles : musAppButtonTitle_OK, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case YES:
            [self updatePost: self.currentPost];
            [self updatePostInDataBase];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

#pragma mark UpdatePost

- (void) updatePost : (Post*) postForUpdating {
    [self updateCurrentPost];
    [self deletePostImagesFromDocumentsFolder: self.currentPost];
    [self saveImageToDocumentsFolderAndFillArrayWithUrl : self.currentPost];
}

- (void) updateCurrentPost {
    
    
    if (![self.currentPostCopy.postDescription isEqualToString: kPlaceholderText]) {
        self.currentPost.postDescription = self.currentPostCopy.postDescription;
    } else {
        self.currentPost.postDescription = @"";
    }
    
    if (self.currentPostCopy.place) {
        self.currentPost.place = [self.currentPostCopy.place copy];
    }
    
    self.currentPost.arrayImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.currentPostCopy.arrayImages.count; i++) {
        ImageToPost *imageToPost = [[ImageToPost alloc] init];
        imageToPost.image = [self.currentPostCopy.arrayImages objectAtIndex: i];
        imageToPost.quality = 1.0f;
        imageToPost.imageType = JPEG;
        [self.currentPost.arrayImages addObject: imageToPost];
    }
}

- (void) saveImageToDocumentsFolderAndFillArrayWithUrl :(Post*) post {
    if (!post.arrayImagesUrl) {
        post.arrayImagesUrl = [NSMutableArray new];
    } else {
        [post.arrayImagesUrl removeAllObjects];
    }
    [post.arrayImages enumerateObjectsUsingBlock:^(ImageToPost *image, NSUInteger index, BOOL *stop) {
        NSData *data = UIImagePNGRepresentation(image.image);
        //Get the docs directory
        NSString *filePath = @"image";
        filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]];
        filePath = [filePath stringByAppendingString:@".png"];
        [post.arrayImagesUrl addObject:filePath];
        [data writeToFile:[filePath obtainPathToDocumentsFolder:filePath] atomically:YES]; //Write the file
        
    }];
}

- (void) deletePostImagesFromDocumentsFolder : (Post*) post {
    if (![[post.arrayImagesUrl firstObject] isEqualToString: @""] && post.arrayImagesUrl.count > 0) {
        __block NSError *error;
        [post.arrayImagesUrl enumerateObjectsUsingBlock:^(NSString *urlImage, NSUInteger idx, BOOL *stop) {
            [[NSFileManager defaultManager] removeItemAtPath: [urlImage obtainPathToDocumentsFolder: urlImage] error: &error];
        }];
    }
}

- (void) updatePostInDataBase {
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringLocationsForUpdateWithObjectPost: self.currentPost]];
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringPostsForUpdateWithObjectPost: self.currentPost]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SSARefreshControlDelegate

- (void) beganRefreshing {
    if (![self obtainCurrentConnection]) {
        [self.refreshControl endRefreshing];
        return;
    }
    [self.currentSocialNetwork updatePost];
}

#pragma mark - Check InternetConnection

- (BOOL) obtainCurrentConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    
    if (!isReachableViaWiFi && !isReachable){
        return NO;
    }
    return YES;
}

#pragma mark - MUSCommentsAndLikesCellDelegate 

- (void) showUserProfile {
    [self performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
}

@end
