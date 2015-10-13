//
//  MUSProgressBar.m
//  UniversalSharing
//
//  Created by Roman on 10/2/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSProgressBar.h"
#import "ConstantsApp.h"
#import "ImageToPost.h"

@interface MUSProgressBar()

@property (strong, nonatomic) NSArray *imageViewsArray;
//===
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lableWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* viewHeightConstraint;

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
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        ///////////////////////////////////////////////////////////////////
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
        CGFloat navigationBarHeight = navigationController.navigationBar.frame.size.height;
        self.view.frame = CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight);
        //////////////////////////////////////////////////////////////////
        [self addSubview:self.view];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview:self.view];
    }
    return self;
}

-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"MUSProgressBar" owner:self options:nil];
    self.progressView.progressTintColor = DARK_BROWN_COLOR_WITH_ALPHA_07;
    self.progressView.progress = 0;
    self.viewHeightConstraint.constant = 0;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startProgressViewWithImages:) name:@"StartSharePost" object:nil];
//    ////////
     self.imageViewsArray = [[NSArray alloc] initWithObjects: self.thirdImageView, self.secondImageView, self.firstImageView, nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
   
}

- (void) configurationProgressBar: (NSArray*) postImagesArray{
         self.statusLabel.text = @"Publishing";
   
    [self clearImageViews];
    if(postImagesArray.count){
        ImageToPost *image;
        self.lableWidthConstraint.constant = 50;
        for (int i = 0; i < postImagesArray.count; i++) {
            image = postImagesArray[i];
            if (i < 3) {
                UIImageView *currentImage =  self.imageViewsArray[i];
                currentImage.image = image.image;
            }
        }
    } else {
        self.lableWidthConstraint.constant = 8;
    }
}

- (void) setHeightView {
    self.progressView.progress = 0;
    [self.contentView layoutIfNeeded];
    
    __weak MUSProgressBar *weakSelf = self;
   self.viewHeightConstraint.constant = 42;
    [UIView animateWithDuration:1 animations:^{
        
        [weakSelf.contentView layoutIfNeeded];
    }];
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.contentView layoutIfNeeded];
        
        weakSelf.viewHeightConstraint.constant = 0;
        [UIView animateWithDuration:1 animations:^{
            
            [weakSelf.contentView layoutIfNeeded];
            //[self.view removeFromSuperview];
            if (self.progressView.progress == 1) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self.view removeFromSuperview];
                         });
            }
        }];
        [UIView commitAnimations];
    });
}

- (void) startProgressViewWithImages :(NSArray*) postImagesArray {
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [self configurationProgressBar:postImagesArray];
    [self setHeightView];
}
- (void) setProgressViewSize :(float) progress {
    self.progressView.progress = progress;
    if (progress == 1) {
//         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self.view removeFromSuperview];
//         });
    }
}

- (void) clearImageViews {
    for (int i = 0; i < self.imageViewsArray.count; i++) {
            UIImageView *currentImage =  self.imageViewsArray[i];
            currentImage.image = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
