//
//  MUSPopUpTableViewCell.h
//  UniversalSharing
//
//  Created by Roman on 9/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialNetwork.h"

@protocol MUSPopUpTableViewCellDelegate <NSObject>

- (void) setChangeSwitchButtonWithValue : (BOOL) value andKey :(NSString*) key;

@end

@interface MUSPopUpTableViewCell : UITableViewCell

@property (nonatomic, assign) id <MUSPopUpTableViewCellDelegate> delegate;
//===
+ (NSString*) cellID;
+ (instancetype) popUpTableViewCell;
- (void) configurationPopUpTableViewCellWith: (SocialNetwork*) socialNetwork andReason: (ReasonType) currentReason;

@end
