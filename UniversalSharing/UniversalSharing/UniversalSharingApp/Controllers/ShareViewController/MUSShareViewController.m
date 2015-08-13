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
#import "UIButton+MUSSocialNetwork.h"
#import "MUSGaleryView.h"
#import "ReachabilityManager.h"

@interface MUSShareViewController () <UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIToolbarDelegate, MUSGaleryViewDelegate>

- (IBAction)shareToSocialNetwork:(id)sender;
- (IBAction)endEditingMessage:(id)sender;


@property (weak, nonatomic)     IBOutlet    UIToolbar *shareToolBar;
@property (weak, nonatomic)     IBOutlet    UITextView *messageTextView;
@property (strong, nonatomic)   IBOutlet    UITapGestureRecognizer *mainGestureRecognizer;
@property (weak, nonatomic)     IBOutlet    UIBarButtonItem *shareButtonOutlet;



/*!
 @property
 @abstract  in order to up toolbar when the keyboard appears
 */
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* toolBarLayoutConstraint;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* galeryViewLayoutConstraint;
/*!
 @property
 @abstract  in order to up textview when the keyboard appears
 */
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* messageTextViewLayoutConstraint;
/*!
 @property
 @abstract object with chosen pics and xib with collectionView
 */
@property (weak, nonatomic)     IBOutlet    MUSGaleryView *galeryView;
@property (weak, nonatomic)     IBOutlet    UIBarButtonItem *sharePhotoButton;
@property (weak, nonatomic)     IBOutlet    UIBarButtonItem *shareLocationButton;

/*!
 @property
 @abstract  in order to save origin position toolbar and return back when the keyboard disappears
 */
@property (assign, nonatomic)               CGFloat toolBarLayoutConstraineOrigin;
/*!
 @property
 @abstract  in order to save origin position galeryView and return back when the keyboard disappears
 */
@property (assign, nonatomic)               CGFloat GaleryViewLayoutConstraineOrigin;

/*!
 @property
 @abstract  in order to save origin position textView and return back when the keyboard disappears
 */
@property (assign, nonatomic)               CGFloat messageTextViewLayoutConstraintOrigin;
@property (strong, nonatomic)               SocialNetwork *currentSocialNetwork;
/*!
 @property
 @abstract  use this array for actionsheet to show networks which are login and isVisible(we can do network unvisible in account controller) and for change currentusernetwork after a user chose other network
 */
@property (strong, nonatomic)               NSMutableArray *socialNetworkAccountsArray;
/*!
 @property
 @abstract  in order to add  existed networks in our app
 */
@property (strong, nonatomic)               NSArray *arrayWithNetworks;
@property (strong, nonatomic)               Post *post;
@property (strong, nonatomic)               UIButton *changeSocialNetworkButton;
/*!
 @property
 @abstract in order to get place id from locationViewController and pass to network for location of a user
 */
@property (strong, nonatomic)               NSString *placeID;
//@property (assign, nonatomic)               CGFloat messageTextViewLayoutConstraintOrigin;
@end

@implementation MUSShareViewController

#pragma mark - ViewMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiationMUSShareViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillShow:)
                                                 name : UIKeyboardWillShowNotification
                                               object : nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillHide:)
                                                 name : UIKeyboardDidHideNotification
                                               object : nil];
    self.mainGestureRecognizer.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}
/*!
 @method
 @abstract method of "changeSocialNetworkButton" is called for showing actionSheet with login and isVisible networks
 @param sender
 */
- (void)changeSocialNetworkAccount:(id)sender{
    [self showUserAccountsInActionSheet];
}

#pragma mark - UIButton

- (void) addButtonOnTextView {
    /*
     using category
     */
    self.changeSocialNetworkButton = [UIButton new];
    [self.changeSocialNetworkButton addTarget:self action:@selector(changeSocialNetworkAccount:)forControlEvents:UIControlEventTouchUpInside];
    [self.messageTextView addSubview:self.changeSocialNetworkButton];
}

- (IBAction)btnShareLocationTapped:(id)sender {
    [self userCurrentLocation];
}

- (IBAction)btnSharePhotoTapped:(id)sender {
    [self obtainChosenImage];
}
/*!
 @method
 @abstract  detour to the right round "changeSocialNetworkButton" when text is being written by a user
 @param without
 */
- (void) forceTextViewWorkAsFacebookSharing {// a little bug when scroll text
    // CGRect buttonFrame = self.changeSocialNetworkButton.frame;
    CGRect myFrame = CGRectMake(0, 0, self.changeSocialNetworkButton.frame.size.width + self.changeSocialNetworkButton.frame.origin.x, self.changeSocialNetworkButton.frame.size.height + self.changeSocialNetworkButton.frame.origin.x);
    UIBezierPath *exclusivePath = [UIBezierPath bezierPathWithRect: myFrame];
    self.messageTextView.textContainer.exclusionPaths = @[exclusivePath];

}

/*!
 @method
 @abstract  disappear keyboard when touch other place
 @param event
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - initiation MUSShareViewController

- (void) initiationMUSShareViewController {
    /*
     init current social network for "changeSocialNetworkButton"(image)
     */
    if (!_currentSocialNetwork) {
        _currentSocialNetwork = [SocialManager currentSocialNetwork];
    }
    
    [self addButtonOnTextView];
    [self forceTextViewWorkAsFacebookSharing];
    self.galeryView.delegate = self;
    self.shareButtonOutlet.enabled = NO;
    self.toolBarLayoutConstraineOrigin = self.toolBarLayoutConstraint.constant;
    self.messageTextViewLayoutConstraintOrigin = self.messageTextViewLayoutConstraint.constant;
    
    if ([self obtainSizeScreen] <= 480) {
        self.GaleryViewLayoutConstraineOrigin = self.galeryViewLayoutConstraint.constant;
    }
    self.socialNetworkAccountsArray = [NSMutableArray new];
    //self.arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
}

- (CGFloat) obtainSizeScreen {
    return [UIScreen mainScreen].applicationFrame.size.height;
}
#pragma mark - Keyboard Show/Hide

- (void) keyboardWillShow: (NSNotification*) notification {
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    self.toolBarLayoutConstraint.constant = convertedFrame.size.height;
    /*
     size up
     */
    CGFloat galeryViewHeight = self.galeryView.frame.size.height;
    if ([self obtainSizeScreen] <= 480) {
        galeryViewHeight = 60.0f;
        self.galeryViewLayoutConstraint.constant = galeryViewHeight;
    }
    self.messageTextViewLayoutConstraint.constant = convertedFrame.size.height + self.shareToolBar.frame.size.height + galeryViewHeight;
    [UIView animateWithDuration: 0.3  animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification*) notification {
    self.toolBarLayoutConstraint.constant = self.toolBarLayoutConstraineOrigin;
    self.messageTextViewLayoutConstraint.constant = self.messageTextViewLayoutConstraintOrigin;
    if ([self obtainSizeScreen] <= 480) {
    self.galeryViewLayoutConstraint.constant = self.GaleryViewLayoutConstraineOrigin;
    }
    [UIView animateWithDuration: 0.4 animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
}

#pragma mark - UIChangeSocialNetwork
/*!
 @method
 @abstract  detour to the right round "changeSocialNetworkButton" when text is being written by a user
 @param sender
 */
- (IBAction)shareToSocialNetwork:(id)sender {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    
    if (!isReachableViaWiFi && !isReachable) {
        [self showAlertWithMessage: musAppError_Internet_Connection];
        return;
    }
    
    if(!self.post) {
        self.post = [[Post alloc] init];
    } else {
        self.post.placeID = self.placeID;
        if (![self.messageTextView.text isEqualToString: kPlaceholderText]) {
            self.post.postDescription = self.messageTextView.text;
        } else {
            self.post.postDescription = @"";
        }
        self.post.networkType = _currentSocialNetwork.networkType;
    /*
     get array with chosen images from MUSGaleryView
     */
        self.post.arrayImages = [self.galeryView obtainArrayWithChosenPics];
        [_currentSocialNetwork sharePost:self.post withComplition:^(id result, NSError *error) {
            if (!error) {
                [self showAlertWithMessage : titleCongratulatoryAlert];
            } else {
                [self showErrorAlertWithError : error];
            }
        }];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        textView.text = changePlaceholderWhenStartEditing;
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
        self.shareButtonOutlet.enabled = YES;
    }
    self.mainGestureRecognizer.enabled = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    NSString *string=self.messageTextView.text;
    //    NSArray *array=[string componentsSeparatedByString:@"\n"];
    //    if ([array count] == 4) {
    //        [self cancelForceTextViewWorkAsFacebookSharing];
    //    }
    return textView.text.length + (text.length - range.length) <= countOfAllowedLettersInTextView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text length] == 0) {
        [self initiationMessageTextView];
        if ([self.galeryView obtainArrayWithChosenPics].count < 1) {
            self.shareButtonOutlet.enabled = NO;
        }
    } else {
        self.shareButtonOutlet.enabled = YES;
    }
}

- (void) initiationMessageTextView {
    /*
     text : "write something"
     */
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
    sheet.title = titleActionSheet;
    sheet.delegate = self;
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:musAppButtonTitle_Cancel];
    self.arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
    
    __weak MUSShareViewController *weakSelf = self;
    [[[SocialManager sharedManager] networks: self.arrayWithNetworks] enumerateObjectsUsingBlock:^(SocialNetwork *socialNetwork, NSUInteger index, BOOL *stop) {
        if (socialNetwork.isLogin && !socialNetwork.isVisible) {
            NSString *buttonTitle = [NSString stringWithFormat:@"%@", NSStringFromClass([socialNetwork class])];
            [sheet addButtonWithTitle: buttonTitle];
            [weakSelf.socialNetworkAccountsArray addObject:socialNetwork];
        }
    }];
    [sheet showInView:self.view];
    //[sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != 0 ) {
        /*
         after a user chose new network we change current social network
         */
        _currentSocialNetwork = [self.socialNetworkAccountsArray objectAtIndex: buttonIndex - 1];
        [self.shareLocationButton setTintColor: [UIColor blackColor]];
        self.placeID = @"";
        [self.changeSocialNetworkButton initiationSocialNetworkButtonForSocialNetwork:_currentSocialNetwork];
    }
}

#pragma mark - obtainChosenImage
/*!
 @method
 @abstract  get array chosen images from galeryView in order to check count of allowed pics than go to photomanager in order to chose any pic and pass chosen a pic to galeryView(for collectionView)
 @param without
 */
- (void) obtainChosenImage {
    if ([[self.galeryView obtainArrayWithChosenPics] count] == countOfAllowedPics) {
        [self showAlertWithMessage : musAppAlertTitle_NO_Pics_Anymore];
        return;
    }
    __weak MUSShareViewController *weakSelf = self;
    [[MUSPhotoManager sharedManager] photoShowFromViewController:self withComplition:^(id result, NSError *error) {
        if(!error) {
            [weakSelf.galeryView passChosenImageForCollection:result];
        } else {
            [weakSelf showErrorAlertWithError : error];
            return;
        }
    }];
}

#pragma mark - ShareLocationToolBarItemClick

- (void) userCurrentLocation {
    [self performSegueWithIdentifier: goToLocationViewControllerSegueIdentifier sender:nil];
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


#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSLocationTableViewController *vc = [MUSLocationTableViewController new];
    if ([[segue identifier] isEqualToString:goToLocationViewControllerSegueIdentifier]) {
        vc = [segue destinationViewController];
        [vc setCurrentUser:_currentSocialNetwork];
        
        
        __weak MUSShareViewController *weakSelf = self;
        vc.placeComplition = ^(Place* result, NSError *error) {
            /*
             back place object and we get id for network
             */
            if (result) {
                weakSelf.placeID = result.placeID;
                [self.shareLocationButton setTintColor: [UIColor redColor]];
            }
        };
    }
}

#pragma mark - MUSGaleryViewDelegate

- (void)changeSharePhotoButtonColorAndShareButtonState: (BOOL) isPhotos {
    if (!isPhotos) {
        [self.sharePhotoButton setTintColor:[UIColor blackColor]];
        
        if ([self.messageTextView.text isEqualToString:kPlaceholderText]) {
            self.shareButtonOutlet.enabled = NO;
        }
        
    } else {
        [self.sharePhotoButton setTintColor:[UIColor redColor]];
        self.shareButtonOutlet.enabled = YES;
    }
}



@end


