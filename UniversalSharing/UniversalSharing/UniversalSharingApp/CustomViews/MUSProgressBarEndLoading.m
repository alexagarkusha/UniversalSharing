//
//  MUSProgressBarEndLoading.m
//  UniversalSharing
//
//  Created by Roman on 10/5/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSProgressBarEndLoading.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "ConstantsApp.h"
#import "ImageToPost.h"

@interface MUSProgressBarEndLoading()

@property (strong, nonatomic) NSArray *imageViewsArray;
//===
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostThird;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lableWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewWithPicsAndLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* viewHeightConstraint;

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
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
        CGFloat navigationBarHeight = navigationController.navigationBar.frame.size.height;
        self.view.frame = CGRectMake(0, statusBarHeight, self.view.frame.size.width, navigationBarHeight);
        //self.view.frame = frame;
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
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"MUSProgressBarEndLoading" owner:self options:nil];
    self.progressView.progressTintColor = DARK_BROWN_COLOR_WITH_ALPHA_07;
    self.progressView.progress = 1;
     self.viewHeightConstraint.constant = 0;
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endProgressViewWithCountConnect:) name:@"EndSharePost" object:nil ];
    self.imageViewsArray = [[NSArray alloc] initWithObjects: self.imageViewPostThird, self.imageViewPostSecond, self.imageViewPostFirst, nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    
}

- (void) configurationProgressBar: (NSArray*) postImagesArray  :(NSInteger) countSuccessPosted :(NSInteger) countNetworks {   
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
        self.lableWidthConstraint.constant = 50;
        for (int i = 0; i < postImagesArray.count; i++) {
            image = postImagesArray[i];
            if (i < 3) {
                UIImageView *currentImage =  self.imageViewsArray[i];
                currentImage.image = image.image;
            }
            
        }
        
    } else {
        //self.progressBar.imageViewPost.image = nil;
        self.lableWidthConstraint.constant = 8;
        
    }
}

- (void) endProgressViewWithCountConnect :(NSDictionary *) dictionary andImagesArray : (NSArray*) imagesArray {
    
    NSArray *allValuesArray = [dictionary allValues];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"Result == %d", MUSConnect];
    NSArray *successArray =[allValuesArray filteredArrayUsingPredicate:predicate];
    
   [[UIApplication sharedApplication].keyWindow addSubview:self.view];

    [self configurationProgressBar : imagesArray : successArray.count: allValuesArray.count];
    
    //[self configurationProgressBar:imagesArray : [countConnect integerValue]: [numberOfChosenNetworks integerValue]];
    
    [self setHeightView];
}
- (void) setHeightView {
    [self.viewWithPicsAndLable layoutIfNeeded];
    self.viewHeightConstraint.constant = 42;
    [UIView animateWithDuration:2 animations:^{
        [self.viewWithPicsAndLable layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.viewHeightConstraint.constant = 0;
            [self.view removeFromSuperview];
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
