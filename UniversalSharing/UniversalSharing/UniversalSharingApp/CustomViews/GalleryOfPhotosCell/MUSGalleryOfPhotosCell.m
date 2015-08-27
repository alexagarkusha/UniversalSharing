//
//  MUSGalleryOfPhotosCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSGalleryOfPhotosCell.h"
#import "MUSCollectionViewCell.h"
#import "ConstantsApp.h"
#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "UIImageView+RoundImage.h"
#import "UIButton+MUSEditableButton.h"
#import "MUSPhotoManager.h"
#import "MUSGalleryViewOfPhotos.h"
#import "UILabel+CornerRadiusLabel.h"
#import "NSString+DateStringFromUNIXTimestamp.h"

@interface MUSGalleryOfPhotosCell () <MUSGalleryViewOfPhotosDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfPostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButtonOutlet;
@property (weak, nonatomic) IBOutlet MUSGalleryViewOfPhotos *galleryViewOfPhotos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonButtomConstraint;
@property (strong, nonatomic) NSMutableArray *arrayWithImages;
@property (assign, nonatomic) BOOL isEditableGallery;
@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) ReasonType reasonType;

- (IBAction)addPhotoTouch:(id)sender;

@end


@implementation MUSGalleryOfPhotosCell

- (void)awakeFromNib {
    // Initialization code
    //self.galleryViewOfPhotos = [[MUSGalleryViewOfPhotos alloc] init];
    [self.addPhotoButtonOutlet editableButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSGalleryOfPhotosCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) galleryOfPhotosCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

+ (CGFloat) heightForGalleryOfPhotosCell : (NSInteger) countOfImages {
    CGFloat heightOfRow;
    if (countOfImages > 0) {
        return heightOfRow = 150;
    } else {
        return heightOfRow = 70;
    }
}

- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages andDateCreatePost:(NSString *)postDateCreate withReasonOfPost : (ReasonType) reasonOfPost andWithSocialNetworkIconName:(NSString *)socialNetworkIconName andUser: (User*)user {
    
    [self checkGalleryOfPhotosStatus];
    self.currentUser = user;
    self.reasonType = reasonOfPost;
    [self initiationGalleryViewOfPhotos : arrayOfImages];
    
    if (arrayOfImages.count > self.arrayWithImages.count && self.arrayWithImages.count >= 1) {
        [self.galleryViewOfPhotos scrollCollectionViewToLastPhoto];
    }
    self.arrayWithImages = [NSMutableArray arrayWithArray: arrayOfImages];

    [self initiationAddButton];
    [self initiationUserNameLabel: user];
    [self initiationUserDateOfPostLabel: postDateCreate];
    [self initiationUserPhotoImageView: socialNetworkIconName];
    [self initiationReasonOfPostLabelColor];
}

#pragma mark initiation HeightOfRow

- (void) initiationAddButton {
    if (self.arrayWithImages.count > 0) {
        self.addButtonButtomConstraint.constant = 50;
    } else {
        self.addButtonButtomConstraint.constant = -4;
    }
}

#pragma mark initiation GalleryViewOfPhotos

- (void) initiationGalleryViewOfPhotos : (NSMutableArray*) arrayWithImages {
        //self.galleryViewOfPhotos.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [MUSGalleryOfPhotosCell heightForGalleryOfPhotosCell: arrayWithImages.count]);
        self.galleryViewOfPhotos.delegate = self;
        self.galleryViewOfPhotos.collectionView.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 251.0/255.0 blue: 241.0/255.0 alpha: 1.0];
        self.galleryViewOfPhotos.arrayOfPhotos = [NSMutableArray arrayWithArray : arrayWithImages];
        [self.galleryViewOfPhotos isVisiblePageControl : YES];
        [self.galleryViewOfPhotos.collectionView reloadData];
 }

#pragma mark initiation UserNameLabel

- (void) initiationUserNameLabel : (User*) user {
    if (self.arrayWithImages.count > 0) {
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.dateOfPostLabel.textColor = [UIColor whiteColor];
        self.galleryViewOfPhotos.hidden = NO;
    } else {
        self.usernameLabel.textColor = [UIColor blackColor];
        self.dateOfPostLabel.textColor = [UIColor blackColor];
        self.galleryViewOfPhotos.hidden = YES;
    }
    
    self.usernameLabel.text = [NSString stringWithFormat: @"%@ %@", self.currentUser.lastName, self.currentUser.firstName];
    [self.usernameLabel sizeToFit];
}

#pragma mark initiation UserDateOfPostLabel

- (void) initiationUserDateOfPostLabel : (NSString*) dateOfPostCreate {
    NSString *date = [[NSString alloc] init];
    self.dateOfPostLabel.text = [date dateStringFromUNIXTimestamp:[dateOfPostCreate integerValue]];
    [self.dateOfPostLabel sizeToFit];
}

#pragma mark initiation UserPhotoImageView

- (void) initiationUserPhotoImageView : (NSString*) socialNetworkIconName {
    [self.userPhotoImageView loadImageFromDataBase: socialNetworkIconName];
    [self.userPhotoImageView roundImageView];
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 2.0;
    self.userPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark initiation ReasonOfPostLabel

- (void) initiationReasonOfPostLabelColor {
    [self.reasonOfPostLabel cornerRadius: CGRectGetHeight(self.reasonOfPostLabel.frame) / 2];
    self.reasonOfPostLabel.backgroundColor = [self reasonColorForPost : self.reasonType];
}

- (UIColor*) reasonColorForPost : (ReasonType) currentReasonType {
    switch (currentReasonType) {
        case Connect:
            return [UIColor greenColor];
            break;
        case ErrorConnection:
            return [UIColor orangeColor];
            break;
        case Offline:
            return [UIColor redColor];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - UIButton

- (IBAction)addPhotoTouch:(id)sender {
    [self.delegate showImagePicker];
}

#pragma mark - check GalleryOfPhotosStatus

- (void) checkGalleryOfPhotosStatus {
    if (!self.isEditableCell) {
        self.addPhotoButtonOutlet.hidden = YES;
        self.galleryViewOfPhotos.isEditableGallery = NO;
    } else {
        self.addPhotoButtonOutlet.hidden = NO;
        self.galleryViewOfPhotos.isEditableGallery = YES;
    }
}

#pragma mark - MUSGalleryViewOfPhotosDelegate

- (void) arrayOfPhotos:(NSArray *)arrayOfPhotos {
    [self.delegate arrayOfImagesOfUser: arrayOfPhotos];
    self.arrayWithImages = [NSMutableArray arrayWithArray: arrayOfPhotos];
}



@end
