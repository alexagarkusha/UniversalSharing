//
//  MUSGaleryView.m
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSGaleryView.h"
#import "MUSCollectionViewCell.h"
#import "ConstantsApp.h"
#import <LSSwipeToDeleteCollectionViewLayout.h>
#import "LSFadingSwipeToDeleteCollectionViewLayout.h"

static NSString *LSCollectionViewCellIdentifier = @"Cell";

@interface MUSGaleryView()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIAlertViewDelegate, MUSCollectionViewCellDelegate, LSSwipeToDeleteCollectionViewLayoutDelegate>

//===
@property (strong, nonatomic)  UIView *view;
@property (strong, nonatomic)  NSMutableArray *arrayWithChosenImages;
@property (strong, nonatomic)  UISwipeGestureRecognizer *pressGesture;

/*!
 @property
 @abstract index for erasing a chosen picture
 */
@property (assign, nonatomic)  NSIndexPath * indexForDeletePicture;
@property (assign, nonatomic) BOOL flag;
/////////////////////////////////////////////////
@property (assign, nonatomic) BOOL flagForDelete;
@property (assign, nonatomic) NSInteger count;
//////////////////////////////////////////////////
@end

@implementation MUSGaleryView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview:self.view];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview:self.view];
    }
    return self;
}


-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:loadNibNamed owner:self options:nil];
    //[self initiationGestureRecognizer];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionView) name:notificationUpdateCollection object:nil];
    NSString *cellIdentifier = [MUSCollectionViewCell customCellID];
    [self.collectionView registerNib:[UINib nibWithNibName: cellIdentifier bundle: nil] forCellWithReuseIdentifier: cellIdentifier];
    
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LSCollectionViewCellIdentifier];
    /////////////////////////////////////////////////////////////////////// implement flowLayout
    LSFadingSwipeToDeleteCollectionViewLayout *flowLayout = [[LSFadingSwipeToDeleteCollectionViewLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setItemSize:CGSizeMake(self.collectionView.contentSize.height, self.collectionView.contentSize.height)];
    //flowLayout.in
//    [self.collectionView setPagingEnabled:YES];
//    [self.collectionView setScrollEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self becomeFirstResponder];

    ////////////////////////////////////////////////////////////////////////////
    //[self.collectionView setAlwaysBounceVertical:YES];
    LSSwipeToDeleteCollectionViewLayout *layout = (LSSwipeToDeleteCollectionViewLayout *)self.collectionView.collectionViewLayout;
//    LSSwipeToDeleteCollectionViewLayout *l = [LSSwipeToDeleteCollectionViewLayout new];
//    l.deletionVelocityTresholdValue = 0.0f;
//    l.deletionDistanceTresholdValue= 20.0f;
    [layout setSwipeToDeleteDelegate:self];
    _count = 0;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"COUNT ROW = %d", [self.arrayWithChosenImages count]);
    return  [self.arrayWithChosenImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MUSCollectionViewCell customCellID] forIndexPath:indexPath];
    if (_flagForDelete) {
       // _count--;
    }
    if (self.flag && [self.arrayWithChosenImages count] < 3 && _flagForDelete) {
        cell.photoImageViewCell.image  = nil;
        cell.deletePhotoButtonOutlet.hidden = YES;
         _flagForDelete = NO;
        //[cell.deletePhotoButtonOutlet setImage:nil forState:UIControlStateNormal];//setBackgroundColor:[UIColor blackColor]];
        return cell;
    }
        cell.delegate = self;
        cell.indexPath = indexPath;
        //NSLog(@"INDEXPATH %@", indexPath);
    ImageToPost *image;
    if ([self.arrayWithChosenImages count] == indexPath.row) {
        image = self.arrayWithChosenImages[indexPath.row - 1];
        //return cell;
    } else {
        image = self.arrayWithChosenImages[indexPath.row];
    }
        //cell.isEditable = self.isEditableCollectionView;
    [cell configurationCellWithPhoto:image.image andEditableState:YES];
    _flagForDelete = NO;

    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.contentSize.height, self.collectionView.contentSize.height);
}

-(void)swipeToDeleteLayout:(LSSwipeToDeleteCollectionViewLayout *)layout didEndAnimationWithCellAtIndexPath:(NSIndexPath *)indexPath didDeleteCell:(BOOL)didDelete {
    
    
}
//-(BOOL)swipeToDeleteLayout:(LSSwipeToDeleteCollectionViewLayout *)layout canDeleteCellAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return NO;
//}

-(void)swipeToDeleteLayout:(LSSwipeToDeleteCollectionViewLayout *)layout didDeleteCellAtIndexPath:(NSIndexPath *)indexPath {
    _count++;
        [self.arrayWithChosenImages removeObjectAtIndex: indexPath.row];
    NSLog(@"lllll");
    self.flag = YES;
    _flagForDelete = YES;
        if ([self.arrayWithChosenImages count] == 0) {
            //self.collectionView.backgroundColor = [UIColor whiteColor];
            self.arrayWithChosenImages = nil;
            [self.delegate changeSharePhotoButtonColorAndShareButtonState : NO];
            _count = 0;
            return;
        }
    
    //[self.collectionView reloadData];
}
//-(void)swipeToDeleteLayout:(LSSwipeToDeleteCollectionViewLayout *)layout cellDidTranslateWithOffset:(UIOffset)offset {
//    MUSCollectionViewCell *cell = (MUSCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.indexForDeletePicture];
//    cell.photoImageViewCell.alpha = 1 - offset.vertical / -75;
//    
//}
//
//
//-(void)swipeToDeleteLayout:(LSSwipeToDeleteCollectionViewLayout *)layout willBeginDraggingCellAtIndexPath:(NSIndexPath *)indexPath {
//    self.indexForDeletePicture = indexPath;
//    
//}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *arrayWithImages = [NSMutableArray new];
//    [self.arrayWithChosenImages enumerateObjectsUsingBlock:^(ImageToPost* image, NSUInteger idx, BOOL *stop) {
//        [arrayWithImages addObject:image.image];
//    }];
    [self.delegate showImagesOnOtherVcWithArray : self.arrayWithChosenImages andIndexPicTapped :indexPath.row];
}


#pragma mark - initiation UILongPressGestureRecognizer

//- (void) initiationGestureRecognizer {
//    //self.pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
//    self.pressGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
//    self.pressGesture.direction = UISwipeGestureRecognizerDirectionUp;
//    //self.pressGesture.minimumPressDuration = .2;
//    self.pressGesture.delegate = self;
//    [self.collectionView addGestureRecognizer: self.pressGesture];
//}
//
//
//-(void)handleLongPressGesture : (UISwipeGestureRecognizer*) gestureRecognizer {
//    
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
//        return;
//    }
//    
//    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
//    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
//    
//    if (!indexPath && self.isEditableCollectionView){
//        [self notEditableCollectionView];
//    } else if (indexPath) {
//        if (!self.isEditableCollectionView) {
//            [self editableCollectionView];
//        } else {
//            [self notEditableCollectionView];
//        }
//    }
//}
//
//- (void) editableCollectionView {
//    self.isEditableCollectionView = YES;
//    [self.collectionView reloadData];
//}
//
//- (void) notEditableCollectionView {
//    self.isEditableCollectionView = NO;
//    [self.collectionView reloadData];
//}


#pragma mark - passChosenImageForCollection

- (void) passChosenImageForCollection :(ImageToPost*) imageForPost {
    self.flag = NO;/////////////////////////////////////////////////////////////////////////////////////////
    if (!self.arrayWithChosenImages) {
        self.arrayWithChosenImages = [[NSMutableArray alloc] init];
    }
    [self.arrayWithChosenImages addObject: imageForPost];
    
    //NSLog(@"Array with Images = %@", self.arrayWithChosenImages);
    
    if ([self.arrayWithChosenImages count] == 1) {
        //self.collectionView.backgroundColor = YELLOW_COLOR_Slightly;
        [self.delegate changeSharePhotoButtonColorAndShareButtonState : YES];
    }
    self.isEditableCollectionView = NO;
    [self.collectionView reloadData];
}

- (void) clearCollectionAfterPosted {
    [self.arrayWithChosenImages removeAllObjects];
    [self.collectionView reloadData];
}

- (NSMutableArray*) obtainArrayWithChosenPics {
    return self.arrayWithChosenImages;
}

#pragma mark - photoAlertDeletePicShow

- (void) photoAlertDeletePicShow {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleAlertDeletePicShow
                                                    message:messageAlertDeletePicShow
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitleAlertDeletePicShow
                                          otherButtonTitles:otherButtonTitlesAlertDeletePicShow, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case YES:
            if ( self.indexForDeletePicture.row > self.arrayWithChosenImages.count - 1 && self.arrayWithChosenImages.count != 1) {
                [self.arrayWithChosenImages removeObjectAtIndex: self.indexForDeletePicture.row - _count];
                //_flagForDelete = NO;
            } else if(self.arrayWithChosenImages.count == 1) {
                [self.arrayWithChosenImages removeObjectAtIndex: 0];
                 //_flagForDelete = NO;

            }
            
            else {
            [self.arrayWithChosenImages removeObjectAtIndex: self.indexForDeletePicture.row];
                // _flagForDelete = NO;
            }
             _flagForDelete = NO;
            if ([self.arrayWithChosenImages count] == 0) {
                self.collectionView.backgroundColor = [UIColor whiteColor];
                self.arrayWithChosenImages = nil;
                [self.collectionView reloadData];
                [self.delegate changeSharePhotoButtonColorAndShareButtonState : NO];
                _count = 0;
                return;
            }
            [self.collectionView reloadData];
            break;
        case NO:
            //[self.collectionView reloadData];
            break;
        default:
            
            break;
    }
}

#pragma mark - MUSCollectionViewCellDelegate

- (void) deletePhoto:(NSIndexPath *)currentInadexPath {
    [self photoAlertDeletePicShow];
    self.indexForDeletePicture = currentInadexPath;
}

- (void) updateCollectionView {
    [self.collectionView reloadData];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
