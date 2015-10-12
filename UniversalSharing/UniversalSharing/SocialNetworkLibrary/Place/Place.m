//
//  Place.m
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "Place.h"
#import "MUSSocialNetworkLibraryConstantsForParseObjects.h"

@implementation Place

+ (instancetype) create {
    Place *place = [[Place alloc] init];
    place.fullName = @"";
    place.placeID = @"";
    place.country = @"";
    place.placeType = @"";
    place.city = @"";
    place.longitude = @"";
    place.latitude = @"";
    return place;
}

- (id) copy {
    Place *copyPlace = [Place new];
    copyPlace.fullName = [self.fullName copy];
    copyPlace.placeID = [self.placeID copy];
    copyPlace.country = [self.country copy];
    copyPlace.placeType = [self.placeType copy];
    copyPlace.city = [self.city copy];
    copyPlace.longitude = [self.longitude copy];
    copyPlace.latitude = [self.latitude copy];
    return copyPlace;
}

#pragma mark - GETTERS

- (NSString *)latitude {
    if (!_latitude || [_latitude isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _latitude;
}

- (NSString *)longitude {
    if (!_longitude || [_longitude isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _longitude;
}

- (NSString *)fullName {
    if (!_fullName || [_fullName isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _fullName;
}

- (NSString *)placeID {
    if (!_placeID || [_placeID isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _placeID;
}

@end
