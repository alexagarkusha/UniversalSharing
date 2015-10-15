//
//  MUSDeleteButton.m
//  UniversalSharing
//
//  Created by U 2 on 04.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDeleteButton.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"
#import "ConstantsApp.h"

@implementation MUSDeleteButton

 - (void)drawRect:(CGRect)rect {
     UIImage *deleteIconImage = [UIImage imageNamed: MUSApp_MUSDeleteButton_Image_Name];
     
     float width = deleteIconImage.size.width; // new width
     float height = deleteIconImage.size.height; // new height
     
     rect = CGRectMake(0, 0, width, height);     
     UIGraphicsBeginImageContext(rect.size);
     rect.origin.y = 12;
     rect.origin.x = 12;
     rect.size.height = height - 24;
     rect.size.width = width - 24;
     [deleteIconImage drawInRect: rect];
     deleteIconImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext(); 
     self.layer.masksToBounds = YES;
     self.tintColor = [UIColor whiteColor];
     [self setImage: deleteIconImage forState:UIControlStateNormal];
     self.imageEdgeInsets = UIEdgeInsetsMake(3, self.frame.size.height / 2, self.frame.size.height / 2, 3);
     self.imageView.backgroundColor = [UIColor grayColor];
     [self.imageView cornerRadius: 5.0f andBorderWidth: 1.0f withBorderColor:[UIColor darkGrayColor]];
     [self.imageView setContentMode : UIViewContentModeScaleAspectFit];
 }


@end
