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
#import "MUSAddPhotoButton.h"
#import "MUSPhotoManager.h"

static NSString *LSCollectionViewCellIdentifier = @"Cell";

@interface MUSGaleryView()<UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, MUSCollectionViewCellDelegate>

@property (strong, nonatomic)  UIView *view;
@property (strong, nonatomic)  UISwipeGestureRecognizer *pressGesture;

/*!
 @property
 @abstract index for erasing a chosen picture
 */
@property (assign, nonatomic)  NSIndexPath * deleteImageIndex;
@property (strong, nonatomic) MUSAddPhotoButton *addPhotoButton;
@property (strong, nonatomic) Post *currentPost;
//===
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


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
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed: MUSApp_MUSGaleryView_NibName owner:self options:nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionView) name:notificationUpdateCollection object:nil];
    NSString *cellIdentifier = [MUSCollectionViewCell customCellID];
    [self.collectionView registerNib:[UINib nibWithNibName: cellIdentifier bundle: nil] forCellWithReuseIdentifier: cellIdentifier];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) setUpPost :(Post*)post {    
    self.currentPost = post;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.currentPost.arrayImages count] < 4) {
            return 1;
        } else {
            return 0;

        }
            }
    return  [self.currentPost.arrayImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MUSCollectionViewCell customCellID] forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
    
    ImageToPost *image;

    if (indexPath.section == 0 && [self.currentPost.arrayImages count] != 4) {
        [cell configurationCellForFirstSection];
    }else {
        image = self.currentPost.arrayImages[indexPath.row];
    [cell configurationCellWithPhoto:image.image andEditableState:YES];
    }
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.contentSize.height, self.collectionView.contentSize.height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate showImageBySelectedImageIndex :indexPath.row];
}


#pragma mark - passChosenImageForCollection

- (void) passChosenImageForCollection :(ImageToPost*) imageForPost {
    if (!self.currentPost.arrayImages) {
        self.currentPost.arrayImages = [[NSMutableArray alloc] init];
    }
    [self.currentPost.arrayImages addObject: imageForPost];
    
    if ([self.currentPost.arrayImages count] == 1) {
        [self.delegate changeSharePhotoButtonColorAndShareButtonState : YES];
    }
    self.isEditableCollectionView = NO;
    [self.collectionView reloadData];
}

- (void) reloadCollectionView {
    [self.collectionView reloadData];
}

#pragma mark - photoAlertDeletePicShow

- (void) photoAlertDeletePicShow {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MUSApp_MUSGaleryView_Alert_Title_DeletePic
                                        message: MUSApp_MUSGaleryView_Alert_Message_DeletePic
                                       delegate: self
                              cancelButtonTitle: MUSApp_Button_Title_NO
                              otherButtonTitles: MUSApp_Button_Title_YES, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case YES:
            [self.currentPost.arrayImages removeObjectAtIndex: self.deleteImageIndex.row];
            [self.collectionView reloadData];
            break;
        case NO:
            break;
        default:
            break;
    }
}

#pragma mark - MUSCollectionViewCellDelegate

- (void) deletePhotoBySelectedImageIndex:(NSIndexPath *)selectedImageIndex {
    [self photoAlertDeletePicShow];
    self.deleteImageIndex = selectedImageIndex;
}

- (void) updateCollectionView {
    [self.collectionView reloadData];    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
