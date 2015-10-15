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
@property (nonatomic, copy)   Complition copyComplition;

@end

@implementation MUSLocationManager

+ (MUSLocationManager*) sharedManager {
    static MUSLocationManager* sharedManager = nil;
    
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        
        sharedManager = [MUSLocationManager new];
    });
    return sharedManager;
}

- (id) init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc]init];
        [self setupLocationManager];
    }
    return self;
}

- (void) setupLocationManager {
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    NSString *versionDeviceString = [[UIDevice currentDevice] systemVersion];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([versionDeviceString floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void) startTrackLocationWithComplition : (Complition) block {
    self.copyComplition = block;
    [self.locationManager startUpdatingLocation];
}

- (void) stopTrackLocation {
    [self.locationManager stopUpdatingLocation];
    self.copyComplition (self.locationManager.location, nil);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations) {
        [self stopTrackLocation];
    }
}

- (void) obtainAddressFromLocation:(CLLocation *)location complitionBlock: (Complition) block {
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:eventLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             if (placemark.name) {
                 address = [NSString stringWithFormat:@"%@", placemark.name];
             } else if (placemark.locality) {
                 address = [NSString stringWithFormat:@"%@", placemark.locality];
             } else if (placemark.country){
                 address = [NSString stringWithFormat:@"%@", placemark.country];
             } else {
                 address = MUSApp_MUSLocationManager_Address_Unknown;
             }
             block(address, error);
         }
     }];
}

@end
