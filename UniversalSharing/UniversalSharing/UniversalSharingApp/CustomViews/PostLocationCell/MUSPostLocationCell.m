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

- (void) configurationPostLocationCellByPost:(Post *)currentPost {
    //CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)
    [self checkChangeLocationButtonStatus];
    
    /*
    if (currentPost.placeName) {
        self.placeNameLabel.hidden = NO;
        self.placeNameLabel.text = [NSString stringWithFormat: currentPost.placeName];
    }
    */
    
#warning "add pin every time"
    CLLocationCoordinate2D currentCityLocation = CLLocationCoordinate2DMake(48.450063, 34.982602);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCityLocation, 400, 400);
    MUSAnnotation *pin = [[MUSAnnotation alloc] init];
    pin.title = @"Some house";
    pin.coordinate = currentCityLocation;
    [self.mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:pin];
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
