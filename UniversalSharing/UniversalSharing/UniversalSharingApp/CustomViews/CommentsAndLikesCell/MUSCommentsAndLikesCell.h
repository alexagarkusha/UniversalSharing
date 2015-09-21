//
//  MUSCommentsAndLikesCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@protocol MUSCommentsAndLikesCellDelegate <NSObject>
/*!
 @method
 @abstract show MUSUserDetailViewController
 */
- (void) showUserProfile;
@end

@interface MUSCommentsAndLikesCell : UITableViewCell

@property (nonatomic, assign) id <MUSCommentsAndLikesCellDelegate> delegate;

+ (NSString*) cellID;
+ (instancetype) commentsAndLikesCell;
+ (CGFloat) heightForCommentsAndLikesCell;

- (void) configurationCommentsAndLikesCellByPost: (Post*) currentPost socialNetworkIconName : (NSString*) socialNetworkIconName andUser : (User*) user;

@end
