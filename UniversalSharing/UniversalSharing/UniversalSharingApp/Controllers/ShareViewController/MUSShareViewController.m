//
//  MUSShareViewController.m
//  UniversalSharing
//
//  Created by U 2 on 28.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//


#import "MUSShareViewController.h"
#import "UIButton+CornerRadiusButton.h"
#import "UIImageView+LoadImageFromNetwork.h"
#import "UIButton+LoadBackgroundImageFromNetwork.h"
#import "ConstantsApp.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MUSLocationManager.h"
#import <CoreLocation/CLAvailability.h>




typedef NS_ENUM(NSInteger, TabBarItemIndex) {
    Share_photo,
    Share_location,
};

typedef NS_ENUM(NSInteger, AlertButtonIndex) {
    Cancel,
    Album,
    Camera,
};

@interface MUSShareViewController () <UITextViewDelegate, UIActionSheetDelegate, UITabBarDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)changeSocialNetworkAccount:(id)sender;
- (IBAction)shareToSocialNetwork:(id)sender;
- (IBAction)endEditingMessage:(id)sender;

@property (weak, nonatomic) IBOutlet UITabBar *shareTabBar;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIButton *changeSocialNetworkButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *shareButtonOutlet;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *mainGestureRecognizer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tabBarLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* messageTextViewLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (assign, nonatomic) CGFloat tabBarLayoutConstaineOrigin;
@property (assign, nonatomic) CGFloat messageTextViewLayoutConstraintOrigin;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (strong, nonatomic) NSMutableArray *socialNetworkAccountsArray;
@property (assign, nonatomic) TabBarItemIndex tabBarItemIndex;
@property (assign, nonatomic) AlertButtonIndex alertButtonIndex;
@end

@implementation MUSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarLayoutConstaineOrigin = self.tabBarLayoutConstraint.constant;
    self.messageTextViewLayoutConstraintOrigin = self.messageTextViewLayoutConstraint.constant;
    self.messageTextView.delegate = self;
    [self.changeSocialNetworkButtonOutlet cornerRadius:10];
    [self.shareButtonOutlet cornerRadius:10];
    self.socialNetworkAccountsArray = [[NSMutableArray alloc] init];
    self.shareTabBar.delegate = self;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self initiationMessageTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton

- (void) initiationSocialNetworkButtonForSocialNetwork {
    if (!_currentSocialNetwork) {
        _currentSocialNetwork = [self currentSocialNetwork];
    }
    
    __weak UIButton *socialNetworkButton = self.changeSocialNetworkButtonOutlet;
    [_currentSocialNetwork obtainDataWithComplition:^(id result, NSError *error) {
        SocialNetwork *currentSocialNetwork = (SocialNetwork*) result;
        self.currentUser = currentSocialNetwork.currentUser;
        [socialNetworkButton loadBackroundImageFromNetworkWithURL:[NSURL URLWithString: self.currentUser.photoURL]];
    }];
}

- (SocialNetwork*) currentSocialNetwork {
    SocialNetwork *currentSocialNetwork = nil;
    NSArray *accountsArray = [[SocialManager sharedManager] networks];
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
    self.tabBarLayoutConstraint.constant = convertedFrame.size.height - self.shareTabBar.frame.size.height;
    self.messageTextViewLayoutConstraint.constant = convertedFrame.size.height;
}

- (void) keyboardWillHide: (NSNotification*) notification{
    self.tabBarLayoutConstraint.constant = self.tabBarLayoutConstaineOrigin;
    self.messageTextViewLayoutConstraint.constant = self.messageTextViewLayoutConstraintOrigin;
}


#pragma mark - UIChangeSocialNetwork

- (IBAction)changeSocialNetworkAccount:(id)sender {
    [self showUserAccountsInActionSheet];
}

- (IBAction)shareToSocialNetwork:(id)sender {
    
}

#pragma mark UITextViewDelegate

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

#pragma mark UITapGestureRecognizer

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
    for (int i = 0; i < [[[SocialManager sharedManager] networks] count]; i++) {
        SocialNetwork *socialNetwork = [[[SocialManager sharedManager] networks] objectAtIndex:i];
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

#pragma mark UITabBar

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
#pragma mark ShareLocationTabBarItem 

- (void) userCurrentLocation {
    [[MUSLocationManager sharedManager] startTrackLocation];
    CLLocation* location = [[MUSLocationManager sharedManager] stopAndGetCurrentLocation];
    CLLocationCoordinate2D locationCoordinate = location.coordinate;
    NSLog(@"Current location lat = %f, long =%f", locationCoordinate.latitude, locationCoordinate.longitude);
}


#pragma mark SharePhotoTabBarItem

- (void) photoAlertShow {
    UIAlertView *photoAlert = [[UIAlertView alloc] initWithTitle:@"Share photo" message: nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Album", @"Camera", nil];
    [photoAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _alertButtonIndex = buttonIndex;
    switch (_alertButtonIndex) {
        case Cancel:
            NSLog(@"Cancel");
            break;
        case Album:
            NSLog(@"Album");
            [self selectPhotoFromAlbum];
            break;
         case Camera:
            [self takePhoto];
            NSLog(@"Camera");
            break;
        default:
            break;
    }
}

#pragma mark SelectPhotoFromAlbum

- (void) selectPhotoFromAlbum {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    if (image != nil) {
        self.photoImageView.image = image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end


