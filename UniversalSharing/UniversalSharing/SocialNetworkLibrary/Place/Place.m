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


+ (Place*) createFromDictionary: (NSDictionary*) dictionary andNetworkType :(NetworkType) networkType
{
    switch (networkType) {
        case MUSVKontakt:
            return [Place createPlaceFromVK: dictionary];
            break;
        default:
            break;
    }
    return nil;
}


/*!
 @abstract return an instance of the Place for vkontakte network.
 @param dictionary takes dictionary from vkontakte network.
 */

+ (Place*) createPlaceFromVK : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID = [NSString stringWithFormat: @"%@", [dictionary objectForKey: MUSVKParsePlace_ID]];
    currentPlace.fullName = [dictionary objectForKey: MUSVKParsePlace_Title];
    currentPlace.placeType = [dictionary objectForKey: MUSVKParsePlace_Type];
    currentPlace.country = [dictionary objectForKey: MUSVKParsePlace_Country];
    currentPlace.city = [dictionary objectForKey: MUSVKParsePlace_City];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [dictionary objectForKey: MUSVKParsePlace_Longitude]];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [dictionary objectForKey: MUSVKParsePlace_Latitude]];
    
    return currentPlace;
}

/*!
 @abstract return an instance of the Place for twitter network.
 @param dictionary takes dictionary from twitter network.
 */


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
