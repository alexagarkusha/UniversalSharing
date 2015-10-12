//
//  MUSProgressBar.h
//  UniversalSharing
//
//  Created by Roman on 10/2/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSProgressBar : UIView

@property (strong, nonatomic)  UIView *view;
//===
+ (MUSProgressBar*) sharedProgressBar;
- (void) configurationProgressBar: (NSArray*) postImagesArray;
- (void) setHeightView;
- (void) setProgressViewSize :(float) progress;

@end
