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

@interface MUSGaleryView()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIAlertViewDelegate, MUSCollectionViewCellDelegate>

//===
@property (strong, nonatomic)  UIView *view;
@property (strong, nonatomic)  NSMutableArray *arrayWithChosenImages;
@property (strong, nonatomic)  UILongPressGestureRecognizer *pressGesture;

/*!
 @property
 @abstract index for erasing a chosen picture
 */
@property (assign, nonatomic)  NSUInteger indexForDeletePicture;

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
    NSString *cellIdentifier = [MUSCollectionViewCell customCellID];
    [self.collectionView registerNib:[UINib nibWithNibName: cellIdentifier bundle: nil] forCellWithReuseIdentifier: cellIdentifier];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //self.arrayWithChosenImages = [[NSMutableArray alloc] init];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"COUNT ROW = %d", [self.arrayWithChosenImages count]);
    return  [self.arrayWithChosenImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MUSCollectionViewCell customCellID] forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        NSLog(@"INDEXPATH %@", indexPath);
        ImageToPost *image = self.arrayWithChosenImages[indexPath.row];
        //cell.isEditable = self.isEditableCollectionView;
        [cell configurationCellWithPhoto: image.image];
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.contentSize.height, self.collectionView.contentSize.height);
}

#pragma mark - initiation UILongPressGestureRecognizer
/*
- (void) initiationGestureRecognizer {
    self.pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.pressGesture.minimumPressDuration = .2;
    self.pressGesture.delegate = self;
    [self.collectionView addGestureRecognizer: self.pressGesture];
}


-(void)handleLongPressGesture : (UILongPressGestureRecognizer*) gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (!indexPath && self.isEditableCollectionView){
        [self notEditableCollectionView];
    } else if (indexPath) {
        if (!self.isEditableCollectionView) {
            [self editableCollectionView];
        } else {
            [self notEditableCollectionView];
        }
    }
}

- (void) editableCollectionView {
    self.isEditableCollectionView = YES;
    [self.collectionView reloadData];
}

- (void) notEditableCollectionView {
    self.isEditableCollectionView = NO;
    [self.collectionView reloadData];
}
*/

#pragma mark - passChosenImageForCollection

- (void) passChosenImageForCollection :(ImageToPost*) imageForPost {
    if (!self.arrayWithChosenImages) {
        self.arrayWithChosenImages = [[NSMutableArray alloc] init];
    }
    [self.arrayWithChosenImages addObject: imageForPost];
    
    NSLog(@"Array with Images = %@", self.arrayWithChosenImages);
    
    if ([self.arrayWithChosenImages count] == 1) {
        self.collectionView.backgroundColor = YELLOW_COLOR_Slightly;
        [self.delegate changeSharePhotoButtonColorAndShareButtonState : YES];
    }
    self.isEditableCollectionView = NO;
    [self.collectionView reloadData];
}

- (NSArray*) obtainArrayWithChosenPics {
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
            [self.arrayWithChosenImages removeObjectAtIndex: self.indexForDeletePicture];

            if ([self.arrayWithChosenImages count] == 0) {
                self.collectionView.backgroundColor = [UIColor whiteColor];
                self.arrayWithChosenImages = nil;
                [self.collectionView reloadData];
                [self.delegate changeSharePhotoButtonColorAndShareButtonState : NO];
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
    self.indexForDeletePicture = currentInadexPath.row;
}

@end
