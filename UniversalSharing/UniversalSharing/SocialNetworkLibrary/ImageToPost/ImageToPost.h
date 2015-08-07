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

/*!
 @abstract type image for posting in social network,  Like 'PNG' or 'JPEG'
*/
@property (nonatomic, assign) ImageType imageType;
/*!
 @abstract quality of image for posting in social network. Quality range between 0.0 and 1.0
 */
@property (nonatomic, assign) CGFloat quality;
/*!
 @abstract image for posting in social network
 */
@property (nonatomic, strong) UIImage *image;

@end
