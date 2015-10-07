//
//  UIImage+ChangeScaleImage.m
//  UniversalSharing
//
//  Created by U 2 on 07.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImage+ChangeScaleImage.h"


@implementation UIImage (ChangeScaleImage)

+ (UIImage*) scaleImage: (UIImage*) image toSize: (CGSize) newSize {
    
    float width = newSize.width; // new width
    float height = newSize.height; // new height
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width; // delta width
    float heightRatio = image.size.height / height; // delta height
    
    if (widthRatio < 1.0 && heightRatio < 1.0) {
        return image;
    }
    
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio; //compress param
    
    width = image.size.width / divisor; // new image width
    height = image.size.height / divisor; // new image height
    
    rect.size.width  = width;
    rect.size.height = height;
    
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect: rect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
