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
    return 100;
}

- (void) configurationPostCell: (Post*) currentPost {
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
        self.postDescriptionLeftConstraint.constant = musApp_EightPixels;
    } else {
        self.firstImageOfPost.hidden = NO;
        self.postDescriptionLeftConstraint.constant = self.firstImageOfPost.frame.origin.x + self.firstImageOfPost.frame.size.width + musApp_EightPixels;
    }
  
    self.postDescription.text = currentPost.postDescription;
    self.numberOfComments.text = [NSString stringWithFormat: @"%ld", (long)currentPost.commentsCount];
    self.iconOfSocialNetwork.image = [self iconOfSocialNetworkForPost : currentPost];
    self.numberOfLikes.text = [NSString stringWithFormat: @"%ld", (long)currentPost.likesCount];
    self.commentImage.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.reasonOfPost.backgroundColor = [UIColor reasonColorForPost: currentPost.reason];
    self.likeImage.image = [UIImage imageNamed: musAppImage_Name_Like];
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
    self.backGroundImageView.layer.masksToBounds = YES;
    self.backGroundImageView.layer.cornerRadius = 30;
    self.backGroundImageView.layer.borderWidth = 2.0;
    self.backGroundImageView.layer.borderColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 100.0/255.0 alpha: 1.0].CGColor;
}

@end
