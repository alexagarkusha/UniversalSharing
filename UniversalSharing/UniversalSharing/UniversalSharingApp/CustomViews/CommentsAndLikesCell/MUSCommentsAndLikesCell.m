//
//  MUSCommentsAndLikesCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCommentsAndLikesCell.h"
#import "ConstantsApp.h"

@interface MUSCommentsAndLikesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@end


@implementation MUSCommentsAndLikesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSCommentsAndLikesCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) commentsAndLikesCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

+ (CGFloat) heightForCommentsAndLikesCell {
    return musAppDetailPostVC_HeightOfCommentsAndLikesCell;
}

- (void) configurationCommentsAndLikesCellByPost:(Post *)currentPost {
    self.likeImageView.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.numberOfLikesLabel.text = [NSString stringWithFormat:@"%d", currentPost.likesCount];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%d", currentPost.commentsCount];
}


@end
