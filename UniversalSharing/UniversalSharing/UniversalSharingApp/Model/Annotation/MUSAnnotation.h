//
//  MUSAnnotation.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MUSAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id) initWithTitle: (NSString *) newTitle andLocation: (CLLocationCoordinate2D) location;
//- (MKAnnotationView*) annotationView;
- (MKPinAnnotationView*) annotationPinView;

@end
