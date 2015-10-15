//
//  MUSProgressBar.h
//  UniversalSharing
//
//  Created by Roman on 10/2/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSProgressBar : UIView

+ (MUSProgressBar*) sharedProgressBar;
- (void) setProgressViewSize :(float) progress;
- (void) startProgressViewWithImages :(NSArray*) postImagesArray;
- (void) stopProgress;

@end
