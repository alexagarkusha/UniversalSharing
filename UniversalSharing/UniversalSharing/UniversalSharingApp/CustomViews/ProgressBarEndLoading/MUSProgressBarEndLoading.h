//
//  MUSProgressBarEndLoading.h
//  UniversalSharing
//
//  Created by Roman on 10/5/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSProgressBarEndLoading : UIView

+ (MUSProgressBarEndLoading*) sharedProgressBarEndLoading;
- (void) endProgressViewWithCountConnect :(NSDictionary *) dictionary andImagesArray : (NSArray*) imagesArray;

@end
