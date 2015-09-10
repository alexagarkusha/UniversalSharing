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
@end

@interface MUSCustomMapView : UIView

+ (NSString*) viewID;
- (void) initiationMapView : (NSArray*) arrayOfPlaces withDistance : (CGFloat) distance andNetworkType : (NetworkType) networkType;

@property (assign, nonatomic) id <MUSCustomMapViewDelegate> delegate;
@property (nonatomic, strong) NSArray *arrayOfPlaces;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
