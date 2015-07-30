//
//  ImageToPost.h
//  UniversalSharing
//
//  Created by U 2 on 30.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import <UIKit/UIKit.h>

@interface ImageToPost : NSObject

@property (nonatomic, assign) ImageType imageType;
@property (nonatomic, assign) CGFloat quality;
@property (nonatomic, strong) UIImage *image;

@end
