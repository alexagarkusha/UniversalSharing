//
//  MUSPostCell.h
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol MUSPostCellDelegate <NSObject>
@required
- (void) addIndexToIndexSetWithCell :(id) cell ;
@end

@interface MUSPostCell : UITableViewCell
@property (nonatomic, assign) id <MUSPostCellDelegate> delegate;
//@property (weak, nonatomic) IBOutlet UIButton *buttonCheckMark;

+ (NSString*) cellID;
+ (instancetype) postCell;
+ (CGFloat) heightForPostCell;

- (void) configurationUpdatingPostCell: (Post*) currentPost;
- (void) configurationPostCell: (Post*) currentPost andFlagEditing:(BOOL) flagEdit andFlagForDelete :(BOOL) flagForDelete;

@end
