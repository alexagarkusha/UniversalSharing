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
#import "UIImage+LoadImageFromDataBase.h"
#import "UIImage+IconOfSocialNetwork.h"
#import "NSString+ReasonTypeInString.h"
#import <QuartzCore/QuartzCore.h>

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


@interface MUSPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *firstImageOfPostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageOfPostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageOfPostImageView;

//@property (weak, nonatomic) IBOutlet UILabel *numberOfImagesInPostLabel;

@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *customBackgroundView;

//@property (weak, nonatomic) IBOutlet UIImageView *iconOfSocialNetworkImageView;
//
//@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;
//
//@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* postDescriptionLabelLeftConstraint;

//@property (weak, nonatomic) IBOutlet UIView *checkMarkView;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCheckMarkViewConstraint;

//@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;

@property (weak, nonatomic) IBOutlet UILabel *updatingPostLabel;

@property (strong, nonatomic) NSArray *arrayOfImageView;

@end

@implementation MUSPostCell

- (void)awakeFromNib {
    self.arrayOfImageView = [[NSArray alloc] initWithObjects: self.firstImageOfPostImageView, self.secondImageOfPostImageView, self.thirdImageOfPostImageView, nil];
    for (int i = 0; i < self.arrayOfImageView.count  ; i++) {
        UIImageView *currentImageView = [self.arrayOfImageView objectAtIndex: i];
        currentImageView.backgroundColor = [UIColor lightGrayColor];
        [currentImageView cornerRadius: 0.0 andBorderWidth: 1.0 withBorderColor: [UIColor whiteColor]];
    }
    
    [self.postDescriptionLabel sizeToFit];
    
    //self.customBackgroundView.backgroundColor = [UIColor blueColor];
    self.layer.masksToBounds = YES;
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height - 1);

    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint: CGPointMake(0, rect.size.height - 23)];
//    [path addLineToPoint: CGPointMake(0, 0)];
//    [path addLineToPoint: CGPointMake(rect.size.width, 0)];
//    [path addLineToPoint: CGPointMake(rect.size.width, rect.size.height - 23)];
//    [path addArcWithCenter: CGPointMake(rect.size.width - 60, 20)
//                    radius: 90
//                startAngle: DEGREES_TO_RADIANS(40)
//                  endAngle: DEGREES_TO_RADIANS(90)
//                 clockwise: YES];
//    [path addLineToPoint: CGPointMake(60, rect.size.height)];
//    [path addArcWithCenter: CGPointMake(60, 20)
//                    radius: 89
//                startAngle: DEGREES_TO_RADIANS(90)
//                  endAngle: DEGREES_TO_RADIANS(140)
//                 clockwise: YES];
//    [path closePath];
    
    
    //CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height - 1);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(20, 10)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path  = maskPath.CGPath;
    maskLayer.shadowOffset = CGSizeMake(0, 4);
    maskLayer.shadowRadius = 5.0;
    maskLayer.shadowColor = [UIColor blackColor].CGColor;
    maskLayer.shadowOpacity = 1.0;
    self.layer.mask = maskLayer;

    
//    CAShapeLayer *shadowLayer = [[CAShapeLayer alloc] init];
////    maskLayer.frame = rect;
////    maskLayer.path  = maskPath.CGPath;
//    shadowLayer.shadowOffset = CGSizeMake(0, 5);
//    shadowLayer.shadowRadius = 5.0;
//    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
//    shadowLayer.shadowOpacity = 1.0;
//    [self.layer addSublayer: shadowLayer];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = rect;
    shape.path = maskPath.CGPath;
    shape.lineWidth = 1.0f;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shape];

//    self.backgroundColor = [UIColor whiteColor];
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
    return musAppPostsVC_HeightOfPostCell;
}

- (void) configurationUpdatingPostCell: (Post*) currentPost {
   // [self configurateCommentsImageAndLabel: currentPost];
   // [self configurateLikesImageAndLabel: currentPost];
    [self configuratePostDescriptionLabelForPost: currentPost];
  //  [self configurateIconOfSocialNetworkImageViewForPost: currentPost];
    self.updatingPostLabel.hidden = NO;
}


- (void) configurationPostCell: (Post*) currentPost {
    self.updatingPostLabel.hidden = YES;
//    [self configurateCommentsImageAndLabel: currentPost];
//    [self configurateLikesImageAndLabel: currentPost];
//    [self configurateReasonOfPostLabel: currentPost];
    [self configuratePostDescriptionLabelForPost: currentPost];
//    [self configurateIconOfSocialNetworkImageViewForPost: currentPost];
    [self configurateFirstImageOfPost: currentPost];
}
/*
- (void) configurateCommentsImageAndLabel : (Post*) post {
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_Comment];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat: @"%ld", (long) post.commentsCount];
}

- (void) configurateLikesImageAndLabel : (Post*) post {
    self.likeImageView.image = [UIImage imageNamed: musAppImage_Name_Like];
    self.numberOfLikesLabel.text = [NSString stringWithFormat: @"%ld", (long)post.likesCount];
}

- (void) configurateReasonOfPostLabel : (Post*) post {
    self.reasonOfPostLabel.backgroundColor = [UIColor reasonColorForPost: post.reason];
    self.reasonOfPostLabel.text = [NSString reasonTypeInString: post.reason];
}
*/
- (void) configuratePostDescriptionLabelForPost: (Post*) post {
    self.postDescriptionLabel.text = post.postDescription;
}
/*
- (void) configurateIconOfSocialNetworkImageViewForPost: (Post*) post {
    self.iconOfSocialNetworkImageView.image = [UIImage iconOfSocialNetworkForPost: post];
}
*/
- (void) configurateFirstImageOfPost : (Post*) currentPost {
    if (![[currentPost.arrayImagesUrl firstObject] isEqualToString: @""] || ![currentPost.arrayImagesUrl firstObject]) {
        [self showAllImageView];
        self.postDescriptionLabelLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
        [self loadImagesFromDataBaseToImageView: currentPost.arrayImagesUrl];
    } else {
        [self hideAllImageView];
        self.postDescriptionLabelLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
    }
}


- (void) hideAllImageView {
    self.firstImageOfPostImageView.hidden = YES;
    self.secondImageOfPostImageView.hidden = YES;
    self.thirdImageOfPostImageView.hidden = YES;
}

- (void) showAllImageView {
    self.firstImageOfPostImageView.hidden = NO;
    self.secondImageOfPostImageView.hidden = NO;
    self.thirdImageOfPostImageView.hidden = NO;
}

- (void) loadImagesFromDataBaseToImageView : (NSArray*) arrayImagesUrl  {
    for (int i = 0; i < MIN(arrayImagesUrl.count, self.arrayOfImageView.count); i++) {
        UIImageView *imageView = [self.arrayOfImageView objectAtIndex: i];
        [imageView loadImageFromDataBase: [arrayImagesUrl objectAtIndex: i]];
    }
    
//    
//    
//    for (int i = 0; i < self.arrayOfImageView.count; i++) {
//        UIImageView *imageView = [self.arrayOfImageView objectAtIndex: i];
//        UIImage *image = [[UIImage alloc] init];
//        
//        [image loadImageFromDataBase: [arrayImagesUrl objectAtIndex: i]];
//        if (image) {
//            imageView.image = image;
//        } else {
//            imageView.backgroundColor = [UIColor lightGrayColor];
//        }
//    }
}


//    self.numberOfImagesInPostLabel.hidden = YES;
//    self.backgroundColor = [UIColor whiteColor];
//    [self.iconOfSocialNetworkImageView roundImageView];
//    [self.reasonOfPostLabel cornerRadius: CGRectGetHeight(self.reasonOfPostLabel.frame) / 2];
//    [self.numberOfImagesInPostLabel cornerRadius: CGRectGetHeight(self.numberOfImagesInPostLabel.frame) / 2];
//    [self.numberOfCommentsLabel sizeToFit];
//    [self.numberOfLikesLabel sizeToFit];
//    self.updatingPostLabel.hidden = YES;


//    [self configurateEditableCell: flagEdit andIsCellDelete: flagForDelete];
//- (void) configurateEditableCell : (BOOL) isCellEditable andIsCellDelete : (BOOL) isCellDelete {
//    if (isCellEditable) {
//        //self.widthConstrain.constant = 50.0f;
//        [self changeButtonCheckMarkConstraintWithAnimation: 50.0f];
//        self.checkMarkButton.hidden = NO;
//        if (isCellDelete) {
//            [self.checkMarkButton setSelected: YES];
//        }else {
//            [self.checkMarkButton setSelected: NO];
//        }
//    } else{
//        //self.widthConstrain.constant = 0.0f;
//        [self changeButtonCheckMarkConstraintWithAnimation: 0.0f];
//        self.checkMarkButton.hidden = YES;
//        [self.checkMarkButton setSelected: NO];
//    }
//}
//
//- (void) changeButtonCheckMarkConstraintWithAnimation : (CGFloat) newLeftConstraint {
//    self.widthCheckMarkViewConstraint.constant = newLeftConstraint;
//    [UIView animateWithDuration: 0.4  animations:^{
//        [self layoutIfNeeded];
//        [self setNeedsLayout];
//    }];
//    [UIView commitAnimations];
//}
//- (void) initiationCheckMarkButton {
//    [self.checkMarkButton setBackgroundImage:[UIImage imageNamed: musApp_PostCell_Image_Name_CheckMarkTaken] forState:UIControlStateSelected];
//    [self.checkMarkButton setBackgroundImage:[UIImage imageNamed: musApp_PostCell_Image_Name_CheckMark] forState:UIControlStateNormal];
//    self.checkMarkButton.hidden = YES;
//}
//
//- (void) checkIsSelectedPost {
//    if ([self.checkMarkButton isSelected]) {
//        [self.checkMarkButton setSelected:NO];
//    } else {
//        [self.checkMarkButton setSelected:YES];
//    }
//}
//
//- (IBAction)buttonCheckMarkTapped:(id)sender {
//    [self.delegate addIndexToIndexSetWithCell:self];
//    [self checkIsSelectedPost];
//}
//




@end
