//
//  GeneralUserInfoTableViewCell.h
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MUSUserProfileCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) generalUserInfoTableViewCell;

- (void) configurationGeneralUserInfoTableViewCellWithUser: (User*) currentUser andCurrentProperty : (NSString*) userProperty;



@end
