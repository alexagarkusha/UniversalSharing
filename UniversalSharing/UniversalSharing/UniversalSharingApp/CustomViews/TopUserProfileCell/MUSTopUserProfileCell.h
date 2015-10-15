//
//  ProfileUserTableViewCell.h
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSUser.h"

@interface MUSTopUserProfileCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) profileUserTableViewCell;
//===
- (void) configurationProfileUserTableViewCellWithUser: (MUSUser*) currentUser;

@end
