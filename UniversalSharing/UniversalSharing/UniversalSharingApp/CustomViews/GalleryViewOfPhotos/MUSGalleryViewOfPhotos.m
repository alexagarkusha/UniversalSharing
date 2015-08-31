//
//  MUSGalleryViewOfPhotos.m
//  UniversalSharing
//
//  Created by U 2 on 19.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSGalleryViewOfPhotos.h"
#import "MUSDetailPostCollectionViewCell.h"
#import "ConstantsApp.h"


@interface MUSGalleryViewOfPhotos () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic)  NSUInteger indexForDeletePicture;
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
    NSString *cellIdentifier = [MUSDetailPostCollectionViewCell customCellID];
    [self.collectionView registerNib:[UINib nibWithNibName: cellIdentifier bundle: nil] forCellWithReuseIdentifier: cellIdentifier];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.arrayOfPhotos = [[NSMutableArray alloc] init];
    self.photoPageControl.hidden = YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.photoPageControl.numberOfPages = self.arrayOfPhotos.count;
    
    NSLog(@"VIEW x =%f, y=%f, w=%f, h=%f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

    //NSLog(@"view.width = %f", self.view.frame.size.width);
    return self.arrayOfPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSDetailPostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: [MUSDetailPostCollectionViewCell customCellID] forIndexPath : indexPath];
    [cell configurationCellWithPhoto: [self.arrayOfPhotos objectAtIndex: indexPath.row]];
    return  cell;
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake ([UIScreen mainScreen].bounds.size.width, self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEditableGallery) {
        self.indexForDeletePicture = indexPath.row;
        [self photoAlertDeletePicShow];
    }
}

- (void) scrollCollectionViewToLastPhoto {
    NSInteger section = [self.collectionView numberOfSections] - 1 ;
    NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1 ;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section] ;
    [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
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


@end
