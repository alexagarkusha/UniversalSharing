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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [UIView commitAnimations];
        self.layer.masksToBounds = YES;
        [self setImage:[UIImage imageNamed: MUSApp_Image_Name_AddPhoto] forState:UIControlStateNormal];
        [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
//        [self addPhotobuttonAnimationStart];
//        [NSTimer scheduledTimerWithTimeInterval : 4.0f
//                                         target : self
//                                       selector : @selector(addPhotobuttonAnimationStart)
//                                       userInfo : nil
//                                        repeats : YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void) addPhotobuttonAnimationStart {
    [NSTimer scheduledTimerWithTimeInterval : 1.0f
                                     target : self
                                   selector : @selector(changeScaleAddPhotoButton)
                                   userInfo : nil
                                    repeats : NO];
    [NSTimer scheduledTimerWithTimeInterval : 1.5f
                                     target : self
                                   selector : @selector(undoChangeScaleAddPhotoButton)
                                   userInfo : nil
                                    repeats : NO];
}

- (void) changeScaleAddPhotoButton {
    [UIView beginAnimations:@"ScaleADDButton" context:NULL];
    [UIView setAnimationDuration: 0.5f];
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView commitAnimations];
}

- (void) undoChangeScaleAddPhotoButton {
    [UIView beginAnimations:@"UndoScaleADDButton" context:NULL];
    [UIView setAnimationDuration: 0.5f];
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}




@end
