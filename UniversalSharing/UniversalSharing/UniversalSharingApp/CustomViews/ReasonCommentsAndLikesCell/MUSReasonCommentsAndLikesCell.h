//
//  MUSReasonCommentsAndLikesCell.h
//  UniversalSharing
//
//  Created by U 2 on 26.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@interface MUSReasonCommentsAndLikesCell : UITableViewCell

+ (NSString*) cellID;
+ (instancetype) reasonCommentsAndLikesCell;
+ (CGFloat) heightForReasonCommentsAndLikesCell;

- (void) configurationReasonCommentsAndLikesCell: (MUSNetworkPost*) networkPost;

//@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
