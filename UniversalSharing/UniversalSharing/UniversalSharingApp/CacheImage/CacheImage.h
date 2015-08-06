//
//  CacheImage.h
//  UniversalSharing
//
//  Created by Roman on 7/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CacheImage : NSObject

+ (CacheImage*) sharedManager;
- (void)cacheImage:(UIImage*)image forKey:(NSURL*)key;
- (UIImage*)obtainCachedImageForKey:(NSURL*)key;
@end
