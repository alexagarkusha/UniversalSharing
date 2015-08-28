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
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;


@end

@implementation MUSPostCell

- (void)awakeFromNib {
    // Initialization code
    self.numberOfImagesInPost.hidden = YES;
    self.backgroundColor = YELLOW_COLOR_Slightly;
    [self.iconOfSocialNetwork roundImageView];
    [self.reasonOfPost cornerRadius: CGRectGetHeight(self.reasonOfPost.frame) / 2];
    [self.numberOfImagesInPost cornerRadius: CGRectGetHeight(self.numberOfImagesInPost.frame) / 2];
    [self.numberOfComments sizeToFit];
    [self.numberOfLikes sizeToFit];
    [self initiationBackgroundImageView];
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

- (void) configurationPostCell: (Post*) currentPost {
    [self configurateFirstImageOfPost: currentPost];
    self.postDescription.text = currentPost.postDescription;
    self.numberOfComments.text = [NSString stringWithFormat: @"%ld", (long)currentPost.commentsCount];
    self.iconOfSocialNetwork.image = [self iconOfSocialNetworkForPost : currentPost];
    self.numberOfLikes.text = [NSString stringWithFormat: @"%ld", (long)currentPost.likesCount];
    self.commentImage.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.reasonOfPost.backgroundColor = [UIColor reasonColorForPost: currentPost.reason];
    self.likeImage.image = [UIImage imageNamed: musAppImage_Name_Like];
}

- (void) configurateFirstImageOfPost : (Post*) currentPost {
    [self.firstImageOfPost cornerRadius: 10.0 andBorderWidth: 0.0 withBorderColor: nil];
    
    self.firstImageOfPost.image = nil;
    if (![[currentPost.arrayImagesUrl firstObject] isEqualToString: @""] || ![currentPost.arrayImagesUrl firstObject]) {
        [self.firstImageOfPost loadImageFromDataBase: [currentPost.arrayImagesUrl firstObject]];
        if (currentPost.arrayImagesUrl.count == 1) {
            self.numberOfImagesInPost.hidden = YES;
        } else {
            self.numberOfImagesInPost.hidden = NO;
            self.numberOfImagesInPost.text = [NSString stringWithFormat: @"%lu", (unsigned long)currentPost.arrayImagesUrl.count];
        }
    }
    
    if (!self.firstImageOfPost.image) {
        self.firstImageOfPost.hidden = YES;
        self.numberOfImagesInPost.hidden = YES;
        self.postDescriptionLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
    } else {
        self.firstImageOfPost.hidden = NO;
        self.postDescriptionLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
    }
}

- (UIImage*) iconOfSocialNetworkForPost : (Post*) currentPost {
    switch (currentPost.networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_FBIconImage];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKIconImage];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterIconImage];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}

#pragma mark initiation PostDescriptionTextView

- (void) initiationBackgroundImageView {
    self.backGroundImageView.backgroundColor = YELLOW_COLOR_MidLight;
    [self.backGroundImageView cornerRadius: 30.0 andBorderWidth: 2.0 withBorderColor: YELLOW_COLOR_UpperMid];
}

@end
