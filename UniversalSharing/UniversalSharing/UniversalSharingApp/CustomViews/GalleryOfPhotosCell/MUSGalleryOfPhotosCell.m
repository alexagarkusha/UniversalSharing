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
#import "UIColor+ReasonColorForPost.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"

@interface MUSGalleryOfPhotosCell () <MUSGalleryViewOfPhotosDelegate>

- (IBAction)addPhotoTouch:(id)sender;

@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint *addButtonButtomConstraint;
@property (weak, nonatomic)     IBOutlet    MUSGalleryViewOfPhotos *galleryViewOfPhotos;
@property (weak, nonatomic)     IBOutlet    UIButton *addPhotoButtonOutlet;
@property (weak, nonatomic)     IBOutlet    UIImageView *userPhotoImageView;
@property (weak, nonatomic)     IBOutlet    UILabel *usernameLabel;
@property (weak, nonatomic)     IBOutlet    UILabel *dateOfPostLabel;
@property (weak, nonatomic)     IBOutlet    UILabel *reasonOfPostLabel;

@property (assign, nonatomic)   BOOL        isEditableGallery;
@property (assign, nonatomic)   NSInteger   numberOfImages;

@end

@implementation MUSGalleryOfPhotosCell

- (void)awakeFromNib {
    // Initialization code
    //self.galleryViewOfPhotos = [[MUSGalleryViewOfPhotos alloc] init];
    [self.addPhotoButtonOutlet editableButton];
    self.backgroundColor = YELLOW_COLOR_Slightly;
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
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos;
    } else {
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithoutPhotos;
    }
}

- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages andDateCreatePost:(NSString *)postDateCreate withReasonOfPost : (ReasonType) reasonOfPost andWithSocialNetworkIconName:(NSString *)socialNetworkIconName andUser: (User*)user {
    
    [self checkGalleryOfPhotosStatus];
    [self initiationGalleryViewOfPhotos : arrayOfImages];
    
    if (arrayOfImages.count > self.numberOfImages && self.numberOfImages >= 1) {
        [self.galleryViewOfPhotos scrollCollectionViewToLastPhoto];
    }
    self.numberOfImages = arrayOfImages.count;

    [self initiationAddButton];
    [self initiationUserNameLabel: user];
    [self initiationUserDateOfPostLabel: postDateCreate];
    [self initiationUserPhotoImageView: socialNetworkIconName];
    [self initiationReasonOfPostLabelColor: reasonOfPost];
}

#pragma mark initiation HeightOfRow

- (void) initiationAddButton {
    if (self.numberOfImages > 0) {
        self.addButtonButtomConstraint.constant = musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithPhotos;
    } else {
        self.addButtonButtomConstraint.constant = musApp_GalleryOfPhotosCell_addButton_ButtomConstraint_WithoutPhotos;
    }
}

#pragma mark initiation GalleryViewOfPhotos

- (void) initiationGalleryViewOfPhotos : (NSMutableArray*) arrayWithImages {
    if (arrayWithImages.count > 0) {
        self.galleryViewOfPhotos.hidden = NO;
    } else {
        self.galleryViewOfPhotos.hidden = YES;
    }
    
        self.galleryViewOfPhotos.delegate = self;
        self.galleryViewOfPhotos.collectionView.backgroundColor = YELLOW_COLOR_Slightly;
        self.galleryViewOfPhotos.arrayOfPhotos = [NSMutableArray arrayWithArray : arrayWithImages];
        [self.galleryViewOfPhotos isVisiblePageControl : YES];
        [self.galleryViewOfPhotos.collectionView reloadData];
 }

#pragma mark initiation UserNameLabel

- (void) initiationUserNameLabel : (User*) user {
    if (self.numberOfImages > 0) {
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.shadowColor = [UIColor blackColor];
        self.dateOfPostLabel.textColor = [UIColor whiteColor];
        self.dateOfPostLabel.shadowColor = [UIColor blackColor];
    } else {
        self.usernameLabel.textColor = [UIColor blackColor];
        self.usernameLabel.shadowColor = [UIColor whiteColor];
        self.dateOfPostLabel.textColor = [UIColor blackColor];
        self.dateOfPostLabel.shadowColor = [UIColor whiteColor];
    }
    
    self.usernameLabel.text = [NSString stringWithFormat: @"%@ %@", user.lastName, user.firstName];
    [self.usernameLabel sizeToFit];
}

#pragma mark initiation UserDateOfPostLabel

- (void) initiationUserDateOfPostLabel : (NSString*) dateOfPostCreate {
    self.dateOfPostLabel.text = [NSString dateStringFromUNIXTimestamp: [dateOfPostCreate integerValue]];
    [self.dateOfPostLabel sizeToFit];
}

#pragma mark initiation UserPhotoImageView

- (void) initiationUserPhotoImageView : (NSString*) socialNetworkIconName {
    [self.userPhotoImageView loadImageFromDataBase: socialNetworkIconName];
    [self.userPhotoImageView cornerRadius: CGRectGetHeight(self.userPhotoImageView.frame) / 2 andBorderWidth: 2.0 withBorderColor: [UIColor whiteColor]];
}

#pragma mark initiation ReasonOfPostLabel

- (void) initiationReasonOfPostLabelColor : (ReasonType) reasonOfPost {
    [self.reasonOfPostLabel cornerRadius: CGRectGetHeight(self.reasonOfPostLabel.frame) / 2];
    self.reasonOfPostLabel.backgroundColor = [UIColor reasonColorForPost: reasonOfPost];
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
    self.numberOfImages = arrayOfPhotos.count;
}



@end
