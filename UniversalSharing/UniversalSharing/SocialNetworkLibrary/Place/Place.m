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
        case Facebook:
            return [Place createPlaceFromFB: dictionary];
            break;
        case VKontakt:
            return [Place createPlaceFromVK: dictionary];
            break;
        case Twitters:
            return [Place createPlaceFromTwitter: dictionary];
            break;
        default:
            break;
    }
    return nil;
}

/*!
 @abstract return an instance of the Place for facebook network.
 @param dictionary takes dictionary from facebook network.
 */

+ (Place*) createPlaceFromFB : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID = [dictionary objectForKey: musFacebookParsePlace_ID];
    currentPlace.fullName = [dictionary objectForKey: musFacebookParsePlace_Name];
    currentPlace.placeType = [dictionary objectForKey: musFacebookParsePlace_Category];
    
    NSDictionary *locationFBDictionary = [dictionary objectForKey: musFacebookParsePlace_Location];
    currentPlace.country = [locationFBDictionary objectForKey: musFacebookParsePlace_Country];
    currentPlace.city = [locationFBDictionary objectForKey: musFacebookParsePlace_City];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [locationFBDictionary objectForKey: musFacebookParsePlace_Longitude]];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [locationFBDictionary objectForKey: musFacebookParsePlace_Latitude]];

    
    return currentPlace;
}

/*!
 @abstract return an instance of the Place for vkontakte network.
 @param dictionary takes dictionary from vkontakte network.
 */

+ (Place*) createPlaceFromVK : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID = [NSString stringWithFormat: @"%@", [dictionary objectForKey: musVKParsePlace_ID]];
    currentPlace.fullName = [dictionary objectForKey: musVKParsePlace_Title];
    currentPlace.placeType = [dictionary objectForKey: musVKParsePlace_Type];
    currentPlace.country = [dictionary objectForKey: musVKParsePlace_Country];
    currentPlace.city = [dictionary objectForKey: musVKParsePlace_City];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [dictionary objectForKey: musVKParsePlace_Longitude]];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [dictionary objectForKey: musVKParsePlace_Latitude]];
    
    return currentPlace;
}

/*!
 @abstract return an instance of the Place for twitter network.
 @param dictionary takes dictionary from twitter network.
 */

+ (Place*) createPlaceFromTwitter : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID   = [dictionary objectForKey: musTwitterParsePlace_ID];
    currentPlace.placeType = [dictionary objectForKey: musTwitterParsePlace_Place_Type];
    currentPlace.country   = [dictionary objectForKey: musTwitterParsePlace_Country];
    currentPlace.fullName  = [dictionary objectForKey: musTwitterParsePlace_Full_Name];
    
    NSArray *centroid = [dictionary objectForKey: musTwitterParsePlace_Centroid];
    currentPlace.latitude = [NSString stringWithFormat: @"%@", [centroid lastObject]];
    currentPlace.longitude = [NSString stringWithFormat: @"%@", [centroid firstObject]];
    
    NSArray *containedWithinArray = [dictionary objectForKey: musTwitterParsePlace_Contained_Within];
    NSDictionary *locationTwitterDictionary = [containedWithinArray firstObject];
    currentPlace.city = [locationTwitterDictionary objectForKey: musTwitterParsePlace_Name];
    
    return currentPlace;
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
