//
//  MUSCommentsAndLikesCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@interface MUSCommentsAndLikesCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) commentsAndLikesCell;
+ (CGFloat) heightForCommentsAndLikesCell : (NSArray*) networkPostsArray;
//===
- (void) configurationCommentsAndLikesCell;
//===
@property (nonatomic, strong) NSMutableArray *networkPostsArray;

@end
