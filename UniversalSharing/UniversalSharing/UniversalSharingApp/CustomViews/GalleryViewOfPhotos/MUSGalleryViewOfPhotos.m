//
//  MUSGalleryViewOfPhotos.m
//  UniversalSharing
//
//  Created by U 2 on 19.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSGalleryViewOfPhotos.h"
#import "ConstantsApp.h"
#import "MUSCollectionViewCell.h"

@interface MUSGalleryViewOfPhotos () <UICollectionViewDataSource, UICollectionViewDelegate, MUSCollectionViewCellDelegate>

@property (assign, nonatomic)  NSInteger indexForDeletePicture;
@property (weak, nonatomic) IBOutlet UIPageControl *photoPageControl;


@end


@implementation MUSGalleryViewOfPhotos

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview : self.view];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview : self.view];
    }
    return self;
}

-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed: @"MUSGalleryViewOfPhotos" owner:self options:nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    NSString *cellIdentifier = [MUSCollectionViewCell customCellID];
    [self.collectionView registerNib:[UINib nibWithNibName: cellIdentifier bundle: nil] forCellWithReuseIdentifier: cellIdentifier];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.arrayOfPhotos = [[NSMutableArray alloc] init];
    self.photoPageControl.hidden = YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfPhotos;
    if (self.isEditableGallery && self.arrayOfPhotos.count < 4) {
        numberOfPhotos = self.arrayOfPhotos.count + 1;
    } else {
        numberOfPhotos = self.arrayOfPhotos.count;
    }
    self.photoPageControl.numberOfPages = numberOfPhotos;
    return numberOfPhotos;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"indexPAth = %d", indexPath.row);
    
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: [MUSCollectionViewCell customCellID] forIndexPath : indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    if (indexPath.row < self.arrayOfPhotos.count) {
        [cell configurationCellWithPhoto: [self.arrayOfPhotos objectAtIndex: indexPath.row] andEditableState: self.isEditableGallery];
        return cell;
    }
    [cell configurationCellWithPhoto: nil andEditableState: self.isEditableGallery];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake ([UIScreen mainScreen].bounds.size.width, self.collectionView.frame.size.height);
}

- (void) scrollCollectionViewToLastPhoto {
    NSInteger section = [self.collectionView numberOfSections] - 1 ;
    NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1 ;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section] ;
    [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *theInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.arrayOfPhotos,@"arrayOfPhotos", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationShowImagesInCollectionView object:nil userInfo:theInfo];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.photoPageControl.currentPage = (self.collectionView.contentOffset.x + pageWidth / 2) / pageWidth;
}


#pragma mark - Edit Gallery

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case YES:
            [self.arrayOfPhotos removeObjectAtIndex:self.indexForDeletePicture];
            [self.delegate arrayOfPhotos: self.arrayOfPhotos];
            [self.collectionView reloadData];
            break;
        default:
            break;
    }
}

- (void) photoAlertDeletePicShow {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle : titleAlertDeletePicShow
                          message : messageAlertDeletePicShow
                          delegate : self
                          cancelButtonTitle : cancelButtonTitleAlertDeletePicShow
                          otherButtonTitles : otherButtonTitlesAlertDeletePicShow, nil];
    [alert show];
}

- (void) isVisiblePageControl : (BOOL) isVisible {
    if (!isVisible) {
        self.photoPageControl.hidden = YES;
    } else {
        self.photoPageControl.hidden = NO;
    }
}


#pragma mark - MUSCollectionViewCellDelegate

- (void) deletePhoto : (NSIndexPath*) currentIndexPath {
    self.indexForDeletePicture = currentIndexPath.row;
    [self photoAlertDeletePicShow];
}

- (void) addPhotoToCollection {
    [self.delegate addPhotoToPost];
}



@end
