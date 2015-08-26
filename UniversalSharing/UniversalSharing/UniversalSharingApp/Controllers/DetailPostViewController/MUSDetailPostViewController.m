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

@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate, MUSPostDescriptionCellDelegate, MUSGalleryOfPhotosCellDelegate, MUSPostLocationCellDelegate,  UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) DetailPostVC_CellType detailPostVC_CellType;
@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSMutableArray *arrayOfUsersPictures;
@property (nonatomic, assign) CGRect tableViewFrame;
@property (nonatomic, strong) SocialNetwork *currentSocialNetwork;
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
    [self initiationPostDescriptionArrayOfPicturesAndPostLocation];
    
    self.currentUser = [[DataBaseManager sharedManager] obtainUsersWithNetworkType: self.currentSocialNetwork.networkType];
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
    ReasonType currentReasonType = self.currentPost.reason;
    if (currentReasonType == Offline || currentReasonType == ErrorConnection) {
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle : @"Action" style:2 target:self action: @selector(showActionSheet)];
        self.navigationItem.rightBarButtonItem = actionButton;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:2 target:self action: @selector(backToThePostsViewController)];
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark initiation CurrentSocialNetwork

- (void) initiationCurrentSocialNetwork {
    self.currentSocialNetwork = [SocialNetwork sharedManagerWithType:self.currentPost.networkType];
}

#pragma mark initiation current postDescription, arrayOfUsersPictures, postLocation

- (void) initiationPostDescriptionArrayOfPicturesAndPostLocation {
    self.arrayOfUsersPictures = [[NSMutableArray alloc] init];
    NSLog(@"%@", self.currentPost.arrayImagesUrl);
#warning КОСТЫЛЬ - т.к. - если нет рисунков приходит массив с одним объектом типа ""
    if (![[self.currentPost.arrayImagesUrl firstObject] isEqualToString: @""]) {
        for (int i = 0; i < self.currentPost.arrayImagesUrl.count; i++) {
            UIImage *currentImage = [[UIImage alloc] init];
            //[currentImage loadImageFromDataBase: [self.currentPost.arrayImagesUrl objectAtIndex: i]];
            currentImage = [currentImage loadImageFromDataBase: [self.currentPost.arrayImagesUrl objectAtIndex: i]];
        
            [self.arrayOfUsersPictures addObject: currentImage];
        }
    }
    self.postDescription = self.currentPost.postDescription;
//    self.currentLocationOfPost = CLLocationCoordinate2DMake([self.currentPost.latitude floatValue], [self.currentPost.longitude floatValue]);
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
            NSLog(@"POST"); // SEND POST METHOD;
            [self sentPost];
        } else {
            //NSLog(@"EDIT");
            self.isEditableTableView = YES;
            [self.tableView reloadData];
        }
    }
}

#pragma mark UpdatePost

- (void) updatePost {
    self.currentPost.postDescription = self.postDescription;
    self.currentPost.placeID = self.placeID;
    //self.currentPost.placeName = self.placeName;
//    self.currentPost.latitude = [NSString stringWithFormat: @"%f", self.currentLocationOfPost.latitude];
//    self.currentPost.longitude = [NSString stringWithFormat: @"%f", self.currentLocationOfPost.latitude];
    NSMutableArray *arrayOfImagesToPost = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.arrayOfUsersPictures.count; i++) {
        ImageToPost *imageToPost = [[ImageToPost alloc] init];
        imageToPost.image = [self.arrayOfUsersPictures objectAtIndex: i];
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
    [[DataBaseManager sharedManager] editPost: self.currentPost];
}


- (void) sentPost {
    // 1) Обновить пост
    // 2) Есть ли проверка на создан такой пост уже или нет
    // 3) Оправка поста и обновление должны происходить только в библиотеке
    NSLog(@"Send Post");
}

#pragma mark BackToThePostsViewController

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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailPostVC_CellType = indexPath.row;
    switch (self.detailPostVC_CellType) {
        case GalleryOfPhotosCellType: {
            MUSGalleryOfPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSGalleryOfPhotosCell cellID]];
            if(!cell) {
                cell = [MUSGalleryOfPhotosCell galleryOfPhotosCell];
            }            
            cell.delegate = self;
            cell.isEditableCell = self.isEditableTableView;
            [cell configurationGalleryOfPhotosCellByArrayOfImages : self.arrayOfUsersPictures
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailPostVC_CellType = indexPath.row;
    switch (self.detailPostVC_CellType) {
        case GalleryOfPhotosCellType:
            return [MUSGalleryOfPhotosCell heightForGalleryOfPhotosCell: self.arrayOfUsersPictures.count];
            break;
        case CommentsAndLikesCellType:
            return [MUSCommentsAndLikesCell heightForCommentsAndLikesCell];;
            break;
        case PostDescriptionCellType:
        {
            CGFloat heightOfPostDescriptionRow = [MUSPostDescriptionCell heightForPostDescriptionCell: self.postDescription];
            if (heightOfPostDescriptionRow < 100 && self.isEditableTableView) {
                heightOfPostDescriptionRow = 100;
            }
            return heightOfPostDescriptionRow;
            break;
        }
        default:
            return [MUSPostLocationCell heightForPostLocationCell];
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

- (void) beginEditingPostDescription:(NSIndexPath *)currentIndexPath {
    [self performSelector:@selector(scrollToCell:) withObject: currentIndexPath afterDelay:0.5f];
}

-(void) scrollToCell:(NSIndexPath*) path {
/*
    UITableViewScrollPositionNone,
    UITableViewScrollPositionTop,
    UITableViewScrollPositionMiddle,
    UITableViewScrollPositionBottom
*/
    [_tableView scrollToRowAtIndexPath:path atScrollPosition : UITableViewScrollPositionNone animated:YES];
}

#pragma mark - MUSGalleryOfPhotosCellDelegate

- (void) arrayOfImagesOfUser:(NSArray *)arrayOfImages {
    if (!arrayOfImages.firstObject) {
        [self.arrayOfUsersPictures removeAllObjects];
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
            [self updatePost];
            [self deletePostImagesFromDocumentsFolder: self.currentPost];
            [self saveImageToDocumentsFolderAndFillArrayWithUrl : self.currentPost];
            [self updatePostInDataBase];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

@end
