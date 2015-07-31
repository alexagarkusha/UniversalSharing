//
//  Post.m
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "Post.h"

@implementation Post


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageToPost = [[ImageToPost alloc] init];
    }
    return self;
}


@end
