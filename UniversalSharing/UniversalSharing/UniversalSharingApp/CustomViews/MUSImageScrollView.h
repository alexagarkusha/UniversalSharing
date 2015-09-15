//
//  MUSImageScrollView.h
//  UniversalSharing
//
//  Created by Roman on 9/14/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSImageScrollView : UIScrollView

@property (nonatomic) NSUInteger index;

- (void)displayImage:(UIImage *)image;
//+ (NSUInteger)imageCount;

@end
