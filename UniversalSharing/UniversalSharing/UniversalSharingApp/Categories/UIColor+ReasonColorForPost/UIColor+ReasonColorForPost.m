//
//  UIColor+ReasonColorForPost.m
//  UniversalSharing
//
//  Created by U 2 on 27.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIColor+ReasonColorForPost.h"

@implementation UIColor (ReasonColorForPost)

+ (UIColor*) reasonColorForPost : (ReasonType) currentReasonType {
    switch (currentReasonType) {
        case Connect:
            return [self colorWithRed: 75.0/255.0 green: 208.0/255.0 blue: 100.0/255.0 alpha: 1.0];
            break;
        case ErrorConnection:
            return [self redColor];
            break;
        case Offline:
            return [self grayColor];
            break;
        default:
            break;
    }
    return nil;

}

@end
