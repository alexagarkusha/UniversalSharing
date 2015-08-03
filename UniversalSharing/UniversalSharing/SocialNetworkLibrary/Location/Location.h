//
//  Location.h
//  UniversalSharing
//
//  Created by U 2 on 03.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *q; //Only for Facebook Network

@end
