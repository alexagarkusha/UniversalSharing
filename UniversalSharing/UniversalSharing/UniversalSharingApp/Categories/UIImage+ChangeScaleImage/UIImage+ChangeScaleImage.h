//
//  UIImage+ChangeScaleImage.h
//  UniversalSharing
//
//  Created by U 2 on 07.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (ChangeScaleImage)

+ (UIImage*) scaleImage: (UIImage*) image toSize: (CGSize) newSize;

@end
