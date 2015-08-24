//
//  UIButton+MUSEditableButton.m
//  UniversalSharing
//
//  Created by U 2 on 20.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIButton+MUSEditableButton.h"
#import "ConstantsApp.h"

@implementation UIButton (MUSEditableButton)

- (void) editableButton {
    self.hidden = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    [self setImage:[UIImage imageNamed: musAppButton_ImageName_ButtonAdd] forState:UIControlStateNormal];
    [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
}


@end
