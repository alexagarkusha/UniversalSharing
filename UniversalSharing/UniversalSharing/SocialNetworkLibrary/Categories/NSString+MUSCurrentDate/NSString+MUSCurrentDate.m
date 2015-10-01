//
//  NSString+MUSCurrentDate.m
//  UniversalSharing
//
//  Created by U 2 on 01.10.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+MUSCurrentDate.h"

@implementation NSString (MUSCurrentDate)

+ (NSString*) currentDate {
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
}

@end
