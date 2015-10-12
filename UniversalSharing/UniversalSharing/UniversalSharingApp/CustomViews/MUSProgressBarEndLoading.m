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

@property (strong, nonatomic) NSArray *imageViewsArray;
//===
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostThird;
@property (weak, nonatomic) IBOutlet UILabel *labelStutus;
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
        self.view.frame = frame;
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
    self.imageViewsArray = [[NSArray alloc] initWithObjects: self.imageViewPostThird, self.imageViewPostSecond, self.imageViewPostFirst, nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    
}

- (void) configurationProgressBar: (NSArray*) postImagesArray  :(NSInteger) countSuccessPosted :(NSInteger) countNetworks {   
        if (countSuccessPosted == countNetworks) {
            self.labelStutus.text = @"Published";
        }else if(countSuccessPosted == 0){
            self.labelStutus.text = @"Failed";
        }else if(countSuccessPosted == 1) {
            
            self.labelStutus.text = [NSString stringWithFormat:@"1 from %ld was published",(long)countNetworks];
        } else {
            self.labelStutus.text = [NSString stringWithFormat:@"%ld from %ld were published",(long)countSuccessPosted,(long)countNetworks];
            
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

- (void) setHeightView {
    [self.viewWithPicsAndLable layoutIfNeeded];
    self.viewHeightConstraint.constant = 42;
    [UIView animateWithDuration:2 animations:^{
        [self.viewWithPicsAndLable layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.viewHeightConstraint.constant = 0;
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
