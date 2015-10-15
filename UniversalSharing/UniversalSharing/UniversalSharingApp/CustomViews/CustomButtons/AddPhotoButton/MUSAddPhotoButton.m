//
//  MUSAddPhotoButton.m
//  UniversalSharing
//
//  Created by U 2 on 04.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSAddPhotoButton.h"
#import "ConstantsApp.h"

@implementation MUSAddPhotoButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [UIView commitAnimations];
        self.layer.masksToBounds = YES;
        [self setImage:[UIImage imageNamed: MUSApp_Image_Name_AddPhoto] forState:UIControlStateNormal];
        [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
    }
    return self;
}

@end
