//
//  MUSCustomMapView.m
//  UniversalSharing
//
//  Created by U 2 on 07.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCustomMapView.h"
#import <MapKit/MapKit.h>
#import "MUSAnnotation.h"
#import "MUSSocialNetworkLibraryHeader.h"



@interface MUSCustomMapView () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end


@implementation MUSCustomMapView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (NSString*) viewID {
    return NSStringFromClass([self class]);
}


#pragma mark - initiation MapView for array of Places

- (void) initiationMapView : (NSArray*) arrayOfPlaces withDistance : (CGFloat) distance {
    [self.mapView removeAnnotations: self.mapView.annotations];

    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    Place *firstPlace = [arrayOfPlaces firstObject];
    CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake([firstPlace.latitude floatValue], [firstPlace.longitude floatValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCityLocation, distance * 2, distance * 2);
    
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayOfPlaces.count; i++) {
        MUSAnnotation *pin = [[MUSAnnotation alloc] init];
        Place *currentPlace = [arrayOfPlaces objectAtIndex: i];
        pin.coordinate = CLLocationCoordinate2DMake([currentPlace.latitude floatValue], [currentPlace.longitude floatValue]);
        pin.title = currentPlace.fullName;
        [arrayOfAnnotations addObject: pin];
    }
    [self.mapView addAnnotations : arrayOfAnnotations];
    [self.mapView setRegion : region animated:YES];
}




@end
