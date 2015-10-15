//
//  MUSShareViewController.m
//  UniversalSharing
//
//  Created by U 2 on 28.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSShareViewController.h"
#import "ConstantsApp.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "MUSPhotoManager.h"
#import "MUSLocationManager.h"
#import "MUSCollectionViewCell.h"
#import "MUSPlace.h"
#import "MUSGaleryView.h"
#import "ReachabilityManager.h"
#import <CoreText/CoreText.h>
#import "DataBaseManager.h"
#import "MUSMediaGalleryViewController.h"
#import "MUSPopUpForSharing.h"
#import "MUSProgressBar.h"
#import "MUSProgressBarEndLoading.h"
#import "MUSImageToPost.h"

@interface MUSShareViewController () <UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIToolbarDelegate, MUSGaleryViewDelegate, MUSPopUpForSharingDelegate>

- (IBAction)shareToSocialNetwork:(id)sender;
- (IBAction)endEditingMessage:(id)sender;


@property (weak, nonatomic)     IBOutlet    UIButton *shareToolBar;
//@property (weak, nonatomic)     IBOutlet    UITextView *messageTextView;
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
//@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* messageTextViewLayoutConstraint;
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
@property (strong, nonatomic)               MUSSocialNetwork *currentSocialNetwork;
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
@property (strong, nonatomic)               MUSPost *post;
@property (strong, nonatomic)               UIButton *changeSocialNetworkButton;
/*!
 @property
 @abstract in order to get place id from locationViewController and pass to network for location of a user
 */
//@property (strong, nonatomic)               NSString *placeID;
@property (strong, nonatomic)               MUSPlace *place;

@property (strong, nonatomic)               UIBezierPath *exclusivePath;
@property (strong, nonatomic)               UITextView *messageTextView;
@property (assign, nonatomic)               CGRect messageTextViewFrame;
@property (strong, nonatomic)               UIActivityIndicatorView *activityIndicator ;


@property (strong, nonatomic)               NSMutableArray *arrayPicsForDetailCollectionView;
@property (assign, nonatomic)               NSInteger indexPicTapped;
//@property (assign, nonatomic)               BOOL fragForTextView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic)                MUSPopUpForSharing * popVC ;
//<<<<<<< HEAD
@property (strong, nonatomic)                NSString *address;
//@property (strong, nonatomic)                MUSProgressBar * progressBar ;
//@property (strong, nonatomic)                MUSProgressBarEndLoading * progressBarEndLoading ;
//=======
//@property (strong, nonatomic)                NSString* address;

@property (strong, nonatomic)               NSString *longitude;
@property (strong, nonatomic)               NSString *latitude;
@property (strong, nonatomic)               NSArray *arrayChosenNetworksForPost;
//@property (assign, nonatomic)               BOOL fragForMultiSharing;
//>>>>>>> de36ea2567a4ea8074988b37c8efbda4eb95e414
@end

@implementation MUSShareViewController

#pragma mark - ViewMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: DARK_BROWN_COLOR}];

    //[self.navigationController.navigationBar setTintColor:BROWN_COLOR_MIDLight];
    [self.shareButtonOutlet setTintColor: DARK_BROWN_COLOR];
    [self.shareButtonOutlet setStyle:2];
    //self.buttonLocation.backgroundColor = BROWN_COLOR_MIDLight;
    //_fragForMultiSharing = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(obtainPicFromPicker) name:notificationImagePickerForCollection object:nil];
#warning "Must be remove observe"
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillShow:)
                                                 name : UIKeyboardWillShowNotification
                                               object : nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillHide:)
                                                 name : UIKeyboardWillHideNotification
                                               object : nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initiationMUSShareViewController];
    
//    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    ////////////////////////
    //self.progressBar = [MUSProgressBar sharedProgressBar];
    //[self.progressBar.view setFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight)];
    /////////////////////////////////////////////////
    //self.progressBarEndLoading = [MUSProgressBarEndLoading sharedProgressBarEndLoading];
    //[self.progressBarEndLoading.view setFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight)];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startProgressView) name:@"StartSharePost" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endProgressViewWithCountConnect:) name:@"EndSharePost" object:nil ];
    

   // self.progressBar.viewHeightConstraint.constant = 0;
   // self.progressBarEndLoading.viewHeightConstraint.constant = 0;
//////////////////////////////////////////////////////////////////////////
    if(!self.post)
    [self createPost];
    [self.galeryView setUpPost:self.post];
  
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (!self.post.imagesArray.count && [self.messageTextView.text isEqualToString: MUSApp_TextView_PlaceholderText] && self.messageTextView.textColor == [UIColor lightGrayColor]) {
        self.shareButtonOutlet.enabled = NO;
        [self.sharePhotoButton setTintColor:[UIColor blackColor]];
    }
//    if (!_currentSocialNetwork || !_currentSocialNetwork.isVisible || !_currentSocialNetwork.isLogin) {
//        _currentSocialNetwork = [SocialManager currentSocialNetwork];
//        [self.changeSocialNetworkButton initiationSocialNetworkButtonForSocialNetwork: [SocialManager currentSocialNetwork]];
//    }
    self.mainGestureRecognizer.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self endEditingMessageTextView];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    /*
     dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
     dispatch_async(q, ^{
     dispatch_async(dispatch_get_main_queue(), ^{
     
[[NSNotificationCenter defaultCenter]removeObserver:self];
     });
     });
     */
}

/*!
 @method
 @abstract method of "changeSocialNetworkButton" is called for showing actionSheet with login and isVisible networks
 @param sender
 */
//- (void)changeSocialNetworkAccount:(id)sender{
//    [self showUserAccountsInActionSheet];
//}

#pragma mark - UIButton

//- (void) addButtonOnTextView {
//    self.changeSocialNetworkButton = [UIButton new];
//    [self.changeSocialNetworkButton addTarget:self action:@selector(changeSocialNetworkAccount:)forControlEvents:UIControlEventTouchUpInside];
//}

- (IBAction)buttonLocationTapped:(UIButton *)sender {////////////////////////////////////////////////////////////////////
    __weak MUSShareViewController *weakSelf = self;
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(CLLocation* location, NSError *error) {
            weakSelf.latitude = [NSString stringWithFormat: @"%f",location.coordinate.latitude];
            weakSelf.longitude = [NSString stringWithFormat: @"%f",location.coordinate.longitude];
             //weakSelf.post.longitude = [NSString stringWithFormat: @"%f",location.coordinate.longitude];
            //weakSelf.post.latitude = [NSString stringWithFormat: @"%f",location.coordinate.latitude];
            [[MUSLocationManager sharedManager] obtainAddressFromLocation:location complitionBlock:^(NSString *address, NSError *error) {
                self.address = address;
                [self.buttonLocation setTitle:address forState:UIControlStateNormal];
                self.iconImageView.highlighted = !self.iconImageView.highlighted;
            }];
        }];
    } else {
        UIActionSheet* sheet = [UIActionSheet new];
        sheet.title = self.address;
        sheet.delegate = self;
        [sheet addButtonWithTitle: @"Delete"];
        sheet.cancelButtonIndex = [sheet addButtonWithTitle:MUSApp_Button_Title_Cancel];
        [sheet showInView:self.view];
    }
}


- (IBAction)btnShareLocationTapped:(id)sender {
    if (!_currentSocialNetwork || !_currentSocialNetwork.isLogin) {
        //[self showAlertWithMessage: musAppError_Logged_Into_Social_Networks];
        return;
    } else {
        //[self userCurrentLocation];
    }
}

- (IBAction)btnSharePhotoTapped:(id)sender {
    [self obtainChosenImage];
}
- (void) obtainPicFromPicker {
   [self obtainChosenImage];
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
//    if (!_currentSocialNetwork) {
//        _currentSocialNetwork = [SocialManager currentSocialNetwork];
//    }
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

//    [self addButtonOnTextView];
    [self initiationMessageTextView]; //button for
    self.galeryView.delegate = self;
    self.shareButtonOutlet.enabled = NO;
    //self.shareButtonOutlet
    self.toolBarLayoutConstraineOrigin = self.toolBarLayoutConstraint.constant;
    if ([self obtainSizeScreen] <= 480) {
        self.GaleryViewLayoutConstraineOrigin = self.galeryViewLayoutConstraint.constant;
    }
    self.socialNetworkAccountsArray = [NSMutableArray new];
}

- (CGFloat) obtainSizeScreen {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

#pragma mark - initiation Message UITextView

/*!
 @method
 @abstract  detour to the right round "changeSocialNetworkButton" when text is being written by a user
 @param without
 */
- (void) initiationMessageTextView {
    NSDictionary* attrs = @{NSFontAttributeName:
                                [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString: MUSApp_TextView_PlaceholderText
                                      attributes:attrs];
    
    
    NSTextStorage* textStorage = [[NSTextStorage alloc] initWithAttributedString:attrString];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager:layoutManager];
    
    CGSize textSizeFrame = CGSizeMake([[UIScreen mainScreen] bounds].size.width,
                                      [[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height - self.galeryView.frame.size.height - self.buttonLocation.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeMake (textSizeFrame.width, textSizeFrame.height)];
    
//    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.changeSocialNetworkButton.frame.size.width + self.changeSocialNetworkButton.frame.origin.x, self.changeSocialNetworkButton.frame.size.height + self.changeSocialNetworkButton.frame.origin.x)];//for button
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 0)];//without button
    
    textContainer.exclusionPaths = @[rectanglePath];
    
    [layoutManager addTextContainer:textContainer];
    
    CGRect messageTextViewFrame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, textSizeFrame.width, textSizeFrame.height);
    
    self.messageTextView = [[UITextView alloc] initWithFrame: messageTextViewFrame textContainer: textContainer];
    self.messageTextView.editable = YES;
    self.messageTextView.scrollEnabled = YES;
    self.messageTextView.delegate = self;
    self.messageTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.tag = 0;
    self.messageTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.messageTextViewFrame = CGRectMake(self.messageTextView.frame.origin.x, self.messageTextView.frame.origin.y, self.messageTextView.frame.size.width, self.messageTextView.frame.size.height);
    [self.view addSubview:self.messageTextView];
    //[self.messageTextView addSubview: self.changeSocialNetworkButton];
}

- (void) initialParametersOfMessageTextView {
    /*
     text : "write something"
     */
    self.messageTextView.text = MUSApp_TextView_PlaceholderText;
    self.messageTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.tag = 0;
}

- (void) initialParametersOfMessageTextViewWhenStartingEditingText {
    self.messageTextView.text = MUSApp_TextView_PlaceholderWhenStartEditingTextView;
    self.messageTextView.textColor = [UIColor blackColor];
    self.messageTextView.tag = 1;
}


#pragma mark - Keyboard Show/Hide

#warning "order [self.view layoutIfNeeded];"

- (void) keyboardWillShow: (NSNotification*) notification {
    CGRect initialFrame = [[[notification userInfo] objectForKey : UIKeyboardFrameEndUserInfoKey] CGRectValue];
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
    self.messageTextView.frame = CGRectMake(self.messageTextViewFrame.origin.x,
                                            self.messageTextViewFrame.origin.y,
                                            self.messageTextViewFrame.size.width,
                                            self.messageTextViewFrame.size.height
                                            - convertedFrame.size.height +
                                            self.tabBarController.tabBar.frame.size.height + self.galeryView.frame.size.height - galeryViewHeight);
    [UIView animateWithDuration: 0.3  animations:^{
        [self.view layoutIfNeeded];
        [self.galeryView reloadCollectionView];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
}


- (void) keyboardWillHide: (NSNotification*) notification {
    self.toolBarLayoutConstraint.constant = self.toolBarLayoutConstraineOrigin;
    if ([self obtainSizeScreen] <= 480) {
        self.galeryViewLayoutConstraint.constant = self.GaleryViewLayoutConstraineOrigin;
    }
    [UIView beginAnimations:@"TableViewDown" context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.messageTextView.frame = self.messageTextViewFrame;
    [UIView commitAnimations];
    
    [UIView animateWithDuration: 0.4 animations:^{
        [self.view layoutIfNeeded];
        [self.galeryView reloadCollectionView];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self share];
    }
    
}

//- (void) startProgressView {
//    [self.tabBarController.view addSubview:self.progressBar.view];
//    [[MUSProgressBar sharedProgressBar] configurationProgressBar:self.post.arrayImages];
//    [self.progressBar setHeightView];
//}

//- (void) endProgressViewWithCountConnect :(NSNotification *) notification {
//    NSDictionary *dictionary = [notification object];
//    NSNumber *countConnect = [dictionary objectForKey: @"countConnectPosts"];
//    NSNumber *numberOfChosenNetworks = [dictionary objectForKey: @"numberOfSocialNetworks"];
//
//    //NSInteger numberOfChosenNetworks = [object] numberOfSocialNetworks
//    
//    [self.tabBarController.view addSubview:self.progressBarEndLoading.view];
//    [[MUSProgressBarEndLoading sharedProgressBarEndLoading] configurationProgressBar:self.post.arrayImages : [countConnect integerValue]: [numberOfChosenNetworks integerValue]];
//    [self.progressBarEndLoading setHeightView];
////    [self.progressBarEndLoading.viewWithPicsAndLable layoutIfNeeded];
////    self.progressBarEndLoading.viewHeightConstraint.constant = 42;
////    [UIView animateWithDuration:2 animations:^{
////        [self.progressBarEndLoading.viewWithPicsAndLable layoutIfNeeded];
////    } completion:^(BOOL finished) {
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
////            [self.progressBar.view removeFromSuperview];
////            [self.progressBarEndLoading.view removeFromSuperview];
////            self.progressBarEndLoading.viewHeightConstraint.constant = 0;
////        });
////    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                    //[self.progressBar.view removeFromSuperview];
//                    [self.progressBarEndLoading.view removeFromSuperview];
//                    //self.progressBarEndLoading.viewHeightConstraint.constant = 0;
//                });
//    
//    
//}


#pragma mark - Share Post to Social network
- (void) share {
    
    
     __weak MUSShareViewController *weakSelf = self;
    [_popVC removeFromParentViewController];
    [_popVC.view removeFromSuperview];
    _popVC = nil;
    //    if (!_currentSocialNetwork.isVisible || !_currentSocialNetwork || !_currentSocialNetwork.isLogin) {
    //        [self showAlertWithMessage: musAppError_Logged_Into_Social_Networks];
    //        return;
    //    }
    //    [self.shareButtonOutlet setCustomView:self.activityIndicator];
    //    [self.activityIndicator startAnimating];
    //    self.shareButtonOutlet.enabled = NO;
    //    self.view.userInteractionEnabled = NO;
    
    //        __weak MUSShareViewController *weakSelf = self;
    
    // NSArray *array = [[NSArray alloc] initWithObjects:  @(Facebook), nil];
    // __weak MUSShareViewController *weakSelf = self;
    // __block int count = 0;
    //__block float summa = 0;
    if (_arrayChosenNetworksForPost) {
        [self createPost];
        
        [[MUSMultySharingManager sharedManager] sharePost: self.post toSocialNetworks: _arrayChosenNetworksForPost withMultySharingResultBlock:^(NSDictionary *multyResultDictionary, MUSPost *post)  {
            [[MUSProgressBar sharedProgressBar] stopProgress];
            [[MUSProgressBarEndLoading sharedProgressBarEndLoading] endProgressViewWithCountConnect:multyResultDictionary andImagesArray: post.imagesArray];
        } startLoadingBlock:^(MUSPost *post) {
            [[MUSProgressBar sharedProgressBar] startProgressViewWithImages: post.imagesArray];
        } progressLoadingBlock:^(float result) {
            [[MUSProgressBar sharedProgressBar] setProgressViewSize: result];
            NSLog(@"result =%f", result);
            // [weakSelf.progressBar setProgressViewSize:result];
        }];
    }
    [self refreshShareScreen];

    
}

- (void) sharePosts : (NSMutableArray*) arrayChosenNetworksForPost andFlagTwitter:(BOOL)flagTwitter {//////////////////////////
    
    if (arrayChosenNetworksForPost == nil) {
        [_popVC removeFromParentViewController];
        [_popVC.view removeFromSuperview];
        _popVC = nil;
        return;
    }
     _arrayChosenNetworksForPost = arrayChosenNetworksForPost;
    if ([self.messageTextView.text length] >= MUSApp_TextView_Twitter_NumberOfAllowedLetters && flagTwitter) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle : @"Your tweet exceeds the limit of text and will be cut"
                                                             message : @"Continue sharing?"
                                                            delegate : self
                                                   cancelButtonTitle : @"Cancel"
                                                   otherButtonTitles : @"Share", nil];
        [errorAlert show];
        
    } else{
    [self share];
    }
}

- (IBAction)shareToSocialNetwork:(id)sender {
    _popVC = [MUSPopUpForSharing new];
    _popVC.delegate = self;
//    [self addChildViewController:popVC];
//     popVC.view.frame = self.view.bounds;//CGRectMake(0, 100, 200, 200);//
//    [self.view addSubview:popVC.view];
//    [popVC didMoveToParentViewController:self];
//    [self.view endEditing:YES];
    //[UIView animateWithDuration: 0.4 animations:^{
        [self.navigationController addChildViewController:_popVC];
    _popVC.view.frame = self.view.bounds;//CGRectMake(self.view.bounds.size.width/2-125, self.view.bounds.origin.y, 250, 350);//
  
        [self.navigationController.view addSubview:_popVC.view];
        [_popVC didMoveToParentViewController:self];
        [self.view endEditing:YES];
            //}];
    //[UIView commitAnimations];


    
    //////////////////////////////////////////////////////////////////////////////////////////////////
//    if (!_currentSocialNetwork.isVisible || !_currentSocialNetwork || !_currentSocialNetwork.isLogin) {
//        [self showAlertWithMessage: musAppError_Logged_Into_Social_Networks];
//        return;
//    }
////    [self.shareButtonOutlet setCustomView:self.activityIndicator];
////    [self.activityIndicator startAnimating];
////    self.shareButtonOutlet.enabled = NO;
////    self.view.userInteractionEnabled = NO;
//    [self createPost];
////        __weak MUSShareViewController *weakSelf = self;
//    
//    NSArray *array = [[NSArray alloc] initWithObjects: @(Twitters), @(Facebook), nil];
//    
//    [[MultySharingManager sharedManager] sharePost: self.post toSocialNetworks: array withComplition:^(id result, NSError *error) {
//        NSLog(@"RESULT %@", result);
//        NSLog(@"ERROR %@", error);
//    }];
//
    
    
    
    
//    
//    [_currentSocialNetwork sharePost:self.post withComplition:^(id result, NSError *error) {
//            if (result == nil && error == nil) {
//                [weakSelf.activityIndicator stopAnimating];
//                [weakSelf.shareButtonOutlet setCustomView:nil];
//                [weakSelf.shareButtonOutlet setTitle: @"Share"];
//
//                
//                [weakSelf refreshShareScreen];
//                weakSelf.view.userInteractionEnabled = YES;
//
//                return;
//            }
//            if (!error) {
//                [weakSelf showAlertWithMessage : titleCongratulatoryAlert];
//            } else {
//                [weakSelf showErrorAlertWithError : error];
//            }
//            [weakSelf.activityIndicator stopAnimating];
//            [weakSelf.shareButtonOutlet setCustomView:nil];
//            [weakSelf.shareButtonOutlet setTitle: @"Share"];
//            [weakSelf refreshShareScreen];
//            weakSelf.view.userInteractionEnabled = YES;
//
//    }];
}

- (void) refreshShareScreen {
    [self initialParametersOfMessageTextView];
    [self.messageTextView setSelectedRange:NSMakeRange(0, 0)];
    self.buttonLocation.selected = NO;
    [self.buttonLocation setTitle:@"Select your location" forState:UIControlStateNormal];
    self.place = nil;
    self.shareButtonOutlet.enabled = NO;
    self.longitude = @"";
    self.latitude = @"";
    if ([self.post.imagesArray count]) {
        [self.post.imagesArray removeAllObjects];
    }
        //self.view.userInteractionEnabled = YES;
//    [self.shareLocationButton setTintColor: [UIColor blackColor]];
//    [self.shareLocationButton setTitle: musAppButtonTitle_ShareLocation];
    //[self changeSharePhotoButtonColorAndShareButtonState:NO];
    [self.galeryView reloadCollectionView];
}

- (void) createPost { // later we would change logic , now we do for galleries)
    if(!self.post) {
        self.post = [[Post alloc] init];
        self.post.imagesArray = [NSMutableArray new];
    }
    self.post.place = self.place;
    if (![self.messageTextView.text isEqualToString: MUSApp_TextView_PlaceholderText]) {
        self.post.postDescription = self.messageTextView.text;
    } else {
        self.post.postDescription = @"";
    }
    //self.post.networkType = _currentSocialNetwork.networkType;
    self.post.longitude = self.longitude;
    self.post.latitude = self.latitude;
    /*
     get array with chosen images from MUSGaleryView
     */
    //self.post.arrayImages = [[self.galeryView obtainArrayWithChosenPics] mutableCopy];
    //self.post.userId = _currentSocialNetwork.currentUser.clientID;//or something else
    self.post.dateCreate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
}
#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    self.mainGestureRecognizer.enabled = YES;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        NSString *rawString = [textView text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        if ([trimmed length] == 0) {
            self.shareButtonOutlet.enabled = NO;
            [self initialParametersOfMessageTextView];
            [self.messageTextView setSelectedRange:NSMakeRange(0, 0)];
            return;
        }
        self.shareButtonOutlet.enabled = YES;
    } else {
        [self initialParametersOfMessageTextView];
        [self.messageTextView setSelectedRange:NSMakeRange(0, 0)];
        if (self.post.imagesArray.count < 1) {
            self.shareButtonOutlet.enabled = NO;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 0 && text.length > 0) {
//        if([text isEqualToString:@"\n"] || [text isEqualToString: @" "]) {
//            return 0;
//        }
        [self initialParametersOfMessageTextViewWhenStartingEditingText];
    }
//    if (_currentSocialNetwork.networkType != Twitters) {
    return textView.text.length + (text.length - range.length) <= MUSApp_MUSShareViewController_NumberOfAllowedLettersInTextView;
//    } else {
//        return textView.text.length + (text.length - range.length) <= musApp_TextView_CountOfAllowedLetters_ForTwitter;
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        self.shareButtonOutlet.enabled = [self checkingNumberPhotos];
    }  else if (textView.text.length == 0){
        [self initialParametersOfMessageTextView];
        self.shareButtonOutlet.enabled = [self checkingNumberPhotos];
    } else {
        self.shareButtonOutlet.enabled = YES;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([textView.text isEqualToString: MUSApp_TextView_PlaceholderText] && textView.textColor == [UIColor lightGrayColor]) {
        [self.messageTextView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (BOOL) checkingNumberPhotos {
    if (!self.post.imagesArray.count) {
        return NO;
    }
    return YES;
}


#pragma mark - UITapGestureRecognizer

- (IBAction)endEditingMessage:(id)sender {
    [self endEditingMessageTextView];
}

- (void) endEditingMessageTextView {
    [self.messageTextView resignFirstResponder];
    self.mainGestureRecognizer.enabled = NO;
}

#pragma mark - UIActionSheet

//- (void) showUserAccountsInActionSheet {
//    [self.socialNetworkAccountsArray removeAllObjects];
//    UIActionSheet* sheet = [UIActionSheet new];
//    sheet.title = titleActionSheet;
//    sheet.delegate = self;
//    sheet.cancelButtonIndex = [sheet addButtonWithTitle:musAppButtonTitle_Cancel];
//    self.arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
//    
//    __weak MUSShareViewController *weakSelf = self;
//    [[[SocialManager sharedManager] networks: self.arrayWithNetworks] enumerateObjectsUsingBlock:^(SocialNetwork *socialNetwork, NSUInteger index, BOOL *stop) {
//        if (socialNetwork.isLogin && socialNetwork.isVisible) {
//            NSString *buttonTitle = [NSString stringWithFormat:@"%@", socialNetwork.name];
//            [sheet addButtonWithTitle: buttonTitle];
//            [weakSelf.socialNetworkAccountsArray addObject:socialNetwork];
//        }
//    }];
//    [sheet showInView:self.view];
//    //[sheet showInView:[UIApplication sharedApplication].keyWindow];
//}
//
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0 ) {
        self.iconImageView.highlighted = NO;
        self.buttonLocation.selected = NO;
        [self.buttonLocation setTitle:@"Select your location" forState:UIControlStateNormal];
        self.latitude = @"";
        self.longitude = @"";
        ///////////delete location
        
        
//        /*
//         after a user chose new network we change current social network
//         */
//        NetworkType oldNetworkType = _currentSocialNetwork.networkType;
//        _currentSocialNetwork = [self.socialNetworkAccountsArray objectAtIndex: buttonIndex - 1];
//        if (oldNetworkType != _currentSocialNetwork.networkType) {
//            [self.shareLocationButton setTintColor: [UIColor blackColor]];
//            self.place = nil;
//            [self.shareLocationButton setTitle: musAppButtonTitle_ShareLocation];
//        }
//        
//        [self.changeSocialNetworkButton initiationSocialNetworkButtonForSocialNetwork:_currentSocialNetwork];
    }
}

#pragma mark - obtainChosenImage
/*!
 @method
 @abstract  get array chosen images from galeryView in order to check count of allowed pics than go to photomanager in order to chose any pic and pass chosen a pic to galeryView(for collectionView)
 @param without
 */
- (void) obtainChosenImage {
    if ([self.post.imagesArray count] == MUSApp_MUSShareViewController_NumberOfAllowedPics) {
        [self showAlertWithMessage : MUSApp_MUSShareViewController_Alert_Message_No_Pics_Anymore];
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


#pragma mark - error alert with error and alert with message
#warning "Same methods :("
- (void) showErrorAlertWithError : (NSError*) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle : @"NO INTERNET CONNECTION"//Error
                                                         message : @"You can resend this post from shared posts"//[error localizedFailureReason]
                                                        delegate : nil
                                               cancelButtonTitle : MUSApp_Button_Title_OK
                                               otherButtonTitles : nil];
    [errorAlert show];
}

- (void) showAlertWithMessage : (NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle : MUSApp_Error_With_Domain_Universal_Sharing
                                                    message : message
                                                   delegate : nil
                                          cancelButtonTitle : MUSApp_Button_Title_OK
                                          otherButtonTitles : nil];
    [alert show];
}


#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString: @"goToShowImages"]) {
        MUSMediaGalleryViewController *vc = [MUSMediaGalleryViewController new];        
        vc = [segue destinationViewController];
        vc.isEditableCollectionView = YES;
        //[vc setObjectsWithArrayOfPhotos: self.arrayPicsForDetailCollectionView withCurrentSocialNetwork: _currentSocialNetwork indexPicTapped:self.indexPicTapped andReasonTypeOfPost: MUSAllReasons];
        //[vc setObjectsWithPost:self.post withCurrentSocialNetwork:_currentSocialNetwork andIndexPicTapped:self.indexPicTapped];
        [vc sendPost:self.post andSelectedImageIndex:self.indexPicTapped];
    }
    
}

#pragma mark - MUSGaleryViewDelegate

- (void)changeSharePhotoButtonColorAndShareButtonState: (BOOL) isPhotos {
    if (!isPhotos) {
        [self.sharePhotoButton setTintColor:[UIColor blackColor]];
        if ([self.messageTextView.text isEqualToString:MUSApp_TextView_PlaceholderText]) {
            self.shareButtonOutlet.enabled = NO;
        }
    } else {
        [self.sharePhotoButton setTintColor:[UIColor redColor]];
        self.shareButtonOutlet.enabled = YES;
    }
}

- (void) showImageBySelectedImageIndex: (NSInteger)selectedImageIndex {
    //self.arrayPicsForDetailCollectionView = arrayPics;
    self.indexPicTapped = selectedImageIndex;
    [self performSegueWithIdentifier: @"goToShowImages" sender:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
