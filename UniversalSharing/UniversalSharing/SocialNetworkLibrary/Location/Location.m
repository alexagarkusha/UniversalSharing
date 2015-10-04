//
//  Location.m
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (instancetype) create {
    Location *location = [[Location alloc] init];
    location.longitude = @"";
    location.latitude = @"";
    location.distance = @"";
    location.type = @"";
    location.q = @"";
    return location;
}


@end
