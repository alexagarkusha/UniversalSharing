//
//  MUSGalleryOfPhotosCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSGalleryOfPhotosCell.h"
#import "MUSCollectionViewCell.h"
#import "ConstantsApp.h"
#import "UIImageView+LoadImageFromNetwork.h"

@interface MUSGalleryOfPhotosCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfPostLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *photoPageControl;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;


@end


@implementation MUSGalleryOfPhotosCell

- (void)awakeFromNib {
    [self.galleryCollectionView registerNib:[UINib nibWithNibName : nibWithNibName bundle:nil] forCellWithReuseIdentifier : collectionViewCellIdentifier];
    [self.galleryCollectionView setPagingEnabled:YES];
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSString *)reuseIdentifier{
    return [MUSGalleryOfPhotosCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) galleryOfPhotosCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void) configurationGalleryOfPhotosCellByPost: (Post*) currentPost andUser : (User*) user {
    CGFloat heightOfRow;
    
    if (currentPost.arrayImages.count > 0) {
        heightOfRow = 150;
    } else {
        heightOfRow = 70;
    }
    
    self.photoPageControl.numberOfPages = self.currentPost.arrayImages.count;
    self.photoPageControl.enabled = NO;
    self.usernameLabel.text = user.username;
    self.dateOfPostLabel.text = [self timeInDoubleFormatte: 1000000]; // deteleThis after connect sqlite - change it to self.post.dateOfPost
    [self.userPhotoImageView loadImageFromUrl: [NSURL URLWithString: user.photoURL]];
    
    [self.usernameLabel sizeToFit];
    [self.dateOfPostLabel sizeToFit];
    [self.delegate heightOfGalleryOfPhotosRow: heightOfRow];
}


- (NSString*) timeInDoubleFormatte: (double) dateInDouble {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInDouble];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateStr = [formatDate stringFromDate:date];
    return dateStr;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentPost.arrayImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath : indexPath];
    ImageToPost *imageToPost = [self.currentPost.arrayImages objectAtIndex : indexPath.row];
    cell.photoImageViewCell.image = imageToPost.image;
    return  cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake (self.galleryCollectionView.frame.size.width, self.galleryCollectionView.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.galleryCollectionView.frame.size.width;
    self.photoPageControl.currentPage = (self.galleryCollectionView.contentOffset.x + pageWidth / 2) / pageWidth;
}


@end
