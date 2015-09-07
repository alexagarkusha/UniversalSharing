//
//  MUSCustomMapView.h
//  UniversalSharing
//
//  Created by U 2 on 07.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSCustomMapView : UIView

+ (NSString*) viewID;

- (void) initiationMapView : (NSArray*) arrayOfPlaces withDistance : (CGFloat) distance;


@property (nonatomic, strong) NSArray *arrayOfPlaces;

@end
