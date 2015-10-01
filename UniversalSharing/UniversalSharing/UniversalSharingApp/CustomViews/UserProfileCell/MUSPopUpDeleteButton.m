//
//  MUSPopUpDeleteButton.m
//  UniversalSharing
//
//  Created by Roman on 9/30/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPopUpDeleteButton.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"

@implementation MUSPopUpDeleteButton
- (void)drawRect:(CGRect)rect {
    UIImage *deleteIconImage = [UIImage imageNamed: @"close6.png"];
    
    float width = deleteIconImage.size.width; // new width
    float height = deleteIconImage.size.height; // new height
    
    //rect = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(rect.size);
//    rect.origin.y = 0;
//    rect.origin.x = 30;
    //rect.size.height = height ;//- 24;
   // rect.size.width = width;// - 24;
    [deleteIconImage drawInRect: rect];
    deleteIconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //self.deletePhotoButtonOutlet.hidden = YES;
    self.layer.masksToBounds = YES;
    self.tintColor = [UIColor blackColor];
    
    [self setImage: deleteIconImage forState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(5, self.frame.size.height / 3, self.frame.size.height / 3, 5);
    //self.imageView.backgroundColor = [UIColor grayColor];
    //self.imageView.alpha = 0.6f;
    //[self.imageView cornerRadius: 5.0f andBorderWidth: 1.0f withBorderColor:[UIColor darkGrayColor]];
    [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
}

@end
