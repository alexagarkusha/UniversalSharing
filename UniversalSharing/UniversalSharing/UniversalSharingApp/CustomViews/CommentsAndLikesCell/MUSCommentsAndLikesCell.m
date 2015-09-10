//
//  MUSCommentsAndLikesCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCommentsAndLikesCell.h"
#import "ConstantsApp.h"
#import "NSString+ReasonTypeInString.h"
#import "UILabel+CornerRadiusLabel.h"
#import "UIColor+ReasonColorForPost.h"

@interface MUSCommentsAndLikesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonPostLabel;

@end


@implementation MUSCommentsAndLikesCell

- (void)awakeFromNib {
    // Initialization code
    [self.reasonPostLabel cornerRadius: CGRectGetHeight(self.reasonPostLabel.frame) / 2];
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

#pragma mark - height for CommentsAndLikesCell

+ (CGFloat) heightForCommentsAndLikesCell {
    return musAppDetailPostVC_HeightOfCommentsAndLikesCell;
}

#pragma mark - configuration CommentsAndLikesCellByPost

- (void) configurationCommentsAndLikesCellByPost:(Post *)currentPost {
    self.likeImageView.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.numberOfLikesLabel.text = [NSString stringWithFormat:@"%ld", (long)currentPost.likesCount];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%ld", (long)currentPost.commentsCount];
    self.reasonPostLabel.text = [NSString reasonTypeInString: currentPost.reason];
    self.reasonPostLabel.backgroundColor = [UIColor reasonColorForPost: currentPost.reason];
}





@end
