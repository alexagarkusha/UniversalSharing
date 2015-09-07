//
//  MUSAnnotation.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSAnnotation.h"

@implementation MUSAnnotation

- (id) initWithTitle: (NSString *) newTitle andLocation: (CLLocationCoordinate2D) location {
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

/*
- (MKAnnotationView*) annotationView {
    
    UIButton * disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [disclosureButton addTarget:self action:@selector(presentMoreInfo) forControlEvents:UIControlEventTouchUpInside];

    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation: self reuseIdentifier: NSStringFromClass([self class])];
    annotationView.canShowCallout = YES;
    annotationView.enabled = YES;
    annotationView.image = [UIImage imageNamed:@"like.png"];
    //annotationView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = disclosureButton;
    
    return annotationView;
}
*/
 
- (MKPinAnnotationView*) annotationPinView {
    UIButton * disclosureButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [disclosureButton addTarget:self action:@selector(presentMoreInfo) forControlEvents:UIControlEventTouchUpInside];
    
    MKPinAnnotationView *annotationPinView = [[MKPinAnnotationView alloc] initWithAnnotation: self reuseIdentifier: NSStringFromClass([self class])];
    annotationPinView.canShowCallout = YES;
    annotationPinView.enabled = YES;
    annotationPinView.rightCalloutAccessoryView = disclosureButton;
    return annotationPinView;
}

- (void) presentMoreInfo {
    NSLog(@"Click annotation");
}

@end
