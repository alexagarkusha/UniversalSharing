//
//  MUSPostCell.m
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostCell.h"
#import "ConstantsApp.h"
#import "ImageToPost.h"
#import "UILabel+CornerRadiusLabel.h"
#import "UIImageView+RoundImage.h"
#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "UIColor+ReasonColorForPost.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"
#import "UIImage+IconOfSocialNetwork.h"
#import "NSString+ReasonTypeInString.h"

@interface MUSPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *firstImageOfPost;
@property (weak, nonatomic) IBOutlet UILabel *numberOfImagesInPost;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;
@property (weak, nonatomic) IBOutlet UIImageView *iconOfSocialNetwork;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *numberOfComments;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UILabel *reasonOfPost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* postDescriptionLeftConstraint;
//===
@property (weak, nonatomic) IBOutlet UIView *viewCheckMark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstrain;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckMark;


@end

@implementation MUSPostCell

- (void)awakeFromNib {
    // Initialization code
    self.numberOfImagesInPost.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.iconOfSocialNetwork roundImageView];
    [self.reasonOfPost cornerRadius: CGRectGetHeight(self.reasonOfPost.frame) / 2];
    [self.numberOfImagesInPost cornerRadius: CGRectGetHeight(self.numberOfImagesInPost.frame) / 2];
    [self.numberOfComments sizeToFit];
    [self.numberOfLikes sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSPostCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) postCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

+ (CGFloat) heightForPostCell {
    return musAppPostsVC_HeightOfPostCell;
}

- (void) configurationPostCell: (Post*) currentPost andFlagEditing: (BOOL) flagEdit andFlagForDelete :(BOOL) flagForDelete{
    
    self.postDescription.text = currentPost.postDescription;
    self.numberOfComments.text = [NSString stringWithFormat: @"%ld", (long)currentPost.commentsCount];
    self.iconOfSocialNetwork.image = [UIImage iconOfSocialNetworkForPost: currentPost];
    self.numberOfLikes.text = [NSString stringWithFormat: @"%ld", (long)currentPost.likesCount];
    self.commentImage.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.reasonOfPost.backgroundColor = [UIColor reasonColorForPost: currentPost.reason];
    self.reasonOfPost.text = [NSString reasonTypeInString: currentPost.reason];
    self.likeImage.image = [UIImage imageNamed: musAppImage_Name_Like];
    
    if (flagEdit) {
        self.widthConstrain.constant = 50.0f;
        
        if (flagForDelete) {
            [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMarkTaken.jpeg"] forState:UIControlStateNormal];
            self.buttonCheckMark.tag = 1;
        }else {
            [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMark.jpeg"] forState:UIControlStateNormal];
            self.buttonCheckMark.tag = 0;
        }
        
    } else{
        self.widthConstrain.constant = 0.0f;
        [self.buttonCheckMark setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    [self configurateFirstImageOfPost: currentPost];

    
    //    if (flagSellectAll && flagEdit) {
    //        [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMarkTaken.jpeg"] forState:UIControlStateNormal];
    //        self.buttonCheckMark.tag = 1;
    //        self.widthConstrain.constant = 50.0f;
    //    } else if(!flagSellectAll && flagEdit){
    //        [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMark.jpeg"] forState:UIControlStateNormal];
    //        self.buttonCheckMark.tag = 0;
    //        self.widthConstrain.constant = 50.0f;
    //    } else {
    //        self.widthConstrain.constant = 0.0f;
    //        [self.buttonCheckMark setBackgroundImage:nil forState:UIControlStateNormal];
    //    }
}

- (void) configurateFirstImageOfPost : (Post*) currentPost {
    [self.firstImageOfPost cornerRadius: 10.0 andBorderWidth: 0.0 withBorderColor: nil];
    
    self.firstImageOfPost.image = nil;
    if (![[currentPost.arrayImagesUrl firstObject] isEqualToString: @""] || ![currentPost.arrayImagesUrl firstObject]) {
        [self.firstImageOfPost loadImageFromDataBase: [currentPost.arrayImagesUrl firstObject]];
        self.firstImageOfPost.hidden = NO;
        self.postDescriptionLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
        if (currentPost.arrayImagesUrl.count == 1) {
            self.numberOfImagesInPost.hidden = YES;
        } else {
            self.numberOfImagesInPost.hidden = NO;
            self.numberOfImagesInPost.text = [NSString stringWithFormat: @"%lu", (unsigned long)currentPost.arrayImagesUrl.count];
        }
    } else {
        self.firstImageOfPost.hidden = YES;
        self.numberOfImagesInPost.hidden = YES;
        self.postDescriptionLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
    }
}

- (IBAction)buttonCheckMarkTapped:(id)sender {
    [self.delegate addIndexToIndexSetWithCell:self];
    if ([sender tag] == 0) {
        [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMarkTaken.jpeg"] forState:UIControlStateNormal];
        self.buttonCheckMark.tag = 1;
    } else {
        [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMark.jpeg"] forState:UIControlStateNormal];
        self.buttonCheckMark.tag = 0;
    }
}

@end
