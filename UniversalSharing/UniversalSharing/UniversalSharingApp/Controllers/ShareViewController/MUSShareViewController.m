//
//  MUSShareViewController.m
//  UniversalSharing
//
//  Created by U 2 on 28.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSShareViewController.h"
#import "UIButton+CornerRadiusButton.h"
#import "UIButton+LoadBackgroundImageFromNetwork.h"
#import "ConstantsApp.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "MUSPhotoManager.h"
#import "MUSLocationManager.h"
#import "MUSCollectionViewCell.h"
#import "MUSLocationTableViewController.h"
#import "Place.h"
@interface MUSShareViewController () <UITextViewDelegate, UIActionSheetDelegate, UITabBarDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (IBAction)shareToSocialNetwork:(id)sender;
- (IBAction)endEditingMessage:(id)sender;


@property (weak, nonatomic)     IBOutlet    UITabBar *shareTabBar;
@property (weak, nonatomic)     IBOutlet    UITextView *messageTextView;
@property (strong, nonatomic)   IBOutlet    UITapGestureRecognizer *mainGestureRecognizer;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* tabBarLayoutConstraint;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* messageTextViewLayoutConstraint;
//@property (weak, nonatomic)     IBOutlet    UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic)               CGFloat tabBarLayoutConstaineOrigin;
@property (assign, nonatomic)               CGFloat messageTextViewLayoutConstraintOrigin;
@property (strong, nonatomic)               User *currentUser;
@property (strong, nonatomic)               SocialNetwork *currentSocialNetwork;
@property (strong, nonatomic)               NSMutableArray *socialNetworkAccountsArray;
@property (assign, nonatomic)               TabBarItemIndex tabBarItemIndex;
@property (assign, nonatomic)               AlertButtonIndex alertButtonIndex;
@property (strong, nonatomic)               NSArray *arrayWithNetworks;
@property (strong, nonatomic)               NSArray *arrayPlaces;
@property (assign, nonatomic)               CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic)               NSMutableArray *arrayWithChosenImages;
@property (strong, nonatomic)               Post *post;

@property (strong, nonatomic) UIButton *changeSocialNetworkButton;
@end

@implementation MUSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiationMUSShareViewController];
    [self addButtonOnTextView];
    [self setFlowLayout];

    self.arrayWithChosenImages = [NSMutableArray new];
}

- (void) setFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_collectionView setCollectionViewLayout:flowLayout];
}

- (void)changeSocialNetworkAccount:(id)sender{
    [self showUserAccountsInActionSheet];
}

- (void) addButtonOnTextView {
    
    self.changeSocialNetworkButton  =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.changeSocialNetworkButton.frame  =   CGRectMake(6.0, 15.0, 75.0, 70.0);
    
    [self.changeSocialNetworkButton addTarget:self action:@selector(changeSocialNetworkAccount:)forControlEvents:UIControlEventTouchUpInside];
    self.changeSocialNetworkButton.backgroundColor=[UIColor blueColor];
    // CGRect buttonFrame = self.changeSocialNetworkButton.frame;
    [self forceTextViewWorkAsFacebookSharing];
    [self.messageTextView addSubview:self.changeSocialNetworkButton];
}

- (void) forceTextViewWorkAsFacebookSharing {
    CGRect myFrame = CGRectMake(6, 15, 100, 50);
    UIBezierPath *exclusivePath = [UIBezierPath bezierPathWithRect:myFrame];
    self.messageTextView.textContainer.exclusionPaths = @[exclusivePath];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
    self.mainGestureRecognizer.enabled = NO;
    [self initiationSocialNetworkButtonForSocialNetwork];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[self initiationMessageTextView];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - initiation MUSShareViewController

- (void) initiationMUSShareViewController {
    self.tabBarLayoutConstaineOrigin = self.tabBarLayoutConstraint.constant;
    self.messageTextViewLayoutConstraintOrigin = self.messageTextViewLayoutConstraint.constant;
    
    //self.tabBarLayoutConstraint.constant = self.tabBarController.tabBar.frame.size.height;
    //self.messageTextViewLayoutConstraint.constant = self.tabBarController.tabBar.frame.size.height + self.shareTabBar.frame.size.height;
    
    self.messageTextView.delegate = self;
    [self.changeSocialNetworkButton cornerRadius:10];
    //[self.shareButtonOutlet cornerRadius:10];
    self.socialNetworkAccountsArray = [[NSMutableArray alloc] init];
    self.shareTabBar.delegate = self;
    self.arrayWithNetworks = [NSArray arrayWithObjects:@(Twitters), @(VKontakt), @(Facebook), nil];
}


#pragma mark - UIButton

- (void) initiationSocialNetworkButtonForSocialNetwork {
    if (!_currentSocialNetwork) {
        _currentSocialNetwork = [SocialNetwork currentSocialNetwork];//[self currentSocialNetwork];
    }
    
    __weak UIButton *socialNetworkButton = self.changeSocialNetworkButton;
    [_currentSocialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
        SocialNetwork *currentSocialNetwork = (SocialNetwork*) result;
        self.currentUser = currentSocialNetwork.currentUser;
        [socialNetworkButton loadBackroundImageFromNetworkWithURL:[NSURL URLWithString: self.currentUser.photoURL]];
    }];
}

//#warning "REmove logic in Social Network"

//- (SocialNetwork*) currentSocialNetwork {
//    SocialNetwork *currentSocialNetwork = nil;
//    NSArray *accountsArray = [[SocialManager sharedManager] networks:@[@(Twitters), @(VKontakt), @(Facebook)]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogin == %d", YES];
//    NSArray *filteredArray = [accountsArray filteredArrayUsingPredicate:predicate];
//    if (filteredArray.count > 0) {
//        currentSocialNetwork = (SocialNetwork*) [filteredArray firstObject];
//    }
//    return currentSocialNetwork;
//}


#pragma mark - Keyboard Show/Hide

- (void) keyboardWillShow: (NSNotification*) notification{
    
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    self.tabBarLayoutConstraint.constant = convertedFrame.size.height;
    self.messageTextViewLayoutConstraint.constant = convertedFrame.size.height + self.shareTabBar.frame.size.height + self.collectionView.frame.size.height;
    
    [UIView animateWithDuration: 0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self.view setNeedsLayout];
                     }];
    
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification*) notification{
    self.tabBarLayoutConstraint.constant = self.tabBarLayoutConstaineOrigin;
    self.messageTextViewLayoutConstraint.constant = self.messageTextViewLayoutConstraintOrigin;
    
    [UIView animateWithDuration: 0.6
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self.view setNeedsLayout];
                     }];
    
    
    [UIView commitAnimations];
}



#pragma mark - UIChangeSocialNetwork

- (IBAction)shareToSocialNetwork:(id)sender {
    if(!self.post)
    self.post = [[Post alloc] init];
    self.post.postDescription = self.messageTextView.text;
    self.post.networkType = _currentSocialNetwork.networkType;
    self.post.arrayImages = self.arrayWithChosenImages;
    
    //NSData *imageData = UIImagePNGRepresentation(self.photoImageView.image);
    //if (self.photoImageView.image) {
        //post.imageToPost.image = self.photoImageView.image;
        //post.imageToPost.imageType = JPEG;
        //post.imageToPost.quality = 0.8;
    //}
    self.post.latitude = self.currentLocation.latitude;
    self.post.longitude = self.currentLocation.longitude;
    
    [_currentSocialNetwork sharePost:self.post withComplition:^(id result, NSError *error) {
        NSLog(@"POSTED");
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    self.mainGestureRecognizer.enabled = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    return textView.text.length + (text.length - range.length) <= 80;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        [self initiationMessageTextView];
    }
}


- (void) initiationMessageTextView {
    self.messageTextView.text = kPlaceholderText;
    self.messageTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.tag = 0;
}

#pragma mark - UITapGestureRecognizer

- (IBAction)endEditingMessage:(id)sender {
    [self.messageTextView resignFirstResponder];
    self.mainGestureRecognizer.enabled = NO;
}

#pragma mark - UIActionSheet

- (void) showUserAccountsInActionSheet {
    [self.socialNetworkAccountsArray removeAllObjects];
    UIActionSheet* sheet = [UIActionSheet new];
    sheet.title = @"Select account";
    sheet.delegate = self;
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
    
    for (int i = 0; i < [[[SocialManager sharedManager] networks: self.arrayWithNetworks] count]; i++) {
        SocialNetwork *socialNetwork = [[[SocialManager sharedManager] networks: self.arrayWithNetworks] objectAtIndex:i];
        if (socialNetwork.isLogin && !socialNetwork.isVisible) {
            NSString *buttonTitle = [NSString stringWithFormat:@"%@", NSStringFromClass([socialNetwork class])];
            [sheet addButtonWithTitle: buttonTitle];
            [self.socialNetworkAccountsArray addObject:socialNetwork];
        }
    }
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != 0 ) {
        _currentSocialNetwork = [self.socialNetworkAccountsArray objectAtIndex: buttonIndex - 1];
        [self initiationSocialNetworkButtonForSocialNetwork];
    }
}

#pragma mark - UITabBar

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    _tabBarItemIndex = item.tag;
    
    switch (_tabBarItemIndex) {
        case Share_photo:
            NSLog(@"Share photo");
            [self photoAlertShow];
            break;
        case Share_location:
            NSLog(@"Share location");
            [self userCurrentLocation];
            break;
        default:
            break;
    }
}
#pragma mark - ShareLocationTabBarItemClick

- (void) userCurrentLocation {
//<<<<<<< HEAD
//    [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(id result, NSError *error) {
//        if ([result isKindOfClass:[CLLocation class]]) {
//            CLLocation* location = result;
//            self.currentLocation = location.coordinate;
//=======
    
    Location *currentLocation = [[Location alloc] init];
    currentLocation.longitude = @"-122.40828";
    currentLocation.latitude = @"37.768641";
    currentLocation.type = @"place";
    currentLocation.q = @"";
    currentLocation.distance = @"1000";
    __weak MUSShareViewController *weakSelf = self;

    [_currentSocialNetwork obtainArrayOfPlaces:currentLocation withComplition:^(NSMutableArray *places, NSError *error) {
        NSLog(@"%@", places);
        if (places.count > 1) {
            weakSelf.arrayPlaces = places;
            [weakSelf performSegueWithIdentifier: @"Location" sender:nil];
        } else {
            if(!weakSelf.post)
                weakSelf.post = [[Post alloc] init];
            Place *place = [places firstObject];
            weakSelf.post.placeID = place.placeID;
        }
        
    }];

    
    
    
    /*
    [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(id result, NSError *error) {
        if ([result isKindOfClass:[CLLocation class]]) {
            CLLocation* location = result;
            self.currentLocation = location.coordinate;
>>>>>>> 43859dc699e5a361212ca2cae3f67f6bd8dc661c
            Location *currentLocation = [[Location alloc] init];
            currentLocation.longitude = [NSString stringWithFormat: @"%f", location.coordinate.longitude];
            currentLocation.latitude = [NSString stringWithFormat: @"%f", location.coordinate.latitude];
            currentLocation.type = @"place";
            currentLocation.q = @"";
            
            [_currentSocialNetwork obtainArrayOfPlaces:currentLocation withComplition:^(NSMutableArray *places, NSError *error) {
                NSLog(@"%@", places);
            }];
            
            //NSLog(@"Current location lat = %f, long =%f", self.currentLocation.latitude, locationCoordinate.longitude);
<<<<<<< HEAD
        //}
   // }];
=======
        }
    }];
     */
//>>>>>>> 43859dc699e5a361212ca2cae3f67f6bd8dc661c
}


#pragma mark - SharePhotoTabBarItemClick

- (void) photoAlertShow {
    UIAlertView *photoAlert = [[UIAlertView alloc] initWithTitle:@"Share photo" message: nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Album", @"Camera", @"Remove a pic", nil];
    [photoAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _alertButtonIndex = buttonIndex;
    switch (_alertButtonIndex) {
        case Cancel:
            break;
        case Album:
            [self selectPhotoFromAlbum];
            break;
        case Camera:
            [self takePhotoFromCamera];
            break;
        case Remove:
            //self.photoImageView.image = nil;
            break;
        default:
            break;
    }
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayWithChosenImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if (self.arrayWithChosenImages[indexPath.row] != nil) {
        ImageToPost *image = self.arrayWithChosenImages[indexPath.row];
        cell.photoImageView.image = image.image;
    } else {
        cell.photoImageView.image = nil;
    }
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, self.collectionView.frame.size.height);
}
#pragma mark - MUSPhotoManager

- (void) selectPhotoFromAlbum {
    __weak MUSShareViewController *weakSelf = self;
    [[MUSPhotoManager sharedManager] selectPhotoFromAlbumFromViewController: self withComplition:^(id result, NSError *error) {
        if (!error) {
            //weakSelf.chosenPicture.image = (UIImage*) result;
            ImageToPost *imageToPost = [[ImageToPost alloc] init];
            imageToPost.image = (UIImage*) result;
            imageToPost.imageType = JPEG;
            imageToPost.quality = 0.8f;
            [weakSelf.arrayWithChosenImages addObject: imageToPost];

            
            //[weakSelf.arrayWithChosenImages addObject:(UIImage*) result];
            weakSelf.collectionView.backgroundColor = [UIColor grayColor];//just trying
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (void) takePhotoFromCamera {
    __weak MUSShareViewController *weakSelf = self;
    [[MUSPhotoManager sharedManager] takePhotoFromCameraFromViewController: self withComplition:^(id result, NSError *error) {
        if (!error) {
            [weakSelf.arrayWithChosenImages addObject:(UIImage*) result];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf showErrorAlertWithError : error];
        }
    }];
}

- (void) showErrorAlertWithError : (NSError*) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedFailureReason] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [errorAlert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MUSLocationTableViewController *vc = [MUSLocationTableViewController new];
    if ([[segue identifier] isEqualToString:@"Location"]) {
        vc = [segue destinationViewController];
        [vc setArrayPlaces:self.arrayPlaces];
        
        __weak MUSShareViewController *weakSelf = self;
        vc.placeComplition = ^(Place* result, NSError *error){
            if(!weakSelf.post)
                weakSelf.post = [[Post alloc] init];
            weakSelf.post.placeID = result.placeID;
        };
    }
}
@end


