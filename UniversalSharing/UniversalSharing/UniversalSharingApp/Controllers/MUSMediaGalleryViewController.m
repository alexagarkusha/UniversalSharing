//
//  MUSDitailPostCollectionViewController.m
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSMediaGalleryViewController.h"
#import "MUSCollectionViewCellForDetailView.h"
#import "MUSTopBarForDetailCollectionView.h"
#import "MUSToolBarForDetailCollectionView.h"
#import "UIImage+LoadImageFromDataBase.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "ConstantsApp.h"
#import "MUSUserDetailViewController.h"

#warning "method order"

@interface MUSMediaGalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (assign, nonatomic) NSInteger selectedImageIndex;
@property (assign, nonatomic) NSInteger deletedImageIndex;
@property (strong, nonatomic) Post *currentPost;
@property (assign, nonatomic) ReasonType currentReasonType;
@property (assign, nonatomic, getter=isVisibleBars) BOOL visibleBars;
//===
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MUSTopBarForDetailCollectionView *topBar;
@property (weak, nonatomic) IBOutlet MUSToolBarForDetailCollectionView *toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;
@end

@implementation MUSMediaGalleryViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    _visibleBars = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCollectionView:)];
    [self.collectionView addGestureRecognizer:tap];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [_topBar.buttonBack addTarget:self
                           action:@selector(backButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long) _selectedImageIndex + 1, (unsigned long)[self.imagesArray count]]];
    
    [_toolBar.buttonToolBar addTarget:self
                               action:@selector(trashButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    if (!self.isEditableCollectionView) {
        _toolBar.hidden = YES;
    }else {
        
        _toolBar.hidden = NO;
    }
    
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
    if (!_visibleBars) {
        _topBarHeightConstraint.constant -= _topBar.frame.size.height;
        _toolBarHeightConstraint.constant -= _toolBar.frame.size.height;
        [UIView animateWithDuration: 0.4  animations:^{
#warning "order??"
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        }];
        [UIView commitAnimations];
    } else  {
        _topBarHeightConstraint.constant += _topBar.frame.size.height;
        _toolBarHeightConstraint.constant += _toolBar.frame.size.height;
        [UIView animateWithDuration: 0.4  animations:^{
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        }];
        [UIView commitAnimations];
    }
    _visibleBars = (_visibleBars)? NO : YES;
}

- (void) backButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationUpdateCollection object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) trashButton:(id)sender {
    NSIndexPath *visibleIndexPath = [self obtainCurrentIndexPath];
    if (_imagesArray.count && _currentReasonType != MUSConnect) {
        [_imagesArray removeObjectAtIndex: visibleIndexPath.row];
        [self.collectionView reloadData];
        
        if (_imagesArray.count && visibleIndexPath.row != 0 && visibleIndexPath.row < _imagesArray.count ) {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1, (unsigned long)[self.imagesArray count]]];
        } else if (_imagesArray.count && visibleIndexPath.row != 0) {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row, (unsigned long)[self.imagesArray count]]];
        } else if (_imagesArray.count && visibleIndexPath.row == 0) {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1,(unsigned long)[self.imagesArray count]]];
        } else {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long) 0, (unsigned long)[self.imagesArray count]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationUpdateCollection object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }        
    }
}

//it would be changed
- (void) setObjectsWithPost :(Post*) currentPost withCurrentSocialNetwork :(id)currentSocialNetwork andIndexPicTapped :(NSInteger) indexPicTapped {
    self.imagesArray = currentPost.arrayImages;
    self.selectedImageIndex = indexPicTapped;
    self.currentSocialNetwork = currentSocialNetwork;
    self.currentReasonType = currentPost.reason;
}

//it would be changed
- (void) setObjectsWithArrayOfPhotos :(NSMutableArray*) arrayOfPhotos withCurrentSocialNetwork :(SocialNetwork*) currentSocialNetwork indexPicTapped :(NSInteger) indexPicTapped andReasonTypeOfPost : (ReasonType) reasonType {
    self.imagesArray = arrayOfPhotos;
    self.selectedImageIndex = indexPicTapped;
    self.currentSocialNetwork = currentSocialNetwork;
    self.currentReasonType = reasonType;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
    [self.collectionView setContentOffset:CGPointMake((boundsSize.width *(float)_selectedImageIndex), 0)];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:
(NSIndexPath *)indexPath {
    MUSCollectionViewCellForDetailView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCell" forIndexPath:indexPath];
    ImageToPost *imageToPost = [self.imagesArray objectAtIndex: indexPath.row];
    [cell.scrollView displayImage: imageToPost.image];
    return cell;
}

- (NSIndexPath*) obtainCurrentIndexPath {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    return  [self.collectionView indexPathForItemAtPoint:visiblePoint];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *visibleIndexPath = [self obtainCurrentIndexPath];
    [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1, (unsigned long)[self.imagesArray count]]];
    _deletedImageIndex = visibleIndexPath.row;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
