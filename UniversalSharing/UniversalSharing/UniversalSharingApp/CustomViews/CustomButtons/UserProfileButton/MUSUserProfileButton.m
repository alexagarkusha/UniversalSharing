//
//  MUSUserProfileButton.m
//  UniversalSharing
//
//  Created by U 2 on 23.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSUserProfileButton.h"
#import "UIButton+CornerRadiusButton.h"
#import "UIImage+LoadImageFromDataBase.h"

@implementation MUSUserProfileButton

- (void)drawRect:(CGRect)rect{
    self.layer.masksToBounds = YES;
    [self cornerRadius: self.frame.size.height / 2];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.layer setBorderWidth: 1.0f];
    [self.layer setBorderColor: [UIColor darkGrayColor].CGColor];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
