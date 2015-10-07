//
//  UIImageView+RoundImage.m
//  UniversalSharing
//
//  Created by U 2 on 23.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "UIImageView+RoundImage.h"

@implementation UIImageView (RoundImage)

- (void) roundImageView {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
}

@end
