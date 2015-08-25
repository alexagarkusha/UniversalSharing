//
//  MUSPostCell.h
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface MUSPostCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) postCell;
+ (CGFloat) heightForPostCell;

- (void) configurationPostCell: (Post*) currentPost;

@end
