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
#import "MUSPhotoManager.h"
#import "MUSGalleryViewOfPhotos.h"
#import "UILabel+CornerRadiusLabel.h"
#import "NSString+DateStringFromUNIXTimestamp.h"
#import "UIColor+ReasonColorForPost.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"

@interface MUSGalleryOfPhotosCell () <MUSGalleryViewOfPhotosDelegate>


@property (weak, nonatomic)     IBOutlet    MUSGalleryViewOfPhotos *galleryViewOfPhotos;
@property (weak, nonatomic)     IBOutlet    UIImageView *userPhotoImageView;
@property (weak, nonatomic)     IBOutlet    UILabel *usernameLabel;
@property (weak, nonatomic)     IBOutlet    UILabel *dateOfPostLabel;

@property (assign, nonatomic)   BOOL        isEditableGallery;
@property (assign, nonatomic)   NSInteger   numberOfImages;

@end

@implementation MUSGalleryOfPhotosCell

- (void)awakeFromNib {
    // Initialization code
    //self.galleryViewOfPhotos = [[MUSGalleryViewOfPhotos alloc] init];
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

+ (CGFloat) heightForGalleryOfPhotosCell : (NSInteger) countOfImages andIsEditableCell : (BOOL) isEditableCell {
    CGFloat heightOfRow;
    if (!isEditableCell && countOfImages == 0) {
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithoutPhotos;
    } else {
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos;
    }
    
    
    /*
    if (countOfImages > 0 || isEditableCell) {
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos;
    } else {
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithoutPhotos;
    }
     */
}

- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages andDateCreatePost:(NSString *)postDateCreate withReasonOfPost : (ReasonType) reasonOfPost andWithSocialNetworkIconName:(NSString *)socialNetworkIconName andUser: (User*)user {
    
    [self checkGalleryOfPhotosStatus];
    [self initiationGalleryViewOfPhotos : arrayOfImages];
    
    if (arrayOfImages.count > self.numberOfImages && self.numberOfImages >= 1) {
        [self.galleryViewOfPhotos scrollCollectionViewToLastPhoto];
    }
    self.numberOfImages = arrayOfImages.count;

    [self initiationUserNameLabel: user];
    [self initiationUserDateOfPostLabel: postDateCreate];
    [self initiationUserPhotoImageView: socialNetworkIconName];
}

#pragma mark initiation GalleryViewOfPhotos

- (void) initiationGalleryViewOfPhotos : (NSMutableArray*) arrayWithImages {
    
    if (!self.isEditableCell && arrayWithImages.count == 0) {
        self.galleryViewOfPhotos.hidden = YES;
    } else {
        self.galleryViewOfPhotos.hidden = NO;
    }
    
        self.galleryViewOfPhotos.delegate = self;
        self.galleryViewOfPhotos.arrayOfPhotos = [NSMutableArray arrayWithArray : arrayWithImages];
        [self.galleryViewOfPhotos isVisiblePageControl : YES];
        [self.galleryViewOfPhotos.collectionView reloadData];
 }

#pragma mark initiation UserNameLabel

- (void) initiationUserNameLabel : (User*) user {
    if (self.numberOfImages > 0 || self.isEditableCell) {
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

#pragma mark - check GalleryOfPhotosStatus

- (void) checkGalleryOfPhotosStatus {
    if (!self.isEditableCell) {
        self.galleryViewOfPhotos.isEditableGallery = NO;
    } else {
        self.galleryViewOfPhotos.isEditableGallery = YES;
    }
}

#pragma mark - MUSGalleryViewOfPhotosDelegate

- (void) arrayOfPhotos:(NSArray *)arrayOfPhotos {
    [self.delegate editArrayOfPicturesInPost: arrayOfPhotos];
    self.numberOfImages = arrayOfPhotos.count;
}

- (void) addPhotoToPost {
    [self.delegate showImagePicker];
}


@end
