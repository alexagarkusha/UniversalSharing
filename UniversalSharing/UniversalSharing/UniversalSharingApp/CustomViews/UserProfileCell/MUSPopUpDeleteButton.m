//
//  MUSPopUpDeleteButton.m
//  UniversalSharing
//
//  Created by Roman on 9/30/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPopUpDeleteButton.h"

@implementation MUSPopUpDeleteButton
- (void)drawRect:(CGRect)rect {
    UIImage *deleteIconImage = [UIImage imageNamed: @"close6.png"];
    UIGraphicsBeginImageContext(rect.size);
    [deleteIconImage drawInRect: rect];
    deleteIconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.layer.masksToBounds = YES;
    self.tintColor = [UIColor blackColor];
    [self setImage: deleteIconImage forState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(5, self.frame.size.height / 3, self.frame.size.height / 3, 5);
    [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
}

@end
