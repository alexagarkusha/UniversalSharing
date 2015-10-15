//
//  GeneralUserInfoTableViewCell.h
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSUser.h"

@interface MUSUserProfileCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) generalUserInfoTableViewCell;
+ (CGFloat) heightForGeneralUserInfoWithCurrentPropertyOfUser : (NSString*) userProperty;
//===
- (void) configurationUserTableViewCell: (MUSUser*) currentUser withInfo : (NSString*) userInfo;

@end
