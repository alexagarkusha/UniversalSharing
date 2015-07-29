//
//  UIButton+CornerRadiusButton.m
//  UniversalSharing
//
//  Created by U 2 on 28.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIButton+CornerRadiusButton.h"

@implementation UIButton (CornerRadiusButton)

- (void) cornerRadius: (CGFloat) radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

@end
