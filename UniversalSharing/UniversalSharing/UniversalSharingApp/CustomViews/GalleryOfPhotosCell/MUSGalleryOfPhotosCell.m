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
#import "MUSGalleryViewOfPhotos.h"

@interface MUSGalleryOfPhotosCell () <MUSGalleryViewOfPhotosDelegate>

@property (weak, nonatomic)     IBOutlet    MUSGalleryViewOfPhotos *galleryViewOfPhotos;

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
        return heightOfRow = 0;
    } else {
        return heightOfRow = musAppDetailPostVC_HeightOfGalleryOfPhotosCell_WithPhotos;
    }
}

- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages {
    
    [self checkGalleryOfPhotosStatus];
    [self initiationGalleryViewOfPhotos : arrayOfImages];    
#warning IT IS NOT Correctly
    /*
    if (arrayOfImages.count > self.numberOfImages && self.isEditableCell && arrayOfImages.count != 1 && self.numberOfImages != 0) {
        [self.galleryViewOfPhotos scrollCollectionViewToLastPhoto];
    }
    self.numberOfImages = arrayOfImages.count;
     */
    if (self.numberOfImages == arrayOfImages.count && self.isEditableCell) {
        [self.galleryViewOfPhotos scrollCollectionViewToLastPhoto];
    }
    self.numberOfImages = arrayOfImages.count + 1;
}

#pragma mark initiation GalleryViewOfPhotos

- (void) initiationGalleryViewOfPhotos : (NSMutableArray*) arrayWithImages {
    [self.galleryViewOfPhotos initiationGalleryViewOfPhotos];
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
    self.numberOfImages = arrayOfPhotos.count + 1;
    [self.delegate editArrayOfPicturesInPost: arrayOfPhotos];
}

- (void) addPhotoToPost {
    [self.delegate showImagePicker];
}


@end
