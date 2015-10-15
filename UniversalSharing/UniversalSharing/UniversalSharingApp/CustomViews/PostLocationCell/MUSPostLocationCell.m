//
//  MUSPostLocationCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostLocationCell.h"
#import <MapKit/MapKit.h>
#import "MUSAnnotation.h"
#import "ConstantsApp.h"

@interface MUSPostLocationCell () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet    MKMapView  *mapView;
@property (weak, nonatomic) IBOutlet    UILabel    *placeNameLabel;
//===
@property (nonatomic, strong) id<MKAnnotation> lastAnnotation;

@end

@implementation MUSPostLocationCell

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) postLocationCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

#pragma mark - height for PostLocationCell

+ (CGFloat) heightForPostLocationCell : (MUSPost*) currentPost {
    if (!currentPost.longitude.length > 0 || [currentPost.longitude isEqualToString: MUSApp_MUSPostLocationCell_StringNull] || !currentPost.latitude.length > 0 || [currentPost.latitude isEqualToString: MUSApp_MUSPostLocationCell_StringNull]) {
        return 0;
    } else {
        return MUSApp_MUSPostLocationCell_HeightOfCell;
    }
}

- (void)awakeFromNib {
    self.placeNameLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSPostLocationCell cellID];
}

#pragma mark - configuration PostLocationCell

- (void) configurationPostLocationCellByPostPlace: (MUSPost *) currentPost {
    [self initializeMapViewForCurrentPlace: currentPost];
}

#pragma mark initiation MapView for the currentPlace

- (void) initializeMapViewForCurrentPlace: (MUSPost*) currentPost {
    [self.mapView removeAnnotations: self.mapView.annotations];
    CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake([currentPost.latitude floatValue], [currentPost.longitude floatValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCityLocation, MUSApp_MUSPostLocationCell_CLLocationDistance, MUSApp_MUSPostLocationCell_CLLocationDistance);
    MUSAnnotation *pin = [[MUSAnnotation alloc] init];
    pin.coordinate = currentCityLocation;
    [self.mapView setRegion : region animated:YES];
    [self.mapView addAnnotation : pin];
}

@end
