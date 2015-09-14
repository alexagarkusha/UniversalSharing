//
//  MUSLocationCell.h
//  UniversalSharing
//
//  Created by U 2 on 11.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@protocol MUSLocationCellDelegate <NSObject>
@required
- (void) deleteChosenPlaceFromTableViewAndMap;
@end


@interface MUSLocationCell : UITableViewCell

@property (nonatomic, assign) id <MUSLocationCellDelegate> delegate;

+ (NSString*) cellID;
+ (NSString *)reuseIdentifier;
+ (instancetype) locationCell;
+ (CGFloat) heightForLocationCell: (Place *) place;
+ (UIFont*) fontForCell;

- (void) configurationLocationCell: (Place*) currentPlace;


@end
