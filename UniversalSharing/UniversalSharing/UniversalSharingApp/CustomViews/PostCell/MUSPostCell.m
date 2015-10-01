

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
#import "MUSReasonCommentsAndLikesCell.h"
#import "MUSGalleryViewOfPhotos.h"

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


@interface MUSPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *firstImageOfPostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageOfPostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageOfPostImageView;

@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* postDescriptionLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet UILabel *updatingPostLabel;

@property (strong, nonatomic) NSArray *arrayOfImageView;

@property (weak, nonatomic) IBOutlet UIView *backgroundViewOfCell;
@property (weak, nonatomic) IBOutlet UITableView *commentsAndLikesPostTableView;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;


@end

@implementation MUSPostCell

- (void)awakeFromNib {
    self.arrayOfImageView = [[NSArray alloc] initWithObjects: self.firstImageOfPostImageView, self.secondImageOfPostImageView, self.thirdImageOfPostImageView, nil];
    for (int i = 0; i < self.arrayOfImageView.count  ; i++) {
        UIImageView *currentImageView = [self.arrayOfImageView objectAtIndex: i];
        currentImageView.backgroundColor = [UIColor lightGrayColor];
        [currentImageView cornerRadius: 0.0 andBorderWidth: 1.0 withBorderColor: [UIColor whiteColor]];
    }

    
//    self.backgroundViewOfCell.backgroundColor = BROWN_COLOR_Lightly;
////    
////        CGRect rect = CGRectMake(0, 0, self.backgroundViewOfCell.frame.size.width, musAppPostsVC_HeightOfPostCell + [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell] * self.currentPost.arrayWithNetworkPosts.count);
////    
////        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5, 5)];
////    
////        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
////        maskLayer.frame = rect;
////        maskLayer.path  = maskPath.CGPath;
////        self.backgroundViewOfCell.layer.mask = maskLayer;
////    
////        CAShapeLayer *shape = [CAShapeLayer layer];
////        shape.frame = rect;
////        shape.path = maskPath.CGPath;
////        shape.lineWidth = 3.0f;
////        shape.strokeColor = BROWN_COLOR_MIDLight.CGColor;
////        shape.fillColor = [UIColor clearColor].CGColor;
////        [self.backgroundViewOfCell.layer addSublayer:shape];


    
    
    
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

+ (CGFloat) heightForPostCell : (Post*) post {
    return musAppPostsVC_HeightOfPostCell + [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell] * post.arrayWithNetworkPosts.count;
}

//- (void) configurationUpdatingPostCell: (Post*) currentPost {
//    NSLog(@"COUNT = %@", currentPost.arrayWithNetworkPosts);
//    
//    
//    [self configurateBordersOfCell: currentPost];
//    [self configuratePostDescriptionLabelForPost: currentPost];
//    self.updatingPostLabel.hidden = NO;
//}

- (void) configurationPostCell: (Post*) currentPost {
    [self hideAllImageView];
    [self.commentsAndLikesPostTableView reloadData];
    [self configurateBordersOfCell: currentPost];
    //self.updatingPostLabel.hidden = YES;
    [self configuratePostDescriptionLabelForPost: currentPost];
    [self configurateFirstImageOfPost: currentPost];
}

- (void) configuratePostDescriptionLabelForPost: (Post*) post {
    self.postDescriptionLabel.text = post.postDescription;
    [self.postDescriptionLabel sizeToFit];
}

- (void) configuratePostDescriptionLabelForPostWithoutText {
    self.postDescriptionLabel.hidden = YES;
}

- (void) configurateFirstImageOfPost : (Post*) currentPost {
    if (![[currentPost.arrayImagesUrl firstObject] isEqualToString: @""] || ![currentPost.arrayImagesUrl firstObject]) {
        //[self showAllImageView];
        self.postDescriptionLabelLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
        [self loadImageFromPostToImageView: currentPost];
        //[self loadImagesFromDataBaseToImageView: currentPost.arrayImagesUrl];
    } else {
        [self hideAllImageView];
        self.postDescriptionLabelLeftConstraint.constant = musApp_PostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
    }
}

- (void) configurateFirstImageOfPostWithoutText : (Post*) currentPost {
//    self.galleryViewOfPhotos.isEditableGallery = NO;
//    self.galleryViewOfPhotos.hidden = NO;
//    [self.galleryViewOfPhotos initiationGalleryViewOfPhotos];
//    self.galleryViewOfPhotos.arrayOfPhotos = [NSMutableArray arrayWithArray : arrayWithImages];
//    [self.galleryViewOfPhotos isVisiblePageControl : YES];
//    [self.galleryViewOfPhotos.collectionView reloadData];
//}
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
        imageView.hidden = NO;
        [imageView loadImageFromDataBase: [arrayImagesUrl objectAtIndex: i]];
    }
}

- (void) loadImageFromPostToImageView : (Post*) post  {
    for (int i = 0; i < MIN(post.arrayImagesUrl.count, self.arrayOfImageView.count); i++) {
        UIImageView *imageView = [self.arrayOfImageView objectAtIndex: i];
        ImageToPost *imageToPost = [post.arrayImages objectAtIndex: i];
        imageView.image = imageToPost.image;
        imageView.hidden = NO;
        //[imageView loadImageFromDataBase: [po.arrayImagesUrl objectAtIndex: i]];
    }
}


- (void) configurateBordersOfCell : (Post*) post {
    
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
    }
    
    self.backgroundViewOfCell.backgroundColor = BROWN_COLOR_Lightly;
    
    CGRect rect = CGRectMake(0, 0, self.backgroundViewOfCell.frame.size.width, musAppPostsVC_HeightOfPostCell + [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell] * post.arrayWithNetworkPosts.count);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(0, 0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path  = maskPath.CGPath;
    self.backgroundViewOfCell.layer.mask = maskLayer;
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.frame = rect;
    self.shapeLayer.path = maskPath.CGPath;
    self.shapeLayer.lineWidth = 3.0f;
    self.shapeLayer.strokeColor = BROWN_COLOR_Light.CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.backgroundViewOfCell.layer addSublayer: self.shapeLayer];

}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return self.arrayWithNetworkPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSReasonCommentsAndLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSReasonCommentsAndLikesCell cellID]];
    if(!cell) {
        cell = [MUSReasonCommentsAndLikesCell reasonCommentsAndLikesCell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSReasonCommentsAndLikesCell *reasonCommentsAndLikesCell = (MUSReasonCommentsAndLikesCell*) cell;
//    if ([self.currentPost.arrayWithNetworkPosts objectAtIndex: indexPath.row] == [self.currentPost.arrayWithNetworkPosts lastObject]) {
//        reasonCommentsAndLikesCell.separatorView.hidden = YES;
//    }
    [reasonCommentsAndLikesCell configurationReasonCommentsAndLikesCell: [self.arrayWithNetworkPosts objectAtIndex: indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell];
}


@end
