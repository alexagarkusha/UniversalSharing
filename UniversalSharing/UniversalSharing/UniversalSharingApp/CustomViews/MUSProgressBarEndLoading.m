//
//  MUSProgressBarEndLoading.m
//  UniversalSharing
//
//  Created by Roman on 10/5/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSProgressBarEndLoading.h"
#import "ConstantsApp.h"
#import "ImageToPost.h"

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
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint* viewHeightConstraint;
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
    //self.progressView.progress = MUSApp_MUSProgressBar_DefaultValueProgress;
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
            self.statusLabel.text = @"Published";
        }else if(countSuccessPosted == 0){
            self.statusLabel.text = @"Failed";
        }else if(countSuccessPosted == 1) {            
            self.statusLabel.text = [NSString stringWithFormat:@"1 from %ld was published",(long)countNetworks];
        } else {
            self.statusLabel.text = [NSString stringWithFormat:@"%ld from %ld were published",(long)countSuccessPosted,(long)countNetworks];            
        }
    
    
    [self clearImageViews];
    if(postImagesArray.count){
        ImageToPost *image;
        self.lableWidthConstraint.constant = MUSApp_MUSProgressBar_Label_DefaultWidthConstraint;
        for (int i = 0; i < postImagesArray.count; i++) {
            image = postImagesArray[i];
            if (i < [self.imageViewsArray count]) {
                UIImageView *currentImage =  self.imageViewsArray[i];
                currentImage.image = image.image;
            }
            
        }
        
    } else {
        self.lableWidthConstraint.constant = MUSApp_MUSProgressBar_Label_WidthConstraint;
    }
}

- (void) endProgressViewWithCountConnect :(NSDictionary *) dictionary andImagesArray : (NSArray*) imagesArray {
    NSNumber *countConnect = [dictionary objectForKey: @"countConnectPosts"];
    NSNumber *numberOfChosenNetworks = [dictionary objectForKey: @"numberOfSocialNetworks"];
   [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [self configurationProgressBarWithImages:imagesArray countSuccessPosted: [countConnect integerValue]andCountNetworks: [numberOfChosenNetworks integerValue]];
    [self setHeightView];
}
- (void) setHeightView {
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
    for (int i = 0; i < self.imageViewsArray.count; i++) {
        
        UIImageView *currentImage =  self.imageViewsArray[i];
        currentImage.image = nil;
    }
}

@end
