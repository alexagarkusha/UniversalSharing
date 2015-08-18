//
//  MUSPostDescriptionCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@protocol MUSPostDescriptionCellDelegate <NSObject>
- (void) heightOfPostDescriptionRow : (CGFloat) heightRow;
@end



@interface MUSPostDescriptionCell : UITableViewCell

@property (nonatomic, assign) id <MUSPostDescriptionCellDelegate> delegate;

+ (NSString*) cellID;
+ (instancetype) postDescriptionCell;

- (void) configurationPostDescriptionCellByPost: (Post*) currentPost;


@end
