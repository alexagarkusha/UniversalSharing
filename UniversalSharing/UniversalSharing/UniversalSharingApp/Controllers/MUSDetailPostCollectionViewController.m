//
//  MUSDitailPostCollectionViewController.m
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostCollectionViewController.h"
//#import "UIImageView+RoundImage.h"
//#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "MUSCollectionViewCellForDetailView.h"
#import "MUSTopBarForDetailCollectionView.h"
//#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"

//#import "MUSImageScrollView.h"

@interface MUSDetailPostCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *arrayOfPics;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (assign, nonatomic) NSInteger indexPicTapped;
//==
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MUSTopBarForDetailCollectionView *topBar;

@end

@implementation MUSDetailPostCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    ///////////////////////////////////////////////////////
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCollectionView:)];
    [self.collectionView addGestureRecognizer:tap];
    
    /////////////////////////////////////////////////
    //[self createRoundViewWithImageUser];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    [_topBar.buttonBack addTarget:self
                            action:@selector(backButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long) _indexPicTapped + 1, (unsigned long)[self.arrayOfPics count]]];
    [_topBar initializeImageView:_currentSocialNetwork.icon];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    //[self.collectionView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:NO];

}

-(void) didTapOnCollectionView:(UIGestureRecognizer*) recognizer {
    [_topBar hidePropirtiesWithAnimation];
}

- (void) backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) setObjectsWithArray :(NSArray*) arrayOfPics andCurrentSocialNetwork :(id)currentSocialNetwork andIndexPicTapped:(NSInteger)indexPicTapped {
    self.indexPicTapped = indexPicTapped;
    self.arrayOfPics = arrayOfPics;
    self.currentSocialNetwork = currentSocialNetwork;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
    [self.collectionView setContentOffset:CGPointMake((boundsSize.width *(float)_indexPicTapped), 0)];

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




- (BOOL)prefersStatusBarHidden {
    return YES;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//   // MUSCollectionViewCellForDetailView *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    
//    
////    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
////
//////    _shouldHideStatusBar = (_shouldHideStatusBar)? NO: YES;
//////    [self setNeedsStatusBarAppearanceUpdate];
//////    [self.tabBarController.tabBar setHidden:YES];
//////    [self.navigationController setNavigationBarHidden:YES animated:NO];
//////    UIView *navbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
//////    navbar.backgroundColor = [UIColor blackColor];
////    //do something like background color, title, etc you self
////    //[self.view addSubview:navbar];
////    //[self.tabBarController.tabBarController setHidden:YES];
//////[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
////    //[self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
////    //self.view.backgroundColor = [UIColor blackColor];
//////    UIColor *colour = [[UIColor alloc]initWithRed:57.0/255.0 green:156.0/255.0 blue:52.0/255.0 alpha:1.0];
//////    self.view.backgroundColor = colour;
////    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
////    cell.backgroundColor = [UIColor blackColor];
////    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1, (unsigned long)[self.arrayOfPics count]]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width , self.view.frame.size.height - 100);
}

@end
