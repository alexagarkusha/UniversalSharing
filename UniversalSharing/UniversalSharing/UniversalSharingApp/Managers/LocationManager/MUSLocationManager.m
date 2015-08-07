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
@property (nonatomic, copy)   ComplitionLocation copyLocationBLock;

@end


@implementation MUSLocationManager

- (id) init {
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc]init];
        [self setupLocationManager];
    }
    return self;
}

+ (MUSLocationManager*) sharedManager {
    static MUSLocationManager* sharedManager = nil;
    
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        
                       sharedManager = [MUSLocationManager new];
                   });
    return sharedManager;
}

- (void) setupLocationManager
{
    self.locationManager.delegate = self;

//    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//
//    self.locationManager.distanceFilter = kCLDistanceFilterNone; //type - double;
//    if ([versionDeviceString floatValue] >= 8.0) {
//        
////        NSUInteger code = [CLLocationManager authorizationStatus];
////        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
////            // choose one request according to your business.
////            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
////                [self.locationManager requestAlwaysAuthorization];
////            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
////                [self.locationManager  requestWhenInUseAuthorization];
////            } else {
////                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
////            }
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//            [self.locationManager requestWhenInUseAuthorization];
//            //[self.locationManager requestAlwaysAuthorization];
//        }
//    }
    [self.locationManager startMonitoringSignificantLocationChanges];

    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    NSString *versionDeviceString = [[UIDevice currentDevice] systemVersion];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if ([versionDeviceString floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void) startTrackLocationWithComplition : (ComplitionLocation) block {
    self.copyLocationBLock = block;
    [self.locationManager startUpdatingLocation];
        //block(self.locationManager,nil);

}
- (void) stopAndGetCurrentLocation {
    [self.locationManager stopUpdatingLocation];
    self.copyLocationBLock (self.locationManager.location, nil);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    if (locations) {
        [self stopAndGetCurrentLocation];
    }
}




@end
