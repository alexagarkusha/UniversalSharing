//
//  MUSPostLocationCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@interface MUSPostLocationCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) postLocationCell;

- (void) configurationPostLocationCellByPost: (Post*) currentPost;

@end
