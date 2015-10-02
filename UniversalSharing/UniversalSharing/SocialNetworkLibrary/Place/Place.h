//
//  Place.h
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface Place : NSObject

/*!
 @abstract full place name. Like 'The Circus hostel'
*/
@property (nonatomic, strong) NSString *fullName;
/*!
 @abstract unique identifier of the place. Like '6333547'
 */
@property (nonatomic, strong) NSString *placeID;
/*!
 @abstract name of the state. Like 'Germany'
 */
@property (nonatomic, strong) NSString *country;
/*!
 @abstract type of the place. Like 'Local business'
 */
@property (nonatomic, strong) NSString *placeType;
/*!
 @abstract name of the city. Like 'Berlin'
 */
@property (nonatomic, strong) NSString *city;
/*!
 @abstract longitude of the place. Like '+32.049343'
 */
@property (nonatomic, strong) NSString *longitude;
/*!
 @abstract latitude of the place. Like '+48.049343'
 */
@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, assign) BOOL isChosen;

+ (instancetype) create;

/*!
 @abstract return an instance of the Place.
 @param dictionary takes dictionary from social network.
 @param networkType takes the type of social network (like Facebook, Twitters, Vkontakte)
 */
+ (Place*) createFromDictionary: (NSDictionary*) dictionary andNetworkType : (NetworkType) networkType;

- (id) copy;

@end
