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

@interface MUSDetailPostCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *arrayOfPics;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (nonatomic, assign) CGFloat scale;


@end

@implementation MUSDetailPostCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    //////////////////////////////////////////////////
    CGRect rect = CGRectMake(0, 0, 34, 34);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView loadImageFromDataBase: _currentSocialNetwork.icon];
    [imageView roundImageView];
    [view addSubview:imageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    ///////////////////////////////////////////////////////////////////////////
    self.navigationItem.title = [NSString stringWithFormat:@"%ld from %lu",(long) 1, (unsigned long)[self.arrayOfPics count]];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    self.scale = 10.0;
     [self.collectionView setPagingEnabled:YES];
    [self.view layoutIfNeeded];
    
    
//    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
//    [self.collectionView addGestureRecognizer:gesture];
    
}

- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    static CGFloat scaleStart;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        scaleStart = self.scale;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        self.scale = scaleStart * gesture.scale;
        //[self.collectionView.collectionViewLayout invalidateLayout];
//        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
//        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//        NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
//        UICollectionViewCell *currentCell =[self.collectionView cellForItemAtIndexPath:visibleIndexPath];
//        currentCell.backgroundView.frame = CGRectMake(currentCell.backgroundView.frame.origin.x-self.scale,currentCell.backgroundView.frame.origin.y-self.scale, currentCell.backgroundView.frame.size.width+self.scale, currentCell.backgroundView.frame.size.height+self.scale);
    }
}

- (void) setObjectsWithArray :(NSArray*) arrayOfPics andCurrentSocialNetwork :(id)currentSocialNetwork {
    self.arrayOfPics = arrayOfPics;
    self.currentSocialNetwork = currentSocialNetwork;
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
    
    [cell setImageContext:self.arrayOfPics[indexPath.row]];
    [self.collectionView addGestureRecognizer:cell.scrollView.pinchGestureRecognizer];
    [self.collectionView addGestureRecognizer:cell.scrollView.panGestureRecognizer];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(MUSCollectionViewCellForDetailView *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionView removeGestureRecognizer:cell.scrollView.pinchGestureRecognizer];
    [self.collectionView removeGestureRecognizer:cell.scrollView.panGestureRecognizer];
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
