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
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width; // delta width
    float heightRatio = image.size.height / height; // delta height
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio; //compress param
    
    width = image.size.width / divisor; // new image width
    height = image.size.height / divisor; // new image height
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}


@end
