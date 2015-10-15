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
#import <CoreText/CoreText.h>
#import "MUSMediaGalleryViewController.h"
#import "MUSPopUpForSharing.h"
#import "MUSProgressBar.h"
#import "MUSProgressBarEndLoading.h"

@interface MUSShareViewController () <UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIToolbarDelegate, MUSGaleryViewDelegate, MUSPopUpForSharingDelegate>

- (IBAction)shareToSocialNetwork:(id)sender;

- (IBAction)endEditingMessage:(id)sender;

@property (strong, nonatomic)   IBOutlet    UITapGestureRecognizer *mainGestureRecognizer;
@property (weak, nonatomic)     IBOutlet    UIBarButtonItem *shareButtonOutlet;
/*!
 @property
 @abstract  in order to up toolbar when the keyboard appears
 */
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* toolBarLayoutConstraint;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* heightGaleryViewLayoutConstraint;
/*!
 @property
 @abstract object with chosen pics and xib with collectionView
 */
@property (weak, nonatomic)     IBOutlet    MUSGaleryView *galeryView;

@property (weak, nonatomic)     IBOutlet    UIButton *buttonLocation;

@property (weak, nonatomic)     IBOutlet    UIImageView *iconImageView;
/*!
 @property
 @abstract  in order to save origin position toolbar and return back when the keyboard disappears
 */
@property (assign, nonatomic)               CGFloat toolBarLayoutConstraineOrigin;
/*!
 @property
 @abstract  in order to save origin position galeryView and return back when the keyboard disappears
 */
@property (assign, nonatomic)               CGFloat galeryViewLayoutConstraineOrigin;

/*!
 @property
 @abstract  in order to save origin position textView and return back when the keyboard disappears
 */
@property (assign, nonatomic)               CGFloat messageTextViewLayoutConstraintOrigin;
@property (strong, nonatomic)               MUSSocialNetwork *currentSocialNetwork;

@property (strong, nonatomic)               MUSPost *post;

@property (strong, nonatomic)               UITextView *messageTextView;

@property (assign, nonatomic)               CGRect messageTextViewFrame;

@property (assign, nonatomic)               NSInteger indexPicTapped;

@property (strong, nonatomic)               MUSPopUpForSharing * popVC ;

@property (strong, nonatomic)               NSString *address;

@property (strong, nonatomic)               NSArray *arrayChosenNetworksForPost;

@end

@implementation MUSShareViewController

#pragma mark - ViewMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiationNavigationBar];
    [self initiationMessageTextView];
    [self initiationMUSShareViewController];
    [self initiationPost];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(obtainChosenImage) name:MUSShowImagePickerForAddImageInCollectionView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillShow:)
                                                 name : UIKeyboardWillShowNotification
                                               object : nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(keyboardWillHide:)
                                                 name : UIKeyboardWillHideNotification
                                               object : nil];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (!self.post.imagesArray.count && [self.messageTextView.text isEqualToString: MUSApp_TextView_PlaceholderText] && self.messageTextView.textColor == [UIColor lightGrayColor]) {
        self.shareButtonOutlet.enabled = NO;
    }
    self.mainGestureRecognizer.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self endEditingMessageTextView];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

#pragma mark - initiation NavigationBar

- (void) initiationNavigationBar {
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: DARK_BROWN_COLOR}];
    [self.shareButtonOutlet setTintColor: DARK_BROWN_COLOR];
    [self.shareButtonOutlet setStyle:2];
}


#pragma mark - initiation Message UITextView

/*!
 @method
 @abstract  initiation Message Text View
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
}

#pragma mark - initial Parameters Of Message TextView

- (void) initialParametersOfMessageTextView {
    /*
     text : "write something"
     */
    self.messageTextView.text = MUSApp_TextView_PlaceholderText;
    self.messageTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.tag = 0;
}

#pragma mark - initial Parameters Of Message Text View When Starting Editing Text

- (void) initialParametersOfMessageTextViewWhenStartingEditingText {
    self.messageTextView.text = MUSApp_TextView_PlaceholderWhenStartEditingTextView;
    self.messageTextView.textColor = [UIColor blackColor];
    self.messageTextView.tag = 1;
}


#pragma mark - initiation MUSShareViewController

- (void) initiationMUSShareViewController {
    self.galeryView.delegate = self;
    self.shareButtonOutlet.enabled = NO;
    self.toolBarLayoutConstraineOrigin = self.toolBarLayoutConstraint.constant;
    if ([self obtainSizeScreen] <= 480) {
        self.galeryViewLayoutConstraineOrigin = self.heightGaleryViewLayoutConstraint.constant;
    }
}

#pragma mark - initiation Post

- (void) initiationPost {
    if(!self.post) self.post = [MUSPost create];
    [self.galeryView setUpPost:self.post];
}


#pragma mark - Location Button Tapped

- (IBAction) buttonLocationTapped:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self obtainCurrentLocation];
    } else {
        [self showLocationActionSheet];
    }
}

#pragma mark - Obtain Current Location

- (void) obtainCurrentLocation {
    __weak MUSShareViewController *weakSelf = self;
    [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(CLLocation* location, NSError *error) {
        weakSelf.post.latitude = [NSString stringWithFormat: @"%f",location.coordinate.latitude];
        weakSelf.post.longitude = [NSString stringWithFormat: @"%f",location.coordinate.longitude];
        [[MUSLocationManager sharedManager] obtainAddressFromLocation:location complitionBlock:^(NSString *address, NSError *error) {
            self.address = address;
            [self.buttonLocation setTitle:address forState:UIControlStateNormal];
            self.iconImageView.highlighted = !self.iconImageView.highlighted;
        }];
    }];
}

#pragma mark - Show Current Location

- (void) showLocationActionSheet {
    UIActionSheet* sheet = [UIActionSheet new];
    sheet.title = self.address;
    sheet.delegate = self;
    [sheet addButtonWithTitle: @"Delete"];
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:MUSApp_Button_Title_Cancel];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0 ) {
        self.iconImageView.highlighted = NO;
        self.buttonLocation.selected = NO;
        [self.buttonLocation setTitle:@"Select your location" forState:UIControlStateNormal];
        self.post.latitude = @"";
        self.post.longitude = @"";
    }
}


/*!
 @method
 @abstract  disappear keyboard when touch other place
 @param event
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void) sharePosts : (NSMutableArray*) arrayChosenNetworksForPost andFlagTwitter:(BOOL)flagTwitter {
    if (arrayChosenNetworksForPost == nil) {
        [_popVC removeFromParentViewController];
        [_popVC.view removeFromSuperview];
        _popVC = nil;
        return;
    }
     _arrayChosenNetworksForPost = arrayChosenNetworksForPost;
    if ([self.messageTextView.text length] >= MUSApp_TextView_Twitter_NumberOfAllowedLetters && flagTwitter) {
        [self showErrorAlert];
    } else{
        [self share];
    }
}


#pragma mark - Error Alert

- (void) showErrorAlert {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle : @"Your tweet exceeds the limit of text and will be cut"
                                                     message : @"Continue sharing?"
                                                    delegate : self
                                           cancelButtonTitle : @"Cancel"
                                           otherButtonTitles : @"Share", nil];
    [errorAlert show];
}

#pragma mark - Error Alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self share];
    }
}


#pragma mark - Share Post to Social network

- (IBAction) shareToSocialNetwork: (id)sender {
    _popVC = [MUSPopUpForSharing new];
    _popVC.delegate = self;
    [self.navigationController addChildViewController:_popVC];
    _popVC.view.frame = self.view.bounds;//CGRectMake(self.view.bounds.size.width/2-125, self.view.bounds.origin.y, 250, 350);//
    [self.navigationController.view addSubview:_popVC.view];
    [_popVC didMoveToParentViewController:self];
    [self.view endEditing:YES];
}

- (void) share {
    [_popVC removeFromParentViewController];
    [_popVC.view removeFromSuperview];
    _popVC = nil;
    if (_arrayChosenNetworksForPost) {
        [self addDateCreateAndPostDescriptionToPost];
        
        [[MUSMultySharingManager sharedManager] sharePost: self.post toSocialNetworks: _arrayChosenNetworksForPost withMultySharingResultBlock:^(NSDictionary *multyResultDictionary, MUSPost *post)  {
            [[MUSProgressBar sharedProgressBar] stopProgress];
            [[MUSProgressBarEndLoading sharedProgressBarEndLoading] endProgressViewWithCountConnect:multyResultDictionary andImagesArray: post.imagesArray];
        } startLoadingBlock:^(MUSPost *post) {
            [[MUSProgressBar sharedProgressBar] startProgressViewWithImages: post.imagesArray];
        } progressLoadingBlock:^(float result) {
            [[MUSProgressBar sharedProgressBar] setProgressViewSize: result];
        }];
    }
    [self refreshShareScreen];
}

- (void) refreshShareScreen {
    [self initialParametersOfMessageTextView];
    [self.messageTextView setSelectedRange:NSMakeRange(0, 0)];
    self.buttonLocation.selected = NO;
    [self.buttonLocation setTitle:@"Select your location" forState:UIControlStateNormal];
    self.shareButtonOutlet.enabled = NO;
    [self.post clear];
    [self.galeryView reloadCollectionView];
}

- (void) addDateCreateAndPostDescriptionToPost {
    if (![self.messageTextView.text isEqualToString: MUSApp_TextView_PlaceholderText]) {
        self.post.postDescription = self.messageTextView.text;
    } else {
        self.post.postDescription = @"";
    }
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
        [self initialParametersOfMessageTextViewWhenStartingEditingText];
    }
    return textView.text.length + (text.length - range.length) <= MUSApp_MUSShareViewController_NumberOfAllowedLettersInTextView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        self.shareButtonOutlet.enabled = [self hasPostImages];
    }  else if (textView.text.length == 0){
        [self initialParametersOfMessageTextView];
        self.shareButtonOutlet.enabled = [self hasPostImages];
    } else {
        self.shareButtonOutlet.enabled = YES;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([textView.text isEqualToString: MUSApp_TextView_PlaceholderText] && textView.textColor == [UIColor lightGrayColor]) {
        [self.messageTextView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (BOOL) hasPostImages {
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

#pragma mark - notificationImagePickerForCollection
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
    [[MUSPhotoManager sharedManager] showPhotoFromViewController:self withComplition:^(id result, NSError *error) {
        if(!error) {
            [weakSelf.galeryView passChosenImageForCollection:result];
        } else {
            NSLog(@"Error : %@", error);
            return;
        }
    }];
}

#pragma mark Alert with message

- (void) showAlertWithMessage : (NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle : MUSApp_Error_With_Domain_Universal_Sharing
                                                    message : message
                                                   delegate : nil
                                          cancelButtonTitle : MUSApp_Button_Title_OK
                                          otherButtonTitles : nil];
    [alert show];
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
        self.heightGaleryViewLayoutConstraint.constant = galeryViewHeight;
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
        self.heightGaleryViewLayoutConstraint.constant = self.galeryViewLayoutConstraineOrigin;
    }
    [UIView beginAnimations:@"Down" context:NULL];
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

- (CGFloat) obtainSizeScreen {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString: MUSApp_SegueIdentifier_GoToMediaGalleryViewController]) {
        MUSMediaGalleryViewController *vc = [MUSMediaGalleryViewController new];        
        vc = [segue destinationViewController];
        vc.isEditableCollectionView = YES;
        [vc sendPost:self.post andSelectedImageIndex:self.indexPicTapped];
    }
}

#pragma mark - MUSGaleryViewDelegate

- (void) changeShareButtonState: (BOOL) isPhotos {
    if (!isPhotos) {
        if ([self.messageTextView.text isEqualToString:MUSApp_TextView_PlaceholderText]) {
            self.shareButtonOutlet.enabled = NO;
        }
    } else {
        self.shareButtonOutlet.enabled = YES;
    }
}

- (void) showImageBySelectedImageIndex: (NSInteger)selectedImageIndex {
    self.indexPicTapped = selectedImageIndex;
    [self performSegueWithIdentifier: MUSApp_SegueIdentifier_GoToMediaGalleryViewController sender:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
