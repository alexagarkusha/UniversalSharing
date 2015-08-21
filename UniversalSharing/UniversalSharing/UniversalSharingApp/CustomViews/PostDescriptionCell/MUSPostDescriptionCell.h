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
- (void) saveChangesInPostDescription : (NSString*) postDescription;
@end



@interface MUSPostDescriptionCell : UITableViewCell

@property (nonatomic, assign) id <MUSPostDescriptionCellDelegate> delegate;
@property (nonatomic, assign) BOOL isEditableCell;

@property (weak, nonatomic) IBOutlet UITextView *postDescriptionTextView;


+ (NSString*) cellID;
+ (instancetype) postDescriptionCell;
+ (CGFloat) heightForPostDescriptionCell : (NSString*) postDescription;

- (void) configurationPostDescriptionCell: (NSString*) postDescription;


@end
