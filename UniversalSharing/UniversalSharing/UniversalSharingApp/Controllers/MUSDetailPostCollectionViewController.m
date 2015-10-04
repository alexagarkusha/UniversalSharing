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
#import "MUSToolBarForDetailCollectionView.h"
#import "UIImage+LoadImageFromDataBase.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "ConstantsApp.h"
#import "MUSUserDetailViewController.h"

#warning "method order"

@interface MUSDetailPostCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfPics;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (assign, nonatomic) NSInteger indexPicTapped;
@property (assign, nonatomic) BOOL hideBars;
@property (assign, nonatomic) NSInteger indexDeletedPic;
@property (strong, nonatomic) Post *currentPost;

///////////////////////////
@property (strong, nonatomic) NSMutableArray *tmp;
///////////////////////

//===
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MUSTopBarForDetailCollectionView *topBar;
@property (weak, nonatomic) IBOutlet MUSToolBarForDetailCollectionView *toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarConstraint;
@end

@implementation MUSDetailPostCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _hideBars = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCollectionView:)];
    [self.collectionView addGestureRecognizer:tap];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_topBar.buttonBack addTarget:self
                           action:@selector(backButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [_topBar.showUserProfileButton addTarget:self
                           action:@selector(showUserProfile)
                 forControlEvents:UIControlEventTouchUpInside];
    [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long) _indexPicTapped + 1, (unsigned long)[self.arrayOfPics count]]];
    [_topBar initializeImageView:_currentSocialNetwork.icon];
    
    [_toolBar.buttonToolBar addTarget:self
                               action:@selector(trashButton:)
                     forControlEvents:UIControlEventTouchUpInside];
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
    if (!_hideBars) {
        _topBarConstraint.constant -= _topBar.frame.size.height;
        _toolBarConstraint.constant -= _toolBar.frame.size.height;
        [UIView animateWithDuration: 0.4  animations:^{
#warning "order??"
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        }];
        [UIView commitAnimations];
    } else  {
        _topBarConstraint.constant += _topBar.frame.size.height;
        _toolBarConstraint.constant += _toolBar.frame.size.height;
        [UIView animateWithDuration: 0.4  animations:^{
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        }];
        [UIView commitAnimations];
    }
    _hideBars = (_hideBars)? NO : YES;
}

- (void) backButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationUpdateCollection object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showUserProfile {
    [self performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString : goToUserDetailViewControllerSegueIdentifier]) {
        MUSUserDetailViewController *userDetailViewController = [MUSUserDetailViewController new];
        userDetailViewController = [segue destinationViewController];
        userDetailViewController.isLogoutButtonHide = YES;
        [userDetailViewController setNetwork: self.currentSocialNetwork];
    }
}

- (void) trashButton:(id)sender {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    
    if (_arrayOfPics.count && _currentPost && _currentPost.reason != Connect ) {
        [_arrayOfPics removeObjectAtIndex:visibleIndexPath.row];
        if ([[_currentPost.arrayImages firstObject] isKindOfClass:[ImageToPost class]]) {
            [self.currentPost.arrayImages removeObjectAtIndex:visibleIndexPath.row];
        }
        if (_tmp.count) {
            [_tmp removeObjectAtIndex:visibleIndexPath.row];
        }
        
        if (_arrayOfPics.count && visibleIndexPath.row != 0) {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row , (unsigned long)[self.arrayOfPics count]]];
        } else if (_arrayOfPics.count && visibleIndexPath.row == 0) {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long)visibleIndexPath.row + 1,(unsigned long)[self.arrayOfPics count]]];
        } else {
            [_topBar initializeLableCountImages: [NSString stringWithFormat:@"%ld from %lu",(long) 0, (unsigned long)[self.arrayOfPics count]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationUpdateCollection object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [_collectionView reloadData];
    }
}

- (void) setObjectsWithPost :(Post*) currentPost andCurrentSocialNetwork :(id)currentSocialNetwork andIndexPicTapped :(NSInteger) indexPicTapped {
    if (!self.arrayOfPics) {
        self.arrayOfPics = [NSMutableArray new];
    }
    self.indexPicTapped = indexPicTapped;
    self.currentPost = currentPost;
    self.currentSocialNetwork = currentSocialNetwork;
    _tmp = [NSMutableArray arrayWithArray:self.currentPost.arrayImagesUrl];
    if (currentPost.arrayImages) {
        
        
        if ([[currentPost.arrayImages firstObject] isKindOfClass:[ImageToPost class]]) {
            [currentPost.arrayImages enumerateObjectsUsingBlock:^(ImageToPost* image, NSUInteger idx, BOOL *stop) {
                [self.arrayOfPics addObject:image.image];
            }];
            
        }else {
            self.arrayOfPics = currentPost.arrayImages;
        }
    }
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
    _indexDeletedPic = visibleIndexPath.row;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
}

@end
