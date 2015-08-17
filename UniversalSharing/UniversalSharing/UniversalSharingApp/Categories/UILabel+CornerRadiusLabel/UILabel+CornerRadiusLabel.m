//
//  UILabel+CornerRadiusLabel.m
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UILabel+CornerRadiusLabel.h"

@implementation UILabel (CornerRadiusLabel)

- (void) cornerRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

@end
