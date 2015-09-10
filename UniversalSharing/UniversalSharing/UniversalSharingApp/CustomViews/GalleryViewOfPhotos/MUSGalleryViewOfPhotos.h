//
//  MUSGalleryViewOfPhotos.h
//  UniversalSharing
//
//  Created by U 2 on 19.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol MUSShowPhotosDelegate <NSObject>
//- (void) arrayOfPhotosShow : (NSArray*) arrayOfPhotos;
//@end
@protocol MUSGalleryViewOfPhotosDelegate <NSObject>
- (void) arrayOfPhotos : (NSArray*) arrayOfPhotos;
- (void) addPhotoToPost;
@end

@interface MUSGalleryViewOfPhotos : UIView

@property (nonatomic, assign) id <MUSGalleryViewOfPhotosDelegate> delegate;
//@property (nonatomic, assign) id <MUSShowPhotosDelegate> delegateShowPhotos;

@property (nonatomic, strong) NSMutableArray *arrayOfPhotos; //Array of images
@property (nonatomic, assign) BOOL isEditableGallery;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (strong, nonatomic) IBOutlet UIView *view;

+ (NSString*) viewID;

- (void) initiationGalleryViewOfPhotos;
- (void) isVisiblePageControl : (BOOL) isVisible;
- (void) scrollCollectionViewToLastPhoto;

@end
