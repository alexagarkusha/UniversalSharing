//
//  MUSLocationManager.m
//  UniversalSharing
//
//  Created by U 2 on 28.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSLocationManager.h"
#import <UIKit/UIKit.h>


@interface MUSLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation MUSLocationManager

- (id) init {
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    return self;
}

+ (MUSLocationManager*) sharedManager {
    static MUSLocationManager* sharedManager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^
                   {
                       sharedManager = [MUSLocationManager new];
                   });
    return sharedManager;
}

- (void) startTrackLocation {
    NSString *versionDeviceString = [[UIDevice currentDevice] systemVersion];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //type - double;
    if ([versionDeviceString floatValue] >= 8.0) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self stopAndGetCurrentLocation];
}

- (CLLocation*) stopAndGetCurrentLocation {
    [self.locationManager stopUpdatingLocation];
    return self.locationManager.location;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    if (locations) {
        [self stopAndGetCurrentLocation];
    }
}




@end
