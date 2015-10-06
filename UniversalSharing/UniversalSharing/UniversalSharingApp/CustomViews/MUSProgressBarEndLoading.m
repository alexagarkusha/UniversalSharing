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
@property (strong, nonatomic) NSArray *arrayOfImageView;


@end
@implementation MUSProgressBarEndLoading
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [self loadViewFromNib];
        self.view.frame = frame;
        [self addSubview:self.view];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview:self.view];
    }
    return self;
}


-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"MUSProgressBarEndLoading" owner:self options:nil];
    self.progressView.progressTintColor = BROWN_COLOR_MIDLight;
    self.progressView.progress = 1;
    self.arrayOfImageView = [[NSArray alloc] initWithObjects: self.imageViewPostThird, self.imageViewPostSecond, self.imageViewPostFirst, nil];
    //[self initiationGestureRecognizer];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    
}

- (void) configurationProgressBar: (NSArray*) arrayImages  :(NSInteger) countSuccessPosted :(NSInteger) countNetworks {
   
        if (countSuccessPosted == countNetworks) {
            self.labelStutus.text = @"Published";
        }else if(countSuccessPosted == 0){
            self.labelStutus.text    = @"Failed";
        }else if(countSuccessPosted == 1) {
            
            self.labelStutus.text = [NSString stringWithFormat:@"1 from %ld was published",(long)countNetworks];
        } else {
            self.labelStutus.text = [NSString stringWithFormat:@"%ld from %ld were published",(long)countSuccessPosted,(long)countNetworks];
            
        }
    
    
    [self clearImageViews];
    if(arrayImages.count){
        ImageToPost *image;
        self.lableConstraint.constant = 50;
        for (int i = 0; i < arrayImages.count; i++) {
            image = arrayImages[i];
            if (i < 3) {
                UIImageView *currentImage =  self.arrayOfImageView[i];
                currentImage.image = image.image;
            }
            
        }
        
    } else {
        //self.progressBar.imageViewPost.image = nil;
        self.lableConstraint.constant = 8;
        
    }
    
    
    
}

- (void) clearImageViews {
    for (int i = 0; i < self.arrayOfImageView.count; i++) {
        
        UIImageView *currentImage =  self.arrayOfImageView[i];
        currentImage.image = nil;
    }
}
@end
