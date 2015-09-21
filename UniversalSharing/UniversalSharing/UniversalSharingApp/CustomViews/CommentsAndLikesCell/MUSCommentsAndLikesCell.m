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
#import "NSString+DateStringFromUNIXTimestamp.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"
#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "UIButton+CornerRadiusButton.h"
#import "UIImage+LoadImageFromDataBase.h"

@interface MUSCommentsAndLikesCell ()

@property (weak, nonatomic)     IBOutlet    UIImageView *likeImageView;
@property (weak, nonatomic)     IBOutlet    UILabel *numberOfLikesLabel;
@property (weak, nonatomic)     IBOutlet    UIImageView *commentImageView;
@property (weak, nonatomic)     IBOutlet    UILabel *numberOfCommentsLabel;
@property (weak, nonatomic)     IBOutlet    UILabel *reasonPostLabel;
@property (weak, nonatomic)     IBOutlet    UIImageView *userPhotoImageView;
@property (weak, nonatomic)     IBOutlet    UILabel *usernameLabel;
@property (weak, nonatomic)     IBOutlet    UILabel *dateOfPostLabel;
@property (weak, nonatomic)     IBOutlet    UIButton *buttonUserProfile;

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

// NEED Current USER, socialNetworkIconName


- (void) configurationCommentsAndLikesCellByPost: (Post*) currentPost socialNetworkIconName : (NSString*) socialNetworkIconName andUser : (User*) user {
    self.likeImageView.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_Comment];
    [self initiationCommentsLabel: currentPost];
    [self initiationReasonLabel: currentPost];
    [self initiationUserNameLabel: user];
    [self initiationUserDateOfPostLabel: currentPost.dateCreate];
    [self initiationUserPhotoImageView: socialNetworkIconName];
}

#pragma mark initiation Comments Label

- (void) initiationCommentsLabel : (Post*) currentPost {
    self.numberOfLikesLabel.text = [NSString stringWithFormat:@"%ld", (long)currentPost.likesCount];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%ld", (long)currentPost.commentsCount];
}

#pragma mark initiation Reason Label

- (void) initiationReasonLabel : (Post*) currentPost {
    self.reasonPostLabel.text = [NSString reasonTypeInString: currentPost.reason];
    self.reasonPostLabel.backgroundColor = [UIColor reasonColorForPost: currentPost.reason];
}

#pragma mark initiation UserNameLabel

- (void) initiationUserNameLabel : (User*) user{
        self.usernameLabel.textColor = [UIColor blackColor];
        //self.usernameLabel.shadowColor = [UIColor whiteColor];
        self.dateOfPostLabel.textColor = [UIColor blackColor];
        //self.dateOfPostLabel.shadowColor = [UIColor whiteColor];
    self.usernameLabel.text = [NSString stringWithFormat: @"%@ %@", user.lastName, user.firstName];
    [self.usernameLabel sizeToFit];
}

#pragma mark initiation UserDateOfPostLabel

- (void) initiationUserDateOfPostLabel : (NSString*) dateOfPostCreate {
    self.dateOfPostLabel.text = [NSString dateStringFromUNIXTimestamp: [dateOfPostCreate integerValue]];
    [self.dateOfPostLabel sizeToFit];
}

#pragma mark initiation UserPhotoImageView

- (void) initiationUserPhotoImageView : (NSString*) socialNetworkIconName {
    [self.buttonUserProfile cornerRadius: CGRectGetHeight(self.buttonUserProfile.frame) / 2];
    UIImage *profileImage = [[UIImage alloc] init];
    profileImage = [profileImage loadImageFromDataBase: socialNetworkIconName];
    [self.buttonUserProfile setImage: profileImage forState:UIControlStateNormal];
    [self.buttonUserProfile.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.buttonUserProfile.layer setBorderWidth: 1.0f];
    [self.buttonUserProfile.layer setBorderColor: [UIColor darkGrayColor].CGColor];
}

- (IBAction)profileButtonTouch:(id)sender {
    [self.delegate showUserProfile];
}

@end
