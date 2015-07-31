//
//  CacheImage.m
//  UniversalSharing
//
//  Created by Roman on 7/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "CacheImage.h"
@interface CacheImage()
@property (nonatomic, strong) NSCache *cacheImage;

@end
static CacheImage *model = nil;

@implementation CacheImage
+ (CacheImage*) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[CacheImage alloc] init];
    });
    return  model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cacheImage = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSURL*)key {
    [self.cacheImage setObject:image forKey:key];
}

- (UIImage*)obtainCachedImageForKey:(NSURL*)key {
    return [self.cacheImage objectForKey:key];
}
@end
