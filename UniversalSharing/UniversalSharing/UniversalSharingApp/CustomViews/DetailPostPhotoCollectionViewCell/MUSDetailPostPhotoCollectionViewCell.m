//
//  MUSDetailPostPhotoCollectionViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 24.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostPhotoCollectionViewCell.h"

@interface MUSDetailPostPhotoCollectionViewCell  () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScroll;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end


@implementation MUSDetailPostPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (NSString *)reuseIdentifier{
    return [MUSDetailPostPhotoCollectionViewCell detailPostPhotoCellID];
}

+ (NSString*) detailPostPhotoCellID {
    return NSStringFromClass([MUSDetailPostPhotoCollectionViewCell class]);
}

+ (instancetype) detailPostPhotoCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self detailPostPhotoCell] owner:nil options:nil];
    return nibArray[0];
}

- (void) configurationCellWithPhoto:(UIImage *)image {
    self.photoScroll.zoomScale = 1.0f;
    self.photoImage.image= image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.photoImage;
}


@end
