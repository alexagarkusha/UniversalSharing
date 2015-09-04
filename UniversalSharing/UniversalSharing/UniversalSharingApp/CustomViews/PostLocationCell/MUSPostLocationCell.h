//
//  MUSPostLocationCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@protocol MUSPostLocationCellDelegate <NSObject>

- (void) changeLocationForPost;

@end

@interface MUSPostLocationCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) postLocationCell;
+ (CGFloat) heightForPostLocationCell: (Place*) place andIsEditableCell : (BOOL) isEditableCell;

- (void) configurationPostLocationCellByPostPlace: (Place *) currentPlace;

@property (assign, nonatomic) id <MUSPostLocationCellDelegate> delegate;
@property (assign, nonatomic) BOOL isEditableCell;


@end
