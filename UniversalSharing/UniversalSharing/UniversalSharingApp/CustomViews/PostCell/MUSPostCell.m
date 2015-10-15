

//
//  MUSPostCell.m
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostCell.h"
#import "ConstantsApp.h"
#import "MUSImageToPost.h"
#import "UIImageView+RoundImage.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"
#import "UIImage+LoadImageFromDataBase.h"
#import <QuartzCore/QuartzCore.h>
#import "MUSReasonCommentsAndLikesCell.h"

@interface MUSPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *firstImageOfPostImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageOfPostImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageOfPostImageView;

@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* postDescriptionLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet UITableView *commentsAndLikesPostTableView;

@property (strong, nonatomic) NSArray *arrayOfImageView;

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
    //self.backgroundView.alpha = 0;
    self.backgroundColor = [UIColor clearColor];

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

+ (CGFloat) heightForPostCell : (MUSPost*) post {
    return MUSApp_MUSPostCell_HeightOfCell + [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell] * post.networkPostsArray.count;
}

- (void) configurationPostCell: (MUSPost*) currentPost {
    [self hideAllImageView];
    [self.commentsAndLikesPostTableView reloadData];
    [self configurateBordersOfCell: currentPost];
    //self.updatingPostLabel.hidden = YES;
    [self configuratePostDescriptionLabelForPost: currentPost];
    [self configurateFirstImageOfPost: currentPost];
    self.commentsAndLikesPostTableView.backgroundColor = BROWN_COLOR_WITH_ALPHA_025;
}

- (void) configuratePostDescriptionLabelForPost: (MUSPost*) post {
    //self.postDescriptionLabel.backgroundColor = BROWN_COLOR_Lightly;
    if (!post.postDescription.length) {
        self.postDescriptionLabel.text = @"No text...";
        self.postDescriptionLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.postDescriptionLabel.text = post.postDescription;
        self.postDescriptionLabel.textColor = [UIColor blackColor];
    }
}

- (void) configurateFirstImageOfPost : (MUSPost*) currentPost {
    if (![[currentPost.imageUrlsArray firstObject] isEqualToString: @""] || ![currentPost.imageUrlsArray firstObject]) {
        //[self showAllImageView];
        self.postDescriptionLabelLeftConstraint.constant = MUSApp_MUSPostCell_PostDescriptionLabel_LeftConstraint_WithUserPhotos;
        [self loadImageFromPostToImageView: currentPost];
    } else {
        [self hideAllImageView];
        self.postDescriptionLabelLeftConstraint.constant = MUSApp_MUSPostCell_PostDescriptionLabel_LeftConstraint_WithoutUserPhotos;
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

- (void) loadImageFromPostToImageView : (MUSPost*) post  {
    for (int i = 0; i < MIN(post.imagesArray.count, self.arrayOfImageView.count); i++) {
        UIImageView *imageView = [self.arrayOfImageView objectAtIndex: i];
        MUSImageToPost *imageToPost = [post.imagesArray objectAtIndex: i];
        imageView.image = imageToPost.image;
        imageView.hidden = NO;
        //[imageView loadImageFromDataBase: [po.arrayImagesUrl objectAtIndex: i]];
    }
}


- (void) configurateBordersOfCell : (MUSPost*) post {
    
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
    }
    
    self.backgroundViewOfCell.backgroundColor = BROWN_COLOR_WITH_ALPHA_01;
    
    CGRect rect = CGRectMake(0, 0, self.backgroundViewOfCell.frame.size.width, MUSApp_MUSPostCell_HeightOfCell + [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell] * post.networkPostsArray.count);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(0, 0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path  = maskPath.CGPath;
    self.backgroundViewOfCell.layer.mask = maskLayer;
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.frame = rect;
    self.shapeLayer.path = maskPath.CGPath;
    self.shapeLayer.lineWidth = 3.0f;
    self.shapeLayer.strokeColor = BROWN_COLOR_WITH_ALPHA_025.CGColor;
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
    [reasonCommentsAndLikesCell configurationReasonCommentsAndLikesCell: [self.arrayWithNetworkPosts objectAtIndex: indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell];
}


@end
