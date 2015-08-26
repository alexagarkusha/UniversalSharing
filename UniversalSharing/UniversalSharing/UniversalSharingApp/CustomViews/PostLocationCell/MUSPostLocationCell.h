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
@property (nonatomic, assign) id <MUSPostLocationCellDelegate> delegate;
@property (nonatomic, assign) BOOL isEditableCell;

+ (NSString*) cellID;
+ (instancetype) postLocationCell;
+ (CGFloat) heightForPostLocationCell;


- (void) configurationPostLocationCellByPostPlace: (Place *) currentPlace;

@end
