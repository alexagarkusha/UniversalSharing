//
//  MUSDitailPostCollectionViewController.m
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostCollectionViewController.h"
#import "MUSCollectionViewCellForDetailView.h"
#import "MUSTopBarForDetailCollectionView.h"

@interface MUSDetailPostCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *arrayOfPics;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (assign, nonatomic) NSInteger indexPicTapped;
//===
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MUSTopBarForDetailCollectionView *topBar;

@end

@implementation MUSDetailPostCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //_topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //_topBar.alpha= 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCollectionView:)];
    [self.collectionView addGestureRecognizer:tap];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
}

-(void) didTapOnCollectionView:(UIGestureRecognizer*) recognizer {
    [_topBar hidePropertiesWithAnimation];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1, (unsigned long)[self.arrayOfPics count]]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);//(self.view.frame.size.width , self.view.frame.size.height - 100);
}

@end
