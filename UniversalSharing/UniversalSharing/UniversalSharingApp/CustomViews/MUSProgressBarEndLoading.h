//
//  MUSProgressBarEndLoading.h
//  UniversalSharing
//
//  Created by Roman on 10/5/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSProgressBarEndLoading : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPostThird;

@property (weak, nonatomic) IBOutlet UILabel *labelStutus;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
//@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic)  UIView *view;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* lableConstraint;
//@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* viewConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewWithPicsAndLable;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* viewHeightConstraint;
+ (MUSProgressBarEndLoading*) sharedProgressBarEndLoading;
- (void) configurationProgressBar: (NSArray*) arrayImages  :(NSInteger) countSuccessPosted :(NSInteger) countNetworks;
@end
