//
//  LoginTableViewCell.h
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import <AFMSlidingCell.h>

@interface MUSAccountTableViewCell : UITableViewCell//AFMSlidingCell

+ (NSString*) cellID;
+ (instancetype) accountTableViewCell;
//===
- (void) configurateCellForNetwork : (SocialNetwork*) socialNetwork;
- (void) changeColorOfCell :(SocialNetwork *)socialNetwork;



@end


