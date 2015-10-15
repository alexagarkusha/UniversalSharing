//
//  MUSReasonCommentsAndLikesCell.m
//  UniversalSharing
//
//  Created by U 2 on 26.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSReasonCommentsAndLikesCell.h"
#import "ConstantsApp.h"
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

@end


@implementation MUSReasonCommentsAndLikesCell

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) reasonCommentsAndLikesCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

+ (CGFloat) heightForReasonCommentsAndLikesCell {
    return MUSApp_ReasonCommentsAndLikesCell_HeightOfRow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSReasonCommentsAndLikesCell cellID];
}

- (void) configurationReasonCommentsAndLikesCell: (MUSNetworkPost*) networkPost {
    [self configurateCommentsImageAndLabel: networkPost];
    [self configurateLikesImageAndLabel: networkPost];
    [self configurateReasonOfPostLabel: networkPost];
    [self configurateIconOfSocialNetworkImageViewForPost: networkPost];
}

- (void) configurateCommentsImageAndLabel : (MUSNetworkPost*) networkPost {
    self.commentImageView.image = [UIImage commentsIconByTypeOfSocialNetwork: networkPost.networkType];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat: @"%ld", (long) networkPost.commentsCount];
}

- (void) configurateLikesImageAndLabel : (MUSNetworkPost*) networkPost {
    self.likeImageView.image = [UIImage likesIconByTypeOfSocialNetwork: networkPost.networkType];
    self.numberOfLikesLabel.text = [NSString stringWithFormat: @"%ld", (long)networkPost.likesCount];
}

- (void) configurateReasonOfPostLabel : (MUSNetworkPost*) networkPost {
    NSString *reasonString = networkPost.stringReasonType;
    if (networkPost.reason == MUSConnect) {
        NSString *dateCreate = [NSString dateStringFromUNIXTimestamp: [networkPost.dateCreate doubleValue]];
        reasonString = [reasonString stringByAppendingString: @" "];
        reasonString = [reasonString stringByAppendingString: dateCreate];
    }
    self.reasonOfPostLabel.text = reasonString;
}

- (void) configurateIconOfSocialNetworkImageViewForPost: (MUSNetworkPost*) networkPost {
    self.iconOfSocialNetworkImageView.image = [UIImage greyIconOfSocialNetworkByTypeOfSocialNetwork: networkPost.networkType];
}


@end
