//
//  MUSProgressBarEndLoading.h
//  UniversalSharing
//
//  Created by Roman on 10/5/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSProgressBarEndLoading : UIView

@property (strong, nonatomic)  UIView *view;
//===
+ (MUSProgressBarEndLoading*) sharedProgressBarEndLoading;
- (void) configurationProgressBar: (NSArray*) postImagesArray  :(NSInteger) countSuccessPosted :(NSInteger) countNetworks;
- (void) setHeightView;

@end
