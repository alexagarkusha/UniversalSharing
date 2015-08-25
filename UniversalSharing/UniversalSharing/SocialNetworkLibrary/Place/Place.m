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

/*!
 @abstract return an instance of the Place for facebook network.
 @param dictionary takes dictionary from facebook network.
 */

- (Place*) createPlaceFromFB : (NSDictionary *) dictionary {
#warning "One more init?"
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID = [dictionary objectForKey: musFacebookParsePlace_ID];
    currentPlace.fullName = [dictionary objectForKey: musFacebookParsePlace_Name];
    currentPlace.placeType = [dictionary objectForKey: musFacebookParsePlace_Category];
    
    NSDictionary *locationFBDictionary = [dictionary objectForKey: musFacebookParsePlace_Location];
    currentPlace.country = [locationFBDictionary objectForKey: musFacebookParsePlace_Country];
    currentPlace.city = [locationFBDictionary objectForKey: musFacebookParsePlace_City];
    
    return currentPlace;
}

/*!
 @abstract return an instance of the Place for vkontakte network.
 @param dictionary takes dictionary from vkontakte network.
 */

- (Place*) createPlaceFromVK : (NSDictionary *) dictionary {
#warning "One more init?"
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID = [dictionary objectForKey: musVKParsePlace_ID];
    currentPlace.fullName = [dictionary objectForKey: musVKParsePlace_Title];
    currentPlace.placeType = [dictionary objectForKey: musVKParsePlace_Type];
    currentPlace.country = [dictionary objectForKey: musVKParsePlace_Country];
    currentPlace.city = [dictionary objectForKey: musVKParsePlace_City];
    
    return currentPlace;
}

/*!
 @abstract return an instance of the Place for twitter network.
 @param dictionary takes dictionary from twitter network.
 */

- (Place*) createPlaceFromTwitter : (NSDictionary *) dictionary {
#warning "One more init?"
    Place *currentPlace = [[Place alloc] init];
    
    currentPlace.placeID   = [dictionary objectForKey: musTwitterParsePlace_ID];
    currentPlace.placeType = [dictionary objectForKey: musTwitterParsePlace_Place_Type];
    currentPlace.country   = [dictionary objectForKey: musTwitterParsePlace_Country];
    currentPlace.fullName  = [dictionary objectForKey: musTwitterParsePlace_Full_Name];
    
    NSArray *containedWithinArray = [dictionary objectForKey: musTwitterParsePlace_Contained_Within];
    NSDictionary *locationTwitterDictionary = [containedWithinArray firstObject];
    currentPlace.city = [locationTwitterDictionary objectForKey: musTwitterParsePlace_Name];
    
    return currentPlace;
}

@end
