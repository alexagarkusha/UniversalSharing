//
//  MUSProgressBar.m
//  UniversalSharing
//
//  Created by Roman on 10/2/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSProgressBar.h"
#import "MUSConstantsApp.h"
#import "MUSImageToPost.h"

@interface MUSProgressBar()

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

static MUSProgressBar *model = nil;

@implementation MUSProgressBar

+ (MUSProgressBar*) sharedProgressBar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSProgressBar alloc] init];
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
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed: MUSApp_MUSProgressBar_NibName owner:self options:nil];
    self.progressView.progressTintColor = DARK_BROWN_COLOR_WITH_ALPHA_07;
    self.progressView.progress = MUSApp_MUSProgressBar_DefaultValueProgress;
    self.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_HeightConstraint;
    self.imageViewsArray = [[NSArray alloc] initWithObjects: self.thirdImageView, self.secondImageView, self.firstImageView, nil];
    return [nibObjects firstObject];
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

- (void) configurationProgressBar: (NSArray*) postImagesArray {
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

- (void) startProgress {
    self.progressView.progress = MUSApp_MUSProgressBar_DefaultValueProgress;
    [self.contentView layoutIfNeeded];
    __weak MUSProgressBar *weakSelf = self;
    self.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_DefaultHeightConstraint;
    [UIView animateWithDuration:1 animations:^{
        [weakSelf.contentView layoutIfNeeded];
    }];
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.contentView layoutIfNeeded];
        weakSelf.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_HeightConstraint;
        [UIView animateWithDuration:1 animations:^{
            [weakSelf.contentView layoutIfNeeded];
        }];
        [UIView commitAnimations];
    });
}

- (void) startProgressViewWithImages :(NSArray*) postImagesArray {
    [self configurationProgressBar:postImagesArray];
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [self startProgress];
}

- (void) setProgressViewSize :(float) progress {
    self.progressView.progress = progress;
}

-(void)stopProgress{
    __weak MUSProgressBar *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.contentView layoutIfNeeded];
        weakSelf.viewBottomOffsetConstraint.constant = MUSApp_MUSProgressBar_View_HeightConstraint;
        
        [UIView animateWithDuration:1 animations:^{
            [weakSelf.contentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    });
}

- (void) clearImageViews {
    for (UIImageView *imageView in self.imageViewsArray) {
        imageView.image = nil;
    }
}

@end
