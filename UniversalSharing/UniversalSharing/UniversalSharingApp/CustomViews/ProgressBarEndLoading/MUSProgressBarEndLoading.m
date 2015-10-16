//
//  MUSProgressBarEndLoading.m
//  UniversalSharing
//
//  Created by Roman on 10/5/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSProgressBarEndLoading.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "MUSConstantsApp.h"
#import "MUSImageToPost.h"

@interface MUSProgressBarEndLoading()

@property (strong, nonatomic)  UIView *view;
@property (strong, nonatomic) NSArray *imageViewsArray;
//===
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lableWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* viewBottomOffsetConstraint;

@end

static MUSProgressBarEndLoading *model = nil;

@implementation MUSProgressBarEndLoading

+ (MUSProgressBarEndLoading*) sharedProgressBarEndLoading {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSProgressBarEndLoading alloc] init];
    });
    return  model;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [self loadViewFromNib];
        self.view.frame = [self setUpFrame];
        [self addSubview:self.view];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [self loadViewFromNib];
        self.view.frame = [self setUpFrame];
        [self addSubview:self.view];
    }
    return self;
}

-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:MUSApp_MUSProgressBarEndLoading_NibName owner:self options:nil];
    self.progressView.progressTintColor = DARK_BROWN_COLOR_WITH_ALPHA_07;
    self.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_HeightConstraint;
    self.imageViewsArray = [[NSArray alloc] initWithObjects: self.thirdImageView, self.secondImageView, self.firstImageView, nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    
}

- (CGRect) setUpFrame {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
        CGFloat navigationBarHeight = navigationController.navigationBar.frame.size.height;
        return  CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight);
    } else {
        return  CGRectMake(0, statusBarHeight, self.view.frame.size.width, 44);
    }
}

- (void) configurationProgressBarWithImages: (NSArray*) postImagesArray  countSuccessPosted:(NSInteger) countSuccessPosted andCountNetworks:(NSInteger) countNetworks {
    if (countSuccessPosted == countNetworks) {
        self.statusLabel.text = MUSApp_MUSProgressBarEndLoading_Label_Title_Published;
    }else if(countSuccessPosted == 0){
        self.statusLabel.text = MUSApp_MUSProgressBarEndLoading_Label_Title_Failed;
    }else if(countSuccessPosted == 1) {
        self.statusLabel.text = [NSString stringWithFormat:@"1 from %ld was published",(long)countNetworks];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%ld from %ld were published",(long)countSuccessPosted,(long)countNetworks];
    }
    
    [self clearImageViews];
    if(postImagesArray.count){
        self.lableWidthConstraint.constant = MUSApp_MUSProgressBar_Label_DefaultWidthConstraint;
        for (int i = 0; i < self.imageViewsArray.count; i++) {
            if (postImagesArray.count > i) {
                MUSImageToPost *image = postImagesArray[i];
                UIImageView *currentImage =  self.imageViewsArray[i];
                currentImage.image = image.image;
            }
        }
    } else {
        self.lableWidthConstraint.constant = MUSApp_MUSProgressBar_Label_WidthConstraint;
    }
}

- (void) endProgressViewWithCountConnect :(NSDictionary *) dictionary andImagesArray : (NSArray*) imagesArray {
    NSArray *allValuesArray = [dictionary allValues];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"Result == %d", MUSConnect];
    NSArray *successArray =[allValuesArray filteredArrayUsingPredicate:predicate];
    [self configurationProgressBarWithImages:imagesArray countSuccessPosted: successArray.count andCountNetworks: allValuesArray.count];
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [self startProgress];
}

- (void) startProgress {
    [self.contentView layoutIfNeeded];
    self.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_DefaultHeightConstraint;
    [UIView animateWithDuration:2 animations:^{
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.contentView layoutIfNeeded];            
            self.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_HeightConstraint;
            [UIView animateWithDuration:1 animations:^{
                [self.contentView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        });
    }];
}

- (void) clearImageViews {
    for (UIImageView *imageView in self.imageViewsArray) {
        imageView.image = nil;
    }
}

@end
