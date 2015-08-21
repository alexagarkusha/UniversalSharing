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

#import "ReachabilityManager.h" ///////////// REMOVE THIS after addition to the SOCIAL NETWORK LIBRARY ////////////


@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate, MUSPostDescriptionCellDelegate, MUSGalleryOfPhotosCellDelegate, MUSPostLocationCellDelegate,  UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) DetailPostVC_CellType detailPostVC_CellType;

@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSMutableArray *arrayOfUsersPictures;
@property (nonatomic, assign) CGRect tableViewFrame;
@property (nonatomic, strong) SocialNetwork *currentSocialNetwork;

@property (nonatomic, assign) CGFloat heightOfGalleryWithPhotosRow;
@property (nonatomic, assign) CGFloat heightOfCommentsAndLikeRow;
@property (nonatomic, assign) CGFloat heightOfPostDescriptionRow;
@property (nonatomic, assign) CGFloat heightOfPostLocationRow;

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocationOfPost;

@property (nonatomic, assign) BOOL isEditableTableView;


@end


@implementation MUSDetailPostViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self initiationTableView];
    [self initiationNavigationBar];
    [self initiationCurrentSocialNetwork];
    [self initiationPostDescriptionArraOfPicturesAndPostLocation];
    self.tableViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillShow:)
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
    self.isEditableTableView = NO;
}

#pragma mark initiation UINavigationBar

- (void) initiationNavigationBar {
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle : @"Action" style:2 target:self action: @selector(showActionSheet)];
    self.navigationItem.rightBarButtonItem = actionButton;
}

#pragma mark initiation CurrentSocialNetwork

- (void) initiationCurrentSocialNetwork {
    self.currentSocialNetwork = [SocialNetwork sharedManagerWithType:self.currentPost.networkType];
}

#pragma mark initiation current postDescription, arrayOfUsersPictures, postLocation

- (void) initiationPostDescriptionArraOfPicturesAndPostLocation {
    self.arrayOfUsersPictures = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.currentPost.arrayImages.count; i++) {
        ImageToPost *imageToPost = [self.currentPost.arrayImages objectAtIndex: i];
        [self.arrayOfUsersPictures addObject: imageToPost.image];
    }
    self.postDescription = self.currentPost.postDescription;
    //self.currentLocationOfPost = CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)
}

#pragma mark UIActionSheet

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
            NSLog(@"POST");
        } else {
            //NSLog(@"EDIT");
            self.isEditableTableView = YES;
            [self.tableView reloadData];
        }
    }
}


///////////// REMOVE THIS after addition to the SOCIAL NETWORK LIBRARY ////////////

- (void) sharePost : (Post*) post {
    if (![self checkStatusOftheNetworkConnection] || ![self checkStatusOfSocialNetworkVisibility]) {
        return;
    }
    
    if(!post) {
        post = [[Post alloc] init];
    }
    
    post.placeID = self.placeID;
    if (![self.postDescription isEqualToString: kPlaceholderText]) {
        post.postDescription = self.postDescription;
    } else {
        post.postDescription = @"";
    }
    /*
     get array with chosen images from MUSGaleryView
     */
    self.currentPost.arrayImages = self.arrayOfUsersPictures;
    [_currentSocialNetwork sharePost: self.currentPost withComplition:^(id result, NSError *error) {
        if (!error) {
            [self showAlertWithMessage : titleCongratulatoryAlert];
        } else {
            [self showErrorAlertWithError : error];
        }
    }];
}

- (BOOL) checkStatusOftheNetworkConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    
    if (!isReachableViaWiFi && !isReachable) {
        [self showAlertWithMessage: musAppError_Internet_Connection];
        return NO;
    }
    return YES;
}

- (BOOL) checkStatusOfSocialNetworkVisibility {
    if (!_currentSocialNetwork.isVisible || !_currentSocialNetwork.isLogin) {
        [self showAlertWithMessage: musAppError_Logged_Into_Social_Networks];
        return NO;
    }
    return YES;
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
                                                   delegate : self
                                          cancelButtonTitle : musAppButtonTitle_OK
                                          otherButtonTitles : nil];
    [alert show];
}


///////////// /////////////////////////////////////////////////////////// ////////////


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    self.detailPostVC_CellType = indexPath.row;
    switch (self.detailPostVC_CellType) {
        case GalleryOfPhotosCellType: {
            MUSGalleryOfPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSGalleryOfPhotosCell cellID]];
            if(!cell) {
                cell = [MUSGalleryOfPhotosCell galleryOfPhotosCell];
            }
            cell.delegate = self;
            cell.isEditableCell = self.isEditableTableView;
            [cell configurationGalleryOfPhotosCellByArrayOfImages: self.arrayOfUsersPictures andUser: self.currentUser];
            [cell needsUpdateConstraints];
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
            [cell configurationPostDescriptionCell: self.postDescription];
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
            [cell configurationPostLocationCellByPost: self.currentPost];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailPostVC_CellType = indexPath.row;
    switch (self.detailPostVC_CellType) {
        case GalleryOfPhotosCellType:
            self.heightOfGalleryWithPhotosRow =  [MUSGalleryOfPhotosCell heightForGalleryOfPhotosCell: self.arrayOfUsersPictures.count];
            return self.heightOfGalleryWithPhotosRow;
            break;
        case CommentsAndLikesCellType:
            self.heightOfCommentsAndLikeRow = [MUSCommentsAndLikesCell heightForCommentsAndLikesCell];
            return self.heightOfCommentsAndLikeRow;
            break;
        case PostDescriptionCellType:
            self.heightOfPostDescriptionRow = [MUSPostDescriptionCell heightForPostDescriptionCell: self.postDescription];
            if (self.heightOfPostDescriptionRow < 100 && self.isEditableTableView) {
                self.heightOfPostDescriptionRow = 100;
            }
            return self.heightOfPostDescriptionRow;
            break;
        default:
            self.heightOfPostLocationRow = [MUSPostLocationCell heightForPostLocationCell];
            return self.heightOfPostLocationRow;
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
                weakSelf.placeID = result.placeID;
                weakSelf.placeName = result.fullName;
            }
        };
    }
}

#pragma mark - MUSPostDescriptionCellDelegate

- (void) saveChangesInPostDescription:(NSString *)postDescription {
    self.postDescription = postDescription;
    [self.tableView reloadData];
}

#pragma mark - MUSGalleryOfPhotosCellDelegate

- (void) arrayOfImagesOfUser:(NSArray *)arrayOfImages {
    
    if (!arrayOfImages.firstObject) {
        self.arrayOfUsersPictures = nil;
        [self.tableView reloadData];
        return;
    }
    self.arrayOfUsersPictures = [NSMutableArray arrayWithArray: arrayOfImages];
}

- (void) showImagePicker {
    if ([self.arrayOfUsersPictures count] == countOfAllowedPics) {
        [self showAlertWithMessage : musAppAlertTitle_NO_Pics_Anymore];
        return;
    }
    __weak MUSDetailPostViewController *weakSelf = self;
    [[MUSPhotoManager sharedManager] photoShowFromViewController:self withComplition:^(id result, NSError *error) {
        if(!error) {
            // ДОБАВИТЬ МЕТОД В БИБЛИОТЕКУ И УБРАТЬ ЭТУ ЧАСТЬ КОДА ПОЛНОСТЬЮ
            ImageToPost *imageToPost = result;
            [weakSelf.arrayOfUsersPictures addObject: imageToPost.image];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf showErrorAlertWithError : error];
            return;
        }
    }];
}


#pragma mark - Keyboard Show/Hide

- (void) keyboardWillShow: (NSNotification*) notification {
    NSLog(@"table view y = %f", self.tableView.contentOffset.y);
    
    NSInteger tableViewY = self.tableView.contentOffset.y;
    
    CGRect initialFrame = [[[notification userInfo] objectForKey : UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    CGFloat height = self.heightOfGalleryWithPhotosRow + self.heightOfCommentsAndLikeRow + self.heightOfPostDescriptionRow + self.tabBarController.tabBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (height > convertedFrame.origin.y) {
        CGFloat deltaHeight = convertedFrame.origin.y - height + tableViewY + 8;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + deltaHeight, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }
}


- (void) keyboardWillHide: (NSNotification*) notification {
    self.tableView.frame = CGRectMake(self.tableViewFrame.origin.x, self.tableViewFrame.origin.y, self.tableViewFrame.size.width, self.tableViewFrame.size.height);
}

@end
