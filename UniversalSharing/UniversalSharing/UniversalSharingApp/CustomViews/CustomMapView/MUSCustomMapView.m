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
@property (assign, nonatomic) MKMapRect mapViewWithAllAnnotationsRect;
@property (assign, nonatomic) MKMapRect mapViewRect;
@property (strong, nonatomic) NSMutableArray *arrayOfAnnotations;

@end


@implementation MUSCustomMapView

#pragma mark - initiation MapView for array of Places

- (void) initiationMapViewWithPlaces : (NSArray*) arrayOfPlaces {
    [self.mapView removeAnnotations: self.mapView.annotations];
    self.mapView.delegate = self;
    
    if (!self.arrayOfAnnotations) {
        self.arrayOfAnnotations = [[NSMutableArray alloc] init];
    } else {
        [self.arrayOfAnnotations removeAllObjects];
    }
    
    for (int i = 0; i < arrayOfPlaces.count; i++) {
        Place *currentPlace = [arrayOfPlaces objectAtIndex: i];
        CLLocationCoordinate2D currentLocationCoordinate = CLLocationCoordinate2DMake([currentPlace.latitude floatValue], [currentPlace.longitude floatValue]);
        
        MUSAnnotation *pin = [[MUSAnnotation alloc]
                                        initWithTitle: currentPlace.fullName
                                             location: currentLocationCoordinate
                                                index: i
                                            andStatus: currentPlace.isChosen];
        [self.arrayOfAnnotations addObject: pin];
    }
    [self.mapView addAnnotations : self.arrayOfAnnotations];
    [self zoomOutMapView: self.mapView andNewDistance: [distanceEqual1000 floatValue]];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKMapRect newMapViewRect = [self newMapViewRect: mapView withDistance:[distanceEqual25000 floatValue]];
     
    BOOL isMapViewContainCentralPoint = MKMapRectContainsRect(newMapViewRect, [self centerRect]);
     
     if (!isMapViewContainCentralPoint && self.mapViewWithAllAnnotationsRect.size.height > 0) {
         MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.mapViewWithAllAnnotationsRect);
         [mapView setRegion: region animated:YES];
     } else if (newMapViewRect.size.height > musAppCustomMapView_maxZoomDistance && self.mapViewWithAllAnnotationsRect.size.height > 0) {
         MKMapRect maxRegion = MKMapRectMake(self.mapViewWithAllAnnotationsRect.origin.x - musAppCustomMapView_maxZoomDistance / 2, self.mapViewWithAllAnnotationsRect.origin.y  - musAppCustomMapView_maxZoomDistance / 2, self.mapViewWithAllAnnotationsRect.size.width + musAppCustomMapView_maxZoomDistance, self.mapViewWithAllAnnotationsRect.size.height + musAppCustomMapView_maxZoomDistance);
         MKCoordinateRegion region = MKCoordinateRegionForMapRect(maxRegion);
         [mapView setRegion: region animated:YES];
     }
 }


- (MKMapRect) centerRect {
    MKUserLocation *currentUserLocation = self.mapView.userLocation;
    CLLocationCoordinate2D currentUserCoordinate = currentUserLocation.location.coordinate;
    MKMapPoint centerPoint = MKMapPointForCoordinate(currentUserCoordinate);
    MKMapRect centerRect = MKMapRectMake(centerPoint.x, centerPoint.y, 0.1, 0.1);
    return centerRect;
}

- (MKMapRect) newMapViewRect : (MKMapView *) mapView withDistance : (CGFloat) distance {
   return MKMapRectMake(mapView.visibleMapRect.origin.x - distance, mapView.visibleMapRect.origin.y - distance, mapView.visibleMapRect.size.width + distance * 2, mapView.visibleMapRect.size.height + distance * 2);
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

// Add annotations with text and button

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MUSAnnotation class]]) {
        MUSAnnotation *newAnnotaton = (MUSAnnotation*) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier: @"MUSAnnotation"];
        if (annotationView) {
            annotationView.annotation = annotation;
        } else {
            annotationView = [newAnnotaton annotationPinView];
        }
        
        if (newAnnotaton.isChosen) {
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.rightCalloutAccessoryView = [self deletePlaceButton];
        } else {
            annotationView.pinColor = MKPinAnnotationColorRed;
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

- (void) deleteChosenPlace {
    [self deleteChosenPlaceFromMap];
    [self.delegate deleteChosenPlaceFromTableView];
}

- (void) deleteChosenPlaceFromMap {
    for (MUSAnnotation *annotation in self.arrayOfAnnotations) {
        if (annotation.isChosen) {
            [self.mapView removeAnnotation: [self.arrayOfAnnotations objectAtIndex: annotation.index]];
            annotation.isChosen = NO;
            [self.mapView addAnnotation: annotation];
        }
    }
}

// Add button to annotation

- (UIButton*) addPlaceButtonWithIndex : (NSInteger) currentIndex {
    UIButton *addPlaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addPlaceButton.frame = CGRectMake(0, 0, 35, 35);
    [addPlaceButton cornerRadius: addPlaceButton.frame.size.height / 2];
    [addPlaceButton setImage: [UIImage imageNamed: musAppButton_ImageName_ButtonAdd] forState:UIControlStateNormal];
    [addPlaceButton setTag: currentIndex];
    [addPlaceButton addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
    return addPlaceButton;
}


- (UIButton*) deletePlaceButton {
    UIButton *deletePlaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deletePlaceButton.frame = CGRectMake(0, 0, 35, 35);
    [deletePlaceButton cornerRadius: deletePlaceButton.frame.size.height / 2];
    [deletePlaceButton setImage: [UIImage imageNamed: musAppButton_ImageName_ButtonDeleteLocation] forState:UIControlStateNormal];
    [deletePlaceButton addTarget:self action:@selector(deleteChosenPlace) forControlEvents:UIControlEventTouchUpInside];
    return deletePlaceButton;
}




@end
