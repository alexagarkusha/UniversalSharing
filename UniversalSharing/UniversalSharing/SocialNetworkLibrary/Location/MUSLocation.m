//
//  Location.m
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSLocation.h"

@implementation MUSLocation

+ (instancetype) create {
    MUSLocation *location = [[MUSLocation alloc] init];
    location.longitude = @"";
    location.latitude = @"";
    location.distance = @"";
    location.type = @"";
    location.q = @"";
    return location;
}


@end
