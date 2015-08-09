//
//  UIButton+LoadBackgroundImageFromNetwork.m
//  UniversalSharing
//
//  Created by U 2 on 28.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIButton+LoadBackgroundImageFromNetwork.h"

@implementation UIButton (LoadBackgroundImageFromNetwork)

- (void) loadBackroundImageFromNetworkWithURL : (NSURL*) url {
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setBackgroundImage:image forState:UIControlStateNormal];
        });
    });
}

@end
