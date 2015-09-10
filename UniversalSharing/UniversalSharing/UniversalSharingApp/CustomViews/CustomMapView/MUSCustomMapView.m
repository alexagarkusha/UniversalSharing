//
//  MUSCustomMapView.m
//  UniversalSharing
//
//  Created by U 2 on 07.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCustomMapView.h"
#import "MUSAnnotation.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "ConstantsApp.h"
#import "UIButton+CornerRadiusButton.h"



@interface MUSCustomMapView () <MKMapViewDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D firstLocationCoordinate;
@property (assign, nonatomic) CGFloat maxDistance;
@property (assign, nonatomic) MKMapRect mapViewWithAllAnnotationsRect;
@property (assign, nonatomic) MKMapRect mapViewRect;
@property (assign, nonatomic) MKMapRect centerPoint;

@property (assign, nonatomic) BOOL isMapViewContainCentralPoint;

@end


@implementation MUSCustomMapView

+ (NSString*) viewID {
    return NSStringFromClass([self class]);
}


#pragma mark - initiation MapView for array of Places

- (void) initiationMapView : (NSArray*) arrayOfPlaces withDistance : (CGFloat) distance andNetworkType : (NetworkType) networkType {
    self.isMapViewContainCentralPoint = YES;
    [self.mapView removeAnnotations: self.mapView.annotations];
    self.mapView.delegate = self;
    
    if (!self.firstLocationCoordinate.longitude && !self.firstLocationCoordinate.latitude) {
        Place *firstPlace = [arrayOfPlaces firstObject];
        self.firstLocationCoordinate = CLLocationCoordinate2DMake([firstPlace.latitude floatValue], [firstPlace.longitude floatValue]);
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.firstLocationCoordinate);
        self.centerPoint = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.firstLocationCoordinate, distance, distance);
        [self.mapView setRegion : region animated:YES];
    }
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayOfPlaces.count; i++) {
        Place *currentPlace = [arrayOfPlaces objectAtIndex: i];
        MUSAnnotation *pin = [[MUSAnnotation alloc] initWithTitle: currentPlace.fullName location: CLLocationCoordinate2DMake([currentPlace.latitude floatValue], [currentPlace.longitude floatValue]) andIndex : i];
        [arrayOfAnnotations addObject: pin];
    }
    
    [self.mapView addAnnotations : arrayOfAnnotations];
    [self zoomOutMapView: self.mapView andNewDistance: [distanceEqual1000 floatValue]];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapViewRect = MKMapRectMake(mapView.visibleMapRect.origin.x - [distanceEqual25000 floatValue] / 2, mapView.visibleMapRect.origin.y - [distanceEqual25000 floatValue] / 2, mapView.visibleMapRect.size.width + [distanceEqual25000 floatValue], mapView.visibleMapRect.size.height + [distanceEqual25000 floatValue]);
    
    BOOL isMapViewContainCentralPoint = MKMapRectContainsRect(self.mapViewRect, self.centerPoint);
    
    if (!isMapViewContainCentralPoint) {
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.mapViewWithAllAnnotationsRect);
        [mapView setRegion: region animated:YES];
    } else if (self.mapViewRect.size.height > musAppCustomMapView_maxZoomDistance) {
        MKMapRect maxRegion = MKMapRectMake(self.mapViewWithAllAnnotationsRect.origin.x - musAppCustomMapView_maxZoomDistance / 2, self.mapViewWithAllAnnotationsRect.origin.y  - musAppCustomMapView_maxZoomDistance / 2, self.mapViewWithAllAnnotationsRect.size.width + musAppCustomMapView_maxZoomDistance, self.mapViewWithAllAnnotationsRect.size.height + musAppCustomMapView_maxZoomDistance);
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(maxRegion);
        [mapView setRegion: region animated:YES];
    }
}




- (void) zoomOutMapView : (MKMapView*) mapView andNewDistance : (CGFloat) distance {
    self.mapViewWithAllAnnotationsRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations) {
        //NSLog(@"%@",annotation);
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(self.mapViewWithAllAnnotationsRect)) {
            self.mapViewWithAllAnnotationsRect = pointRect;
        } else {
            pointRect.origin.x -= distance * 2;
            pointRect.origin.y -= distance * 2;
            
            pointRect.size.height += distance * 4;
            pointRect.size.width += distance * 4;
            self.mapViewWithAllAnnotationsRect = MKMapRectUnion(self.mapViewWithAllAnnotationsRect, pointRect);
        }
    }
    [mapView setVisibleMapRect: self.mapViewWithAllAnnotationsRect edgePadding: UIEdgeInsetsMake(10, 10, 10, 10) animated: YES];
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



@end
