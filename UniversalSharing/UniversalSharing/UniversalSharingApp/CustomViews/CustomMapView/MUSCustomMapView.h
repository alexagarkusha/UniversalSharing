//
//  MUSCustomMapView.h
//  UniversalSharing
//
//  Created by U 2 on 07.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"
#import <MapKit/MapKit.h>

@protocol MUSCustomMapViewDelegate <NSObject>

@optional

- (void) selectedPlaceForPostByIndex : (NSInteger) index;
- (void) deleteChosenPlaceFromTableView;

@end

@interface MUSCustomMapView : UIView

- (void) initiationMapViewWithPlaces : (NSArray*) arrayOfPlaces;
- (void) deleteChosenPlaceFromMap;

@property (assign, nonatomic) id <MUSCustomMapViewDelegate> delegate;
@property (nonatomic, strong) NSArray *arrayOfPlaces;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
