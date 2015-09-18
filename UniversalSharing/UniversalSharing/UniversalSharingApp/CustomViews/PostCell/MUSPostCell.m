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

@property (weak, nonatomic) IBOutlet UIView *viewCheckMark;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstrain;

@property (weak, nonatomic) IBOutlet UIButton *buttonCheckMark;

@property (weak, nonatomic) IBOutlet UILabel *labelUpdatingPost;

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
    self.labelUpdatingPost.hidden = YES;
    [self initiationButtonCheckMark];
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

- (void) configurationUpdatingPostCell: (Post*) currentPost {
    [self configurateCommentsImageAndLabel: currentPost];
    [self configurateLikesImageAndLabel: currentPost];
    [self configuratePostDescriptionForPost: currentPost];
    [self configurateIconOfSocialNetworkForPost: currentPost];
    self.labelUpdatingPost.hidden = NO;
}


- (void) configurationPostCell: (Post*) currentPost andFlagEditing: (BOOL) flagEdit andFlagForDelete :(BOOL) flagForDelete{
    self.labelUpdatingPost.hidden = YES;
    [self configurateCommentsImageAndLabel: currentPost];
    [self configurateLikesImageAndLabel: currentPost];
    [self configurateReasonOfPost: currentPost];
    [self configuratePostDescriptionForPost: currentPost];
    [self configurateIconOfSocialNetworkForPost: currentPost];
    [self configurateEditableCell: flagEdit andIsCellDelete: flagForDelete];
    [self configurateFirstImageOfPost: currentPost];
}

- (void) configurateCommentsImageAndLabel : (Post*) post {
    self.commentImage.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.numberOfComments.text = [NSString stringWithFormat: @"%ld", (long) post.commentsCount];
}

- (void) configurateLikesImageAndLabel : (Post*) post {
    self.likeImage.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.numberOfLikes.text = [NSString stringWithFormat: @"%ld", (long)post.likesCount];
}

- (void) configurateReasonOfPost : (Post*) post {
    self.reasonOfPost.backgroundColor = [UIColor reasonColorForPost: post.reason];
    self.reasonOfPost.text = [NSString reasonTypeInString: post.reason];
}

- (void) configuratePostDescriptionForPost: (Post*) post {
    self.postDescription.text = post.postDescription;
}

- (void) configurateIconOfSocialNetworkForPost: (Post*) post {
    self.iconOfSocialNetwork.image = [UIImage iconOfSocialNetworkForPost: post];
}

- (void) configurateEditableCell : (BOOL) isCellEditable andIsCellDelete : (BOOL) isCellDelete {
    if (isCellEditable) {
        self.widthConstrain.constant = 50.0f;
        self.buttonCheckMark.hidden = NO;
        if (isCellDelete) {
            [self.buttonCheckMark setSelected: YES];
        }else {
            [self.buttonCheckMark setSelected: NO];
        }
    } else{
        self.widthConstrain.constant = 0.0f;
        self.buttonCheckMark.hidden = YES;
        [self.buttonCheckMark setSelected: NO];
    }
}

- (void) configurateFirstImageOfPost : (Post*) currentPost {
    [self.firstImageOfPost cornerRadius: 10.0 andBorderWidth: 0.0 withBorderColor: nil];
    
    //self.firstImageOfPost.image = nil;
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


- (void) initiationButtonCheckMark {
    [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMarkTaken.jpeg"] forState:UIControlStateSelected];
    [self.buttonCheckMark setBackgroundImage:[UIImage imageNamed: @"checkMark.jpeg"] forState:UIControlStateNormal];
    self.buttonCheckMark.hidden = YES;
}

- (void) checkIsSelectedPost {
    if ([self.buttonCheckMark isSelected])
    {
        [self.buttonCheckMark setSelected:NO];
    }
    else
    {
        [self.buttonCheckMark setSelected:YES];
    }
}


/*
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
 
 */



- (IBAction)buttonCheckMarkTapped:(id)sender {
    [self.delegate addIndexToIndexSetWithCell:self];
    [self checkIsSelectedPost];
}

@end
