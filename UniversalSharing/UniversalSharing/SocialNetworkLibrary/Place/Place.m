//
//  Place.m
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "Place.h"

@implementation Place

+ (Place*) createFromDictionary: (NSDictionary*) dictionary andNetworkType :(NetworkType) networkType
{
    Place *place = [[Place alloc] init];
    
    switch (networkType) {
        case Facebook:
            place = [place createPlaceFromFB: dictionary];
            break;
        case VKontakt:
            place = [place createPlaceFromVK: dictionary];
            break;
        case Twitters:
            place = [place createPlaceFromTwitter: dictionary];
            break;
        default:
            break;
    }
    return place;
}

- (Place*) createPlaceFromFB : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    currentPlace.placeID = [dictionary objectForKey: @"id"];
    currentPlace.fullName = [dictionary objectForKey: @"name"];
    currentPlace.placeType = [dictionary objectForKey: @"category"];
    
    NSDictionary *locationFBDictionary = [dictionary objectForKey: @"location"];
    currentPlace.country = [locationFBDictionary objectForKey: @"country"];
    currentPlace.city = [locationFBDictionary objectForKey: @"city"];
    
    return currentPlace;
}

- (Place*) createPlaceFromVK : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    
    return currentPlace;
}

- (Place*) createPlaceFromTwitter : (NSDictionary *) dictionary {
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID   = [dictionary objectForKey: @"id" ];
    currentPlace.name      = [dictionary objectForKey: @"name" ];
    currentPlace.placeType = [dictionary objectForKey: @"place_type" ];
    currentPlace.country   = [dictionary objectForKey: @"country" ];
    currentPlace.fullName  = [dictionary objectForKey: @"full_name" ];
    
    NSArray *containedWithinArray = [dictionary objectForKey: @"contained_within"];
    NSDictionary *locationTwitterDictionary = [containedWithinArray firstObject];
    currentPlace.city = [locationTwitterDictionary objectForKey: @"name"];
    
    return currentPlace;
}





@end
