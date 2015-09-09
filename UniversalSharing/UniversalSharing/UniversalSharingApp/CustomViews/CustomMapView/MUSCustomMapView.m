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
#import "ConstantsApp.h"
#import "UIButton+CornerRadiusButton.h"



@interface MUSCustomMapView () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) CLLocationCoordinate2D firstLocationCoordinate;
@property (assign, nonatomic) NSInteger maxDistance;
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

- (void) initiationMapView : (NSArray*) arrayOfPlaces withDistance : (CGFloat) distance andNetworkType : (NetworkType) networkType {
    [self.mapView removeAnnotations: self.mapView.annotations];
    self.mapView.delegate = self;
    
    if (!self.firstLocationCoordinate.longitude && !self.firstLocationCoordinate.latitude) {
        Place *firstPlace = [arrayOfPlaces firstObject];
        self.firstLocationCoordinate = CLLocationCoordinate2DMake([firstPlace.latitude floatValue], [firstPlace.longitude floatValue]);
        NSLog(@"CENTER NEW REGION lat = %f, long = %f", self.firstLocationCoordinate.latitude, self.firstLocationCoordinate.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.firstLocationCoordinate, distance, distance);
        [self.mapView setRegion : region animated:YES];
    }
    
    NSLog(@"REGION IS OK");
    
    if ([self initiationMaximumNumberOfPlaces: networkType] == arrayOfPlaces.count && networkType != Twitters) {
        self.maxDistance = distance;
    }
    
    
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrayOfPlaces.count; i++) {
        Place *currentPlace = [arrayOfPlaces objectAtIndex: i];
        MUSAnnotation *pin = [[MUSAnnotation alloc] initWithTitle: currentPlace.fullName location: CLLocationCoordinate2DMake([currentPlace.latitude floatValue], [currentPlace.longitude floatValue]) andIndex : i];
        [arrayOfAnnotations addObject: pin];
    }
    
    [self.mapView addAnnotations : arrayOfAnnotations];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    MKMapRect mRect = mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    NSInteger currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    //NSLog(@"Current distance = %d", currentDist);
    
    MKCoordinateRegion region;
    if (currentDist > [distanceEqual25000 integerValue] && !self.maxDistance) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.region.center, [distanceEqual25000 integerValue], [distanceEqual25000 integerValue]);
        [self.mapView setRegion : region animated:YES];
    } else if (self.maxDistance && currentDist > self.maxDistance) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.region.center, self.maxDistance, self.maxDistance);
        [self.mapView setRegion : region animated:YES];
    } else {
        [self.delegate reloadCustomMapView: currentDist];
    }
    
    
    /*
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations) {
        //NSLog(@"%@",annotation);
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    
    [mapView setVisibleMapRect:zoomRect animated:YES];
    */
    
    
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MUSAnnotation class]]) {
        MUSAnnotation *newAnnotaton = (MUSAnnotation*) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier: @"MUSAnnotation"];
        if (annotationView) {
            annotationView.annotation = annotation;
        } else {
            annotationView = [newAnnotaton annotationPinView];
            annotationView.rightCalloutAccessoryView = [self addPlaceButtonWithIndex:newAnnotaton.index];
        }
        return annotationView;
    } else {
        return nil;
    }
}

- (void) choosePlace : (UIButton*) sender {
    [self.delegate selectedPlaceForPostByIndex: sender.tag];
   // NSLog(@"Click annotation = %d", sender.tag);
}

- (UIButton*) addPlaceButtonWithIndex : (NSInteger) currentIndex {
    UIButton *addPlaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addPlaceButton.frame = CGRectMake(0, 0, 35, 35);
    [addPlaceButton cornerRadius: addPlaceButton.frame.size.height / 2];
    [addPlaceButton setImage: [UIImage imageNamed: musAppButton_ImageName_ButtonAdd] forState:UIControlStateNormal];
    [addPlaceButton setTag: currentIndex];
    [addPlaceButton addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
    return addPlaceButton;
}

- (NSInteger) initiationMaximumNumberOfPlaces : (NetworkType) networkType {
    switch (networkType) {
        case Twitters:
            return 20;
            break;
        case Facebook:
            return 25;
            break;
        default:
            return 30;
            break;
    }
}




@end
