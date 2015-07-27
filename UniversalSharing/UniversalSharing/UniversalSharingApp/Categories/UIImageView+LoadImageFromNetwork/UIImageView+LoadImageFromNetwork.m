//
//  UIImageView+LoadImageFromNetwork.m
//  UniversalSharing
//
//  Created by U 2 on 23.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "UIImageView+LoadImageFromNetwork.h"

//TODO : fix loading method

@implementation UIImageView (LoadImageFromNetwork)


- (void) loadImageFromUrl : (NSURL*) url {

    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
           self.image = image;
        });
    });
    
}

@end
