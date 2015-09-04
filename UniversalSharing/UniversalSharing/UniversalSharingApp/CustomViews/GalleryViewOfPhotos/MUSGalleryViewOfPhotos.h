//
//  MUSGalleryViewOfPhotos.h
//  UniversalSharing
//
//  Created by U 2 on 19.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol MUSGalleryViewOfPhotosDelegate <NSObject>
- (void) arrayOfPhotos : (NSArray*) arrayOfPhotos;
- (void) addPhotoToPost;
@end

@interface MUSGalleryViewOfPhotos : UIView

@property (nonatomic, assign) id <MUSGalleryViewOfPhotosDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arrayOfPhotos; //Array of images
@property (nonatomic, assign) BOOL isEditableGallery;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *view;

- (void) isVisiblePageControl : (BOOL) isVisible;
- (void) scrollCollectionViewToLastPhoto;

@end
