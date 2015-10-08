//
//  UIImage+SocialNetworkIcons.h
//  UniversalSharing
//
//  Created by U 2 on 08.10.15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkPost.h"

@interface UIImage (SocialNetworkIcons)

+ (UIImage*) likesIconByTypeOfSocialNetwork : (NetworkType) networkType;

+ (UIImage*) commentsIconByTypeOfSocialNetwork : (NetworkType) networkType;

@end
