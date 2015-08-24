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

@interface MUSGaleryView()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//===
@property (strong, nonatomic)  UIView *view;
@property (strong, nonatomic)  NSMutableArray *arrayWithChosenImages;
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

- (void) passChosenImageForCollection :(ImageToPost*) imageForPost {
    [self.arrayWithChosenImages addObject: imageForPost];
    if ([self.arrayWithChosenImages count] == 1) {
        self.collectionView.backgroundColor = [UIColor grayColor];
        [self.delegate changeSharePhotoButtonColorAndShareButtonState : YES];
    }
    [self.collectionView reloadData];
}

- (NSArray*) obtainArrayWithChosenPics {
    return self.arrayWithChosenImages;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.arrayWithChosenImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MUSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    if (self.arrayWithChosenImages[indexPath.row] != nil) {
        ImageToPost *image = self.arrayWithChosenImages[indexPath.row];
        cell.photoImageViewCell.image = image.image;
    } else {
        cell.photoImageViewCell.image = nil;
    }
    return  cell;
}

-(UIView*)loadViewFromNib {
    
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:loadNibNamed owner:self options:nil];
    [self.collectionView registerNib:[UINib nibWithNibName:nibWithNibName bundle:nil] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    [self setGestureRecognizer];
    
    self.arrayWithChosenImages = [NSMutableArray new];
    return [nibObjects firstObject];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.contentSize.height, self.collectionView.contentSize.height);
}

- (void) setGestureRecognizer {
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    pressGesture.minimumPressDuration = .5;
    pressGesture.delegate = self;
    [self.collectionView addGestureRecognizer:pressGesture];
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        [self photoAlertDeletePicShow];
        self.indexForDeletePicture = indexPath.row;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case YES:
            [self.arrayWithChosenImages removeObjectAtIndex:self.indexForDeletePicture];
            if ([self.arrayWithChosenImages count] == 0) {
                self.collectionView.backgroundColor = [UIColor whiteColor];
                [self.delegate changeSharePhotoButtonColorAndShareButtonState : NO];
            }
            [self.collectionView reloadData];
            break;
        case NO:
            break;
        default:
            break;
    }
}

- (void) photoAlertDeletePicShow {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleAlertDeletePicShow
                                                    message:messageAlertDeletePicShow
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitleAlertDeletePicShow
                                          otherButtonTitles:otherButtonTitlesAlertDeletePicShow, nil];
    [alert show];
}
@end
