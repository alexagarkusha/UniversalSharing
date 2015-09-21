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

@property (weak, nonatomic) IBOutlet UIImageView *firstImageOfPostImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfImagesInPostLabel;

@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconOfSocialNetworkImageView;

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* postDescriptionLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet UIView *checkMarkView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCheckMarkViewConstraint;

@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;

@property (weak, nonatomic) IBOutlet UILabel *updatingPostLabel;

@end

@implementation MUSPostCell

- (void)awakeFromNib {
    // Initialization code
    self.numberOfImagesInPostLabel.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.iconOfSocialNetworkImageView roundImageView];
    [self.reasonOfPostLabel cornerRadius: CGRectGetHeight(self.reasonOfPostLabel.frame) / 2];
    [self.numberOfImagesInPostLabel cornerRadius: CGRectGetHeight(self.numberOfImagesInPostLabel.frame) / 2];
    [self.numberOfCommentsLabel sizeToFit];
    [self.numberOfLikesLabel sizeToFit];
    self.updatingPostLabel.hidden = YES;
    [self initiationCheckMarkButton];
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
    [self configuratepostDescriptionLabelForPost: currentPost];
    [self configurateiconOfSocialNetworkImageViewForPost: currentPost];
    self.updatingPostLabel.hidden = NO;
}


- (void) configurationPostCell: (Post*) currentPost andFlagEditing: (BOOL) flagEdit andFlagForDelete :(BOOL) flagForDelete{
    self.updatingPostLabel.hidden = YES;
    [self configurateCommentsImageAndLabel: currentPost];
    [self configurateLikesImageAndLabel: currentPost];
    [self configuratereasonOfPostLabel: currentPost];
    [self configuratepostDescriptionLabelForPost: currentPost];
    [self configurateiconOfSocialNetworkImageViewForPost: currentPost];
    [self configurateEditableCell: flagEdit andIsCellDelete: flagForDelete];
    [self configurateFirstImageOfPost: currentPost];
}

- (void) configurateCommentsImageAndLabel : (Post*) post {
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat: @"%ld", (long) post.commentsCount];
}

- (void) configurateLikesImageAndLabel : (Post*) post {
    self.likeImageView.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.numberOfLikesLabel.text = [NSString stringWithFormat: @"%ld", (long)post.likesCount];
}

- (void) configuratereasonOfPostLabel : (Post*) post {
    self.reasonOfPostLabel.backgroundColor = [UIColor reasonColorForPost: post.reason];
    self.reasonOfPostLabel.text = [NSString reasonTypeInString: post.reason];
}

- (void) configuratepostDescriptionLabelForPost: (Post*) post {
    self.postDescriptionLabel.text = post.postDescription;
}

- (void) configurateiconOfSocialNetworkImageViewForPost: (Post*) post {
    self.iconOfSocialNetworkImageView.image = [UIImage iconOfSocialNetworkForPost: post];
}

- (void) configurateEditableCell : (BOOL) isCellEditable andIsCellDelete : (BOOL) isCellDelete {
    if (isCellEditable) {
        //self.widthConstrain.constant = 50.0f;
        [self changeButtonCheckMarkConstraintWithAnimation: 50.0f];
        self.checkMarkButton.hidden = NO;
        if (isCellDelete) {
            [self.checkMarkButton setSelected: YES];
        }else {
            [self.checkMarkButton setSelected: NO];
        }
    } else{
        //self.widthConstrain.constant = 0.0f;
        [self changeButtonCheckMarkConstraintWithAnimation: 0.0f];
        self.checkMarkButton.hidden = YES;
        [self.checkMarkButton setSelected: NO];
    }
}

- (void) changeButtonCheckMarkConstraintWithAnimation : (CGFloat) newLeftConstraint {
    self.widthCheckMarkViewConstraint.constant = newLeftConstraint;
    [UIView animateWithDuration: 0.4  animations:^{
        [self layoutIfNeeded];
        [self setNeedsLayout];
    }];
    [UIView commitAnimations];
}


- (void) configurateFirstImageOfPost : (Post*) currentPost {
    [self.firstImageOfPostImageView cornerRadius: 10.0 andBorderWidth: 0.0 withBorderColor: nil];
    
    if (![[currentPost.arrayImagesUrl firstObject] isEqualToString: @""] || ![currentPost.arrayImagesUrl firstObject]) {
        [self.firstImageOfPostImageView loadImageFromDataBase: [currentPost.arrayImagesUrl firstObject]];
        self.firstImageOfPostImageView.hidden = NO;
        self.postDescriptionLabelLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
        if (currentPost.arrayImagesUrl.count == 1) {
            self.numberOfImagesInPostLabel.hidden = YES;
        } else {
            self.numberOfImagesInPostLabel.hidden = NO;
            self.numberOfImagesInPostLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)currentPost.arrayImagesUrl.count];
        }
    } else {
        self.firstImageOfPostImageView.hidden = YES;
        self.numberOfImagesInPostLabel.hidden = YES;
        self.postDescriptionLabelLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
    }
}


- (void) initiationCheckMarkButton {
    [self.checkMarkButton setBackgroundImage:[UIImage imageNamed: musApp_PostCell_Image_Name_CheckMarkTaken] forState:UIControlStateSelected];
    [self.checkMarkButton setBackgroundImage:[UIImage imageNamed: musApp_PostCell_Image_Name_CheckMark] forState:UIControlStateNormal];
    self.checkMarkButton.hidden = YES;
}

- (void) checkIsSelectedPost {
    if ([self.checkMarkButton isSelected]) {
        [self.checkMarkButton setSelected:NO];
    } else {
        [self.checkMarkButton setSelected:YES];
    }
}

- (IBAction)buttonCheckMarkTapped:(id)sender {
    [self.delegate addIndexToIndexSetWithCell:self];
    [self checkIsSelectedPost];
}

@end
