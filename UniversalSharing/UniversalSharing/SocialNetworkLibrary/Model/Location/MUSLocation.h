//
//  Location.h
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSLocation : NSObject

/*!
 @abstract latitude point within a radius of where you want to search for, given in degrees (-90 to 90) .
*/

@property (nonatomic, strong) NSString *latitude;

/*!
 @abstract longitude points within a radius of where you want to search for , given in degrees (from -180 to 180) .
*/
@property (nonatomic, strong) NSString *longitude;

/*!
 @abstract distance search area
*/
@property (nonatomic, strong) NSString *distance;

/*!
 @abstract type of location place. Can be PLACE, CITY, STATE_PROVINCE, COUNTRY, EVENT, RESIDENCE, TEXT
*/

@property (nonatomic, strong) NSString *type;

/*!
 @abstract string search. May itself contain nothing, but CAN NOT be NIL
*/
@property (nonatomic, strong) NSString *q; 

+ (instancetype) create;


@end
