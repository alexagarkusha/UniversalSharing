//
//  MUSReasonCommentsAndLikesCell.m
//  UniversalSharing
//
//  Created by U 2 on 26.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSReasonCommentsAndLikesCell.h"
#import "ConstantsApp.h"
#import "UIImage+IconOfSocialNetwork.h"
#import "NSString+ReasonTypeInString.h"
#import "UIImage+LikeIconOfSocialNetwork.h"


@interface MUSReasonCommentsAndLikesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconOfSocialNetworkImageView;

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;


@end


@implementation MUSReasonCommentsAndLikesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSReasonCommentsAndLikesCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}
+ (instancetype) reasonCommentsAndLikesCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}
+ (CGFloat) heightForReasonCommentsAndLikesCell {
    return musAppCommentsAndLikesCell_HeightOfRow;
}

- (void) configurationReasonCommentsAndLikesCell: (NetworkPost*) networkPost {
    [self configurateCommentsImageAndLabel: networkPost];
    [self configurateLikesImageAndLabel: networkPost];
    [self configurateReasonOfPostLabel: networkPost];
    [self configurateIconOfSocialNetworkImageViewForPost: networkPost];
}

- (void) configurateCommentsImageAndLabel : (NetworkPost*) networkPost {
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_CommentsImage];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat: @"%ld", (long) networkPost.commentsCount];
}

- (void) configurateLikesImageAndLabel : (NetworkPost*) networkPost {
    self.likeImageView.image = [UIImage likeIconOfSocialNetwork: networkPost.networkType];
    self.numberOfLikesLabel.text = [NSString stringWithFormat: @"%ld", (long)networkPost.likesCount];
}

- (void) configurateReasonOfPostLabel : (NetworkPost*) networkPost {
    self.reasonOfPostLabel.text = [NSString reasonTypeInString: networkPost.reason];
}

- (void) configurateIconOfSocialNetworkImageViewForPost: (NetworkPost*) networkPost {
    self.iconOfSocialNetworkImageView.image = [UIImage iconOfSocialNetworkForNetworkPost: networkPost];
}




@end
