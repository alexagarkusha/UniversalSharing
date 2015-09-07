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
#import "MUSLocationTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "UIImage+LoadImageFromDataBase.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "MUSDitailPostCollectionViewController.h"
#import "MUSGalleryViewOfPhotos.h"


@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate, MUSPostDescriptionCellDelegate, MUSGalleryOfPhotosCellDelegate, MUSPostLocationCellDelegate,  UIActionSheetDelegate, UIAlertViewDelegate>
/*!
 @abstract flag of table view. User selects - table view is editable or not.
 */
@property (nonatomic, assign) BOOL isEditableTableView;
/*!
 @abstract tableview frame size of the detail post
*/
@property (nonatomic, assign) CGRect tableViewFrame;
/*!
 @abstract array of pictures in current post
 */
@property (nonatomic, strong) NSMutableArray *arrayOfPicturesInPost;
/*!
 @abstract description of the current post
 */
@property (nonatomic, strong) NSString *postDescription;
/*!
 @abstract place of the current post
 */
@property (nonatomic, strong) Place *postPlace;
/*!
 @abstract social network of the current post
 */
@property (nonatomic, strong) SocialNetwork *currentSocialNetwork;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIBarButtonItem *actionBarButton;
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

@end


@implementation MUSDetailPostViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotosOnCollectionView :) name:notificationShowImagesInCollectionView object:nil];
    ////////////////////////////////////////////////////////////////////////////
       // Do any additional setup after loading the view.
    [self initiationPostDescriptionArrayOfPicturesAndPostLocation];
    [self initiationTableView];
    [self initiationCurrentSocialNetwork];
    [self initiationNavigationBar];
    [self initiationActivityIndicator];
    
    self.currentUser = [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForUsersWithNetworkType: self.currentSocialNetwork.networkType]] firstObject];
    self.tableViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardShow:)
                                                 name : UIKeyboardWillShowNotification
                                               object : nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillHide:)
                                                 name : UIKeyboardWillHideNotification
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

#pragma mark initiation UINavigationBar
/*!
 @method
 @abstract initiation Navigation Bar
 */
- (void) initiationNavigationBar {
    if (self.isEditableTableView) {
        
    }
    
    
    
    
    ///////////////////////////// ????????????? /////////////////////////////////
#warning DELETE ACTION SHEET
    /*
    ReasonType currentReasonType = self.currentPost.reason;
    if (currentReasonType == Offline || currentReasonType == ErrorConnection) {
        self.actionBarButton = [[UIBarButtonItem alloc] initWithTitle : musAppButtonTitle_Action style:2 target:self action: @selector(showActionSheet)];
        self.navigationItem.rightBarButtonItem = self.actionBarButton;
    }
    */
    ///////////////////////////// ????????????? /////////////////////////////////

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: musAppButtonTitle_Back style:2 target:self action: @selector(backToThePostsViewController)];
    self.navigationItem.leftBarButtonItem = backButton;
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
    NSArray  *theArray = [[notification userInfo] objectForKey:@"arrayOfPhotos"];
    [self performSegueWithIdentifier: @"goToDitailPostCollectionViewController" sender:nil];

}
#pragma mark initiation current postDescription, arrayOfUsersPictures, postLocation
/*!
 @method
 @abstract initiation post description, array of pictures and location of the current post
 */
- (void) initiationPostDescriptionArrayOfPicturesAndPostLocation {
    self.arrayOfPicturesInPost = [[NSMutableArray alloc] init];
    if (![[self.currentPost.arrayImagesUrl firstObject] isEqualToString: @""]) {
        for (int i = 0; i < self.currentPost.arrayImagesUrl.count; i++) {
            UIImage *currentImage = [[UIImage alloc] init];
            currentImage = [currentImage loadImageFromDataBase: [self.currentPost.arrayImagesUrl objectAtIndex: i]];
            [self.arrayOfPicturesInPost addObject: currentImage];
        }
    }
    
    self.postDescription = self.currentPost.postDescription;
    
    if (self.currentPost.place.longitude.length > 0 && self.currentPost.place.latitude.length > 0) {
        self.postPlace = self.currentPost.place;
    }
    
    if (self.currentPost.reason != Connect) {
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
    self.activityIndicator.center=self.view.center;
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
}

#pragma mark  start Activity Indicator Animating
/*!
 @method
 @abstract start activity indicator animating
 */
- (void) startActivityIndicatorAnimating {
    [self.activityIndicator startAnimating];
    self.actionBarButton.enabled = NO;
}

#pragma mark  stop Activity Indicator Animating
/*!
 @method
 @abstract stop activity indicator animating
 */
- (void) stopActivityIndicatorAnimating {
    [self.activityIndicator stopAnimating];
    self.actionBarButton.enabled = YES;
}



///////////////////////////// ????????????? /////////////////////////////////
#warning DELETE ACTION SHEET

#pragma mark UIActionSheet
/*!
 @method
 @abstract show Action sheet with buttons : Share post, Edit post and Cancel
 */
/*
- (void) showActionSheet {
    UIActionSheet* sheet = [[UIActionSheet alloc] init];
    sheet.title = titleActionSheet;
    sheet.delegate = self;
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:musAppButtonTitle_Cancel];
    NSArray *arrayButtons = [[NSArray alloc] initWithObjects: musAppButtonTitle_Share, musAppButtonTitle_Edit, nil];
    for (int i = 0; i < arrayButtons.count; i++) {
        [sheet addButtonWithTitle: [arrayButtons objectAtIndex: i]];
    }
    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != 0 ) {
        if (buttonIndex == 1) {
            [self sendPost];
        } else {
            self.isEditableTableView = YES;
            [self.tableView reloadData];
        }
    }
}
*/
///////////////////////////// ????????????? /////////////////////////////////



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
    [self startActivityIndicatorAnimating];
    [self updatePost: self.currentPost];
    __weak MUSDetailPostViewController *weakSelf = self;
    [_currentSocialNetwork sharePost: self.currentPost withComplition:^(id result, NSError *error) {
        if (!error) {
            [self showAlertWithMessage : titleCongratulatoryAlert];
            weakSelf.isEditableTableView = NO;
            [weakSelf stopActivityIndicatorAnimating];
            self.navigationItem.rightBarButtonItem = nil;
            [weakSelf.tableView reloadData];
        } else {
            [self showErrorAlertWithError : error];
            weakSelf.isEditableTableView = NO;
            [weakSelf stopActivityIndicatorAnimating];
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
    if (self.isEditableTableView) {
        [self showUpdateAlert];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musAppDetailPostVC_NumberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPostVC_CellType detailPostVC_CellType = indexPath.row;
    switch (detailPostVC_CellType) {
        case GalleryOfPhotosCellType: {
            MUSGalleryOfPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSGalleryOfPhotosCell cellID]];
            if(!cell) {
                cell = [MUSGalleryOfPhotosCell galleryOfPhotosCell];
            }            
            cell.delegate = self;
           
            cell.isEditableCell = self.isEditableTableView;
            [cell configurationGalleryOfPhotosCellByArrayOfImages : self.arrayOfPicturesInPost
                                                andDateCreatePost : self.currentPost.dateCreate
                                                 withReasonOfPost : self.currentPost.reason
                                     andWithSocialNetworkIconName : self.currentSocialNetwork.icon
                                                          andUser : self.currentUser];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case CommentsAndLikesCellType: {
            MUSCommentsAndLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSCommentsAndLikesCell cellID]];
            if(!cell) {
                cell = [MUSCommentsAndLikesCell commentsAndLikesCell];
            }
            [cell configurationCommentsAndLikesCellByPost: self.currentPost];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case PostDescriptionCellType: {
            MUSPostDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostDescriptionCell cellID]];
            if(!cell) {
                cell = [MUSPostDescriptionCell postDescriptionCell];
            }
            cell.delegate = self;
            cell.isEditableCell = self.isEditableTableView;
            cell.currentIndexPath = indexPath;
            [cell configurationPostDescriptionCell: self.postDescription andNetworkType: self.currentSocialNetwork.networkType];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        default: {
            MUSPostLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostLocationCell cellID]];
            if(!cell) {
                cell = [MUSPostLocationCell postLocationCell];
            }
            cell.isEditableCell = self.isEditableTableView;
            cell.delegate = self;
            cell.isEditableCell = self.isEditableTableView;
            [cell configurationPostLocationCellByPostPlace: self.postPlace];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            return [MUSGalleryOfPhotosCell heightForGalleryOfPhotosCell: self.arrayOfPicturesInPost.count andIsEditableCell : self.isEditableTableView];
            break;
        case CommentsAndLikesCellType:
            return [MUSCommentsAndLikesCell heightForCommentsAndLikesCell];;
            break;
        case PostDescriptionCellType:
        {
            CGFloat heightOfPostDescriptionRow = [MUSPostDescriptionCell heightForPostDescriptionCell: self.postDescription andIsEditableCell: self.isEditableTableView];
            //[MUSPostDescriptionCell heightForPostDescriptionCell: self.postDescription];
            if (heightOfPostDescriptionRow < 100 && self.isEditableTableView) {
                heightOfPostDescriptionRow = 100;
            }
            NSLog(@"POST DESCRIPTION CELL HEIGHT = %f", heightOfPostDescriptionRow);
            return heightOfPostDescriptionRow;
            break;
        }
        default:
            
            return [MUSPostLocationCell heightForPostLocationCell: self.postPlace andIsEditableCell: self.isEditableTableView];
            break;
    }
}

#pragma mark - MUSPostLocationCellDelegate

- (void) changeLocationForPost {
    [self performSegueWithIdentifier: goToLocationViewControllerSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSLocationTableViewController *locationTableViewController = [MUSLocationTableViewController new];
    if ([[segue identifier] isEqualToString:goToLocationViewControllerSegueIdentifier]) {
        locationTableViewController = [segue destinationViewController];
        [locationTableViewController setCurrentUser:_currentSocialNetwork];
        __weak MUSDetailPostViewController *weakSelf = self;
        locationTableViewController.placeComplition = ^(Place* result, NSError *error) {
            /*
             back place object and we get id for network
             */
            if (result) {
                weakSelf.postPlace = result;
                [weakSelf.tableView reloadData];
            }
        };
    } else if ([[segue identifier]isEqualToString : @"goToDitailPostCollectionViewController"]) {
                   MUSDitailPostCollectionViewController *vc = [MUSDitailPostCollectionViewController new];

        vc = [segue destinationViewController];
        //[vc setNetwork:self.arrayWithNetworksObj[self.selectedIndexPath.row]];
        }
    
}


#pragma mark - MUSPostDescriptionCellDelegate

- (void) saveChangesInPostDescription:(NSString *)postDescription {
    self.postDescription = postDescription;
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
        [self.arrayOfPicturesInPost removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    self.arrayOfPicturesInPost = [NSMutableArray arrayWithArray: arrayOfImages];
}

- (void) showImagePicker {
    if ([self.arrayOfPicturesInPost count] == countOfAllowedPics) {
        [self showAlertWithMessage : musAppAlertTitle_NO_Pics_Anymore];
        return;
    }
    __weak MUSDetailPostViewController *weakSelf = self;
    [[MUSPhotoManager sharedManager] photoShowFromViewController:self withComplition:^(id result, NSError *error) {
        if(!error) {
            ImageToPost *imageToPost = result;
            [weakSelf.arrayOfPicturesInPost addObject: imageToPost.image];
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
    tvFrame.size.height = convertedFrame.origin.y - self.tabBarController.tabBar.frame.size.height - 16;
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
    if (![self.postDescription isEqualToString: kPlaceholderText]) {
        self.currentPost.postDescription = self.postDescription;
    } else {
        self.currentPost.postDescription = @"";
    }
    
    if (self.postPlace) {
        self.currentPost.place = self.postPlace;
    }
    
    NSMutableArray *arrayOfImagesToPost = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.arrayOfPicturesInPost.count; i++) {
        ImageToPost *imageToPost = [[ImageToPost alloc] init];
        imageToPost.image = [self.arrayOfPicturesInPost objectAtIndex: i];
        imageToPost.quality = 0.8f;
        imageToPost.imageType = JPEG;
        [arrayOfImagesToPost addObject: imageToPost];
    }
    self.currentPost.arrayImages = [NSArray arrayWithArray : arrayOfImagesToPost];
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
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringPostsForUpdateWithObjectPost: self.currentPost]];
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringLocationsForUpdateWithObjectPost: self.currentPost]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
