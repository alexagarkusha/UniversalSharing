//
//  MUSLocationTableViewController.h
//  UniversalSharing
//
//  Created by Roman on 8/3/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface MUSLocationTableViewController : UITableViewController
- (void)setArrayPlaces:(NSArray*)arrayPlaces;
@property (copy, nonatomic) Complition placeComplition;

@end
