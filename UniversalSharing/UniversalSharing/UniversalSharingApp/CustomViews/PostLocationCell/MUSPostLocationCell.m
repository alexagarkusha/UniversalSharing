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
#import "UIButton+MUSEditableButton.h"

@interface MUSPostLocationCell () <MKMapViewDelegate>

- (IBAction)changeLocationButtonTouch:(id)sender;

@property (weak, nonatomic) IBOutlet  UIView *addLocationView;
@property (weak, nonatomic) IBOutlet  UIButton *changeLocationButtonOutlet;
@property (weak, nonatomic) IBOutlet  UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet  MKMapView *mapView;

@property (nonatomic, strong) id<MKAnnotation> lastAnnotation;

@end

@implementation MUSPostLocationCell

- (void)awakeFromNib {
    // Initialization code
    self.placeNameLabel.hidden = YES;
    [self.changeLocationButtonOutlet editableButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (NSString *)reuseIdentifier{
    return [MUSPostLocationCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) postLocationCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

#pragma mark - height for PostLocationCell

+ (CGFloat) heightForPostLocationCell {
    return musAppDetailPostVC_HeightOfPostLocationCell;
}

#pragma mark - configuration PostLocationCell

- (void) configurationPostLocationCellByPostPlace: (Place *) currentPlace {
    [self checkChangeLocationButtonStatus];
    if (currentPlace) {
        [self initialMapViewForCurrentPlace: currentPlace];
    }
}

#pragma mark initiation MapView for the currentPlace

- (void) initialMapViewForCurrentPlace: (Place*) currentPlace {
    self.addLocationView.hidden = YES;
    [self.mapView removeAnnotations: self.mapView.annotations];
    if (currentPlace.fullName.length > 0) {
        self.placeNameLabel.hidden = NO;
        self.placeNameLabel.text = [NSString stringWithFormat: @"%@", currentPlace.fullName];
    }
    CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake([currentPlace.latitude floatValue], [currentPlace.longitude floatValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCityLocation, 500, 500);
    MUSAnnotation *pin = [[MUSAnnotation alloc] init];
    pin.title = currentPlace.fullName;
    pin.coordinate = currentCityLocation;
    [self.mapView setRegion : region animated:YES];
    [self.mapView addAnnotation : pin];
}

#pragma mark check ChangeLocationButton status

- (void) checkChangeLocationButtonStatus {
    if (!self.isEditableCell) {
        self.changeLocationButtonOutlet.hidden = YES;
    } else {
        self.changeLocationButtonOutlet.hidden = NO;
    }
}

#pragma mark ChangeLocationButton touch

- (IBAction)changeLocationButtonTouch:(id)sender {
    [self.delegate changeLocationForPost];
}

@end
