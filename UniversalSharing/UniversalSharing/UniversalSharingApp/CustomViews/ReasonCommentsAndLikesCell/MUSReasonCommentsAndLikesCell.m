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
#import "UIImage+SocialNetworkIcons.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+DateStringFromUNIXTimestamp.h"

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


@interface MUSReasonCommentsAndLikesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconOfSocialNetworkImageView;

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundViewOfCell;

@end


@implementation MUSReasonCommentsAndLikesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //self.backgroundViewOfCell.backgroundColor = BROWN_COLOR_Light;
    //self.backgroundColor = BROWN_COLOR_Light;
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
    self.commentImageView.image = [UIImage commentsIconByTypeOfSocialNetwork: networkPost.networkType];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat: @"%ld", (long) networkPost.commentsCount];
}

- (void) configurateLikesImageAndLabel : (NetworkPost*) networkPost {
    self.likeImageView.image = [UIImage likesIconByTypeOfSocialNetwork: networkPost.networkType];
    self.numberOfLikesLabel.text = [NSString stringWithFormat: @"%ld", (long)networkPost.likesCount];
}

- (void) configurateReasonOfPostLabel : (NetworkPost*) networkPost {
    NSString *reasonString = networkPost.stringReasonType;
    if (networkPost.reason == Connect) {
        NSString *dateCreate = [NSString dateStringFromUNIXTimestamp: [networkPost.dateCreate doubleValue]];
        reasonString = [reasonString stringByAppendingString: @" "];
        reasonString = [reasonString stringByAppendingString: dateCreate];
    }
    self.reasonOfPostLabel.text = reasonString;
}

- (void) configurateIconOfSocialNetworkImageViewForPost: (NetworkPost*) networkPost {
    self.iconOfSocialNetworkImageView.image = [UIImage iconOfSocialNetworkForNetworkPost: networkPost];
}

- (void) leftBorder {
    CALayer *leftBorder = [CALayer layer];
    leftBorder.backgroundColor = [BROWN_COLOR_MIDLight CGColor];
    leftBorder.frame = CGRectMake(0, 0, 3.0f, CGRectGetHeight (self.backgroundViewOfCell.frame) + 1);
    [self.backgroundViewOfCell.layer addSublayer: leftBorder];
}

@end
