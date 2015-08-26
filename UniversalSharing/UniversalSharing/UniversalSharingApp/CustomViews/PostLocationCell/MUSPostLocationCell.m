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
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeLocationButtonOutlet;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) id<MKAnnotation> lastAnnotation;
@property (weak, nonatomic) IBOutlet UIView *addLocationView;


- (IBAction)changeLocationButtonTouch:(id)sender;

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

+ (CGFloat) heightForPostLocationCell {
    return musAppDetailPostVC_HeightOfPostLocationCell;
}

- (void) configurationPostLocationCellByPostPlace: (Place *) currentPlace {
    //CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)
    [self checkChangeLocationButtonStatus];
    if (!currentPlace) {
        
    } else {
        self.addLocationView.hidden = YES;
        if (currentPlace.fullName) {
            self.placeNameLabel.hidden = NO;
            self.placeNameLabel.text = [NSString stringWithFormat: @"%@", currentPlace.fullName];
        }
#warning "add pin every time"
        CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake([currentPlace.latitude floatValue], [currentPlace.longitude floatValue]);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCityLocation, 400, 400);
        
        
        
        MUSAnnotation *pin = [[MUSAnnotation alloc] init];
        pin.title = currentPlace.fullName;
        pin.coordinate = currentCityLocation;
        [self.mapView setRegion:region animated:YES];
        [self.mapView removeAnnotation:pin];
        [self.mapView addAnnotation:pin];
    }
}

- (void) checkChangeLocationButtonStatus {
    if (!self.isEditableCell) {
        self.changeLocationButtonOutlet.hidden = YES;
    } else {
        self.changeLocationButtonOutlet.hidden = NO;
    }
}


- (IBAction)changeLocationButtonTouch:(id)sender {
    [self.delegate changeLocationForPost];
}

@end
