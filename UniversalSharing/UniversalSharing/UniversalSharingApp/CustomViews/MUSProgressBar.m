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
@property (strong, nonatomic) NSArray *arrayOfImageView;


@end
@implementation MUSProgressBar
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
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"MUSProgressBar" owner:self options:nil];
    self.progressView.progressTintColor = BROWN_COLOR_MIDLight;
     self.arrayOfImageView = [[NSArray alloc] initWithObjects: self.imageViewPostFirst, self.imageViewPostSecond, self.imageViewPostThird, nil];
    //[self initiationGestureRecognizer];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
   
}

- (void) configurationProgresBar: (NSArray*) arrayImages {
    self.labelStutus.text = @"Publishing";
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
