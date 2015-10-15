//
//  MUSPostDescriptionCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@interface MUSPostDescriptionCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) postDescriptionCell;
+ (CGFloat) heightForPostDescriptionCell : (NSString*) postDescription;
//===
- (void) configurationPostDescriptionCell: (NSString*) postDescription;

@end
