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
    self.numberOfImagesInPost.hidden = YES;
    [self.iconOfSocialNetwork roundImageView];
    [self.reasonOfPost cornerRadius: CGRectGetHeight(self.reasonOfPost.frame) / 2];
    [self.numberOfImagesInPost cornerRadius: CGRectGetHeight(self.numberOfImagesInPost.frame) / 2];
    [self.numberOfComments sizeToFit];
    [self.numberOfLikes sizeToFit];
    
    self.backGroundImageView.layer.masksToBounds = YES;
    self.backGroundImageView.layer.cornerRadius = 30;
    //self.backGroundImageView.clipsToBounds = YES;
    self.backGroundImageView.layer.borderWidth = 2.0;
    self.backGroundImageView.layer.borderColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 100.0/255.0 alpha: 1.0].CGColor;

    // Initialization code
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
#warning КОСТЫЛЬ - т.к. - если нет рисунков приходит массив с одним объектом типа ""
    self.firstImageOfPost.image = nil;
    if (![[currentPost.arrayImagesUrl firstObject] isEqualToString: @""]) {
        if (currentPost.arrayImagesUrl.count == 1) {
            self.numberOfImagesInPost.hidden = YES;
            [self.firstImageOfPost loadImageFromDataBase: [currentPost.arrayImagesUrl firstObject]];
        } else {
            [self.firstImageOfPost loadImageFromDataBase: [currentPost.arrayImagesUrl firstObject]];
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
    /*
    if (!currentPost.arrayImages) {
        self.firstImageOfPost.hidden = YES;
        self.postDescriptionLeftConstraint.constant = 8;
    } else if (currentPost.arrayImages.count == 1) {
        ImageToPost *imageToPost = [currentPost.arrayImages firstObject];
        self.firstImageOfPost.image = imageToPost.image;
    } else {
        ImageToPost *imageToPost = [currentPost.arrayImages firstObject];
        self.firstImageOfPost.image = imageToPost.image;
        self.numberOfImagesInPost.hidden = NO;
        self.numberOfImagesInPost.text = [NSString stringWithFormat: @"%d", currentPost.arrayImages.count];
    }
    */
    self.postDescription.text = currentPost.postDescription;
    self.iconOfSocialNetwork.image = [self iconOfSocialNetworkForPost : currentPost];
    self.commentImage.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.numberOfComments.text = [NSString stringWithFormat: @"%ld", (long)currentPost.commentsCount];
    self.likeImage.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.numberOfLikes.text = [NSString stringWithFormat: @"%ld", (long)currentPost.likesCount];
    self.reasonOfPost.backgroundColor = [self reasonColorForPost : currentPost];
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

- (UIColor*) reasonColorForPost : (Post*) currentPost {
    switch (currentPost.reason) {
        case Connect:
            return [UIColor greenColor];
            break;
        case ErrorConnection:
            return [UIColor orangeColor];
            break;
        case Offline:
            return [UIColor redColor];
            break;
        default:
            break;
    }
    return nil;
}


@end
