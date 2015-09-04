//
//  UIButton+MUSAddPhotoButton.m
//  UniversalSharing
//
//  Created by U 2 on 03.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIButton+MUSAddPhotoButton.h"
#import "ConstantsApp.h"

@implementation UIButton (MUSAddPhotoButton)

- (void) addPhotoButton {
    self.hidden = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    [self setImage:[UIImage imageNamed: musAppButton_ImageName_AddPhoto] forState:UIControlStateNormal];
    [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
    [NSTimer scheduledTimerWithTimeInterval : 4.0f
                                     target : self
                                   selector : @selector(buttonAnimationStart)
                                   userInfo : nil
                                    repeats : YES];

}


- (void) buttonAnimationStart {
    [NSTimer scheduledTimerWithTimeInterval : 1.0f
                                     target : self
                                   selector : @selector(changeScaleButton)
                                   userInfo : nil
                                    repeats : NO];
    [NSTimer scheduledTimerWithTimeInterval : 1.5f
                                     target : self
                                   selector : @selector(undoChangeScaleButton)
                                   userInfo : nil
                                    repeats : NO];
}

- (void) changeScaleButton {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.4f];
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView commitAnimations];
}

- (void) undoChangeScaleButton {
    [UIView beginAnimations:@"UndoScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.4f];
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}


@end
