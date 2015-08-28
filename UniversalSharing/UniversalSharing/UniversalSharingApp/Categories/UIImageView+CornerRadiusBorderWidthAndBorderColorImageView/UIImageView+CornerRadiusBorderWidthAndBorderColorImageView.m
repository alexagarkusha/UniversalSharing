//
//  UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.m
//  UniversalSharing
//
//  Created by U 2 on 28.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"

@implementation UIImageView (CornerRadiusBorderWidthAndBorderColorImageView)

- (void) cornerRadius: (CGFloat) radius andBorderWidth : (CGFloat) borderWidth withBorderColor : (UIColor*) borderColor {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

@end
