//
//  MUSDitailPostCollectionViewController.m
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostCollectionViewController.h"
#import "UIImageView+RoundImage.h"
#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "MUSCollectionViewCellForDetailView.h"

//#import "MUSImageScrollView.h"

@interface MUSDetailPostCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *arrayOfPics;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (nonatomic, assign) CGFloat scale;

@end

@implementation MUSDetailPostCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRoundViewWithImageUser];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void) setObjectsWithArray :(NSArray*) arrayOfPics andCurrentSocialNetwork :(id)currentSocialNetwork {
    self.arrayOfPics = arrayOfPics;
    self.currentSocialNetwork = currentSocialNetwork;
}

- (void) createRoundViewWithImageUser {
    CGRect rect = CGRectMake(0, 0, 34, 34);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView loadImageFromDataBase: _currentSocialNetwork.icon];
    [imageView roundImageView];
    [view addSubview:imageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    ///////////////////////////////////////////////////////////////////////////
    self.navigationItem.title = [NSString stringWithFormat:@"%ld from %lu",(long) 1, (unsigned long)[self.arrayOfPics count]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrayOfPics count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MUSCollectionViewCellForDetailView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCell" forIndexPath:indexPath];
    [cell.scrollView displayImage:self.arrayOfPics[indexPath.row]];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1, (unsigned long)[self.arrayOfPics count]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width , self.view.frame.size.height - 100);
}

@end
