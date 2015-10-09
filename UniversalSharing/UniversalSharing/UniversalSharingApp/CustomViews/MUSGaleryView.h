//
//  MUSGaleryView.h
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageToPost.h"
#import "Post.h"

@protocol MUSGaleryViewDelegate <NSObject>
@required
- (void) changeSharePhotoButtonColorAndShareButtonState: (BOOL) isPhotos;
- (void) showImageBySelectedImageIndex :(NSInteger) selectedImageIndex;
@end


@interface MUSGaleryView : UIView 

@property (nonatomic, assign) id <MUSGaleryViewDelegate> delegate;
//===
@property (nonatomic, assign)  BOOL isEditableCollectionView;

/*!
 @method
 @abstract call from shareviewcontroller
 @param object ImageToPost with current image in order to add to arrayWithChosenImages
 */
- (void) passChosenImageForCollection :(ImageToPost*) imageForPost;
/*!
 @method
 @abstract call from shareviewcontroller in order to get array with chosen pics by a user
 @param without
 */
//- (NSArray*) obtainArrayWithChosenPics;

- (void) reloadCollectionView;
- (void) setUpPost :(Post*)post;

@end
