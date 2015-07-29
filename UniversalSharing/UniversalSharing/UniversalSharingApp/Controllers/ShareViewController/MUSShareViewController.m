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


@interface MUSShareViewController () <UITextViewDelegate, UIActionSheetDelegate, UITabBarDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)changeSocialNetworkAccount:(id)sender;
- (IBAction)shareToSocialNetwork:(id)sender;
- (IBAction)endEditingMessage:(id)sender;


@property (weak, nonatomic)     IBOutlet    UITabBar *shareTabBar;
@property (weak, nonatomic)     IBOutlet    UITextView *messageTextView;
@property (weak, nonatomic)     IBOutlet    UIButton *changeSocialNetworkButtonOutlet;
@property (weak, nonatomic)     IBOutlet    UIButton *shareButtonOutlet;
@property (strong, nonatomic)   IBOutlet    UITapGestureRecognizer *mainGestureRecognizer;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* tabBarLayoutConstraint;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* messageTextViewLayoutConstraint;
@property (weak, nonatomic)     IBOutlet    UIImageView *photoImageView;

@property (assign, nonatomic)               CGFloat tabBarLayoutConstaineOrigin;
@property (assign, nonatomic)               CGFloat messageTextViewLayoutConstraintOrigin;
@property (strong, nonatomic)               User *currentUser;
@property (strong, nonatomic)               SocialNetwork *currentSocialNetwork;
@property (strong, nonatomic)               NSMutableArray *socialNetworkAccountsArray;
@property (assign, nonatomic)               TabBarItemIndex tabBarItemIndex;
@property (assign, nonatomic)               AlertButtonIndex alertButtonIndex;
@property (strong, nonatomic)               NSArray *arrayWithNetworks;
@property (assign, nonatomic)               CLLocationCoordinate2D currentLocation;


@end

@implementation MUSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        [self initiationMUSShareViewController];
    // Do any additional setup after loading the view from its nib.
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

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
    [self initiationMessageTextView];
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
    [self.changeSocialNetworkButtonOutlet cornerRadius:10];
    [self.shareButtonOutlet cornerRadius:10];
    self.socialNetworkAccountsArray = [[NSMutableArray alloc] init];
    self.shareTabBar.delegate = self;
    self.arrayWithNetworks = [NSArray arrayWithObjects:@(Twitters), @(VKontakt), @(Facebook), nil];
}

#pragma mark - UIButton

- (void) initiationSocialNetworkButtonForSocialNetwork {
    if (!_currentSocialNetwork) {
        _currentSocialNetwork = [self currentSocialNetwork];
    }
    
    __weak UIButton *socialNetworkButton = self.changeSocialNetworkButtonOutlet;
    [_currentSocialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
        SocialNetwork *currentSocialNetwork = (SocialNetwork*) result;
        self.currentUser = currentSocialNetwork.currentUser;
        [socialNetworkButton loadBackroundImageFromNetworkWithURL:[NSURL URLWithString: self.currentUser.photoURL]];
    }];
}

- (SocialNetwork*) currentSocialNetwork {
    SocialNetwork *currentSocialNetwork = nil;
    NSArray *accountsArray = [[SocialManager sharedManager] networks:@[@(Twitters), @(VKontakt)]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogin == %d", YES];
    NSArray *filteredArray = [accountsArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        currentSocialNetwork = (SocialNetwork*) [filteredArray firstObject];
    }
    return currentSocialNetwork;
}


#pragma mark - Keyboard Show/Hide

- (void) keyboardWillShow: (NSNotification*) notification{
    
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    self.tabBarLayoutConstraint.constant = convertedFrame.size.height;
    self.messageTextViewLayoutConstraint.constant = convertedFrame.size.height + self.shareTabBar.frame.size.height;
    
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

- (IBAction)changeSocialNetworkAccount:(id)sender {
    [self showUserAccountsInActionSheet];
}

- (IBAction)shareToSocialNetwork:(id)sender {
    Post *post = [[Post alloc] init];
    post.postDescription = self.messageTextView.text;
    post.networkType = _currentSocialNetwork.networkType;
    NSData *imageData = UIImagePNGRepresentation(self.photoImageView.image);
    post.photoData = imageData;
    post.latitude = self.currentLocation.latitude;
    post.longitude = self.currentLocation.longitude;
    

    
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
        if (socialNetwork.isLogin) {
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
    [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(id result, NSError *error) {
        if ([result isKindOfClass:[CLLocation class]]) {
            CLLocation* location = result;
            self.currentLocation = location.coordinate;
            //NSLog(@"Current location lat = %f, long =%f", self.currentLocation.latitude, locationCoordinate.longitude);
        }
    }];
}


#pragma mark - SharePhotoTabBarItemClick

- (void) photoAlertShow {
    UIAlertView *photoAlert = [[UIAlertView alloc] initWithTitle:@"Share photo" message: nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Album", @"Camera", nil];
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
        default:
            break;
    }
}

#pragma mark - MUSPhotoManager

- (void) selectPhotoFromAlbum {
    __weak UIImageView *photoImage = self.photoImageView;
    [[MUSPhotoManager sharedManager] selectPhotoFromAlbumFromViewController: self withComplition:^(id result, NSError *error) {
        if (!error) {
            photoImage.image = (UIImage*) result;
        }
    }];
}

- (void) takePhotoFromCamera {
    __weak UIImageView *photoImage = self.photoImageView;
    [[MUSPhotoManager sharedManager] takePhotoFromCameraFromViewController: self withComplition:^(id result, NSError *error) {
        if (!error) {
            photoImage.image = (UIImage*) result;
        } else {
            [self showErrorAlertWithError : error];
        }
    }];
}

- (void) showErrorAlertWithError : (NSError*) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedFailureReason] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [errorAlert show];
}

@end


