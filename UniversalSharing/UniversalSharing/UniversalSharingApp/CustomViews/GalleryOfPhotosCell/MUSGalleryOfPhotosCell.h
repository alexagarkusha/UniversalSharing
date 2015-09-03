//
//  MUSGalleryOfPhotosCell.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@protocol MUSGalleryOfPhotosCellDelegate <NSObject>
/*!
 @method
 @abstract edit array of pictures in post
 @param edited array of pictures
 */
- (void) editArrayOfPicturesInPost : (NSArray*) arrayOfImages;
/*!
 @method
 @abstract show MUSDetailPostViewController for add photo to gallery from camera or album
 */
- (void) showImagePicker;
@end



@interface MUSGalleryOfPhotosCell : UITableViewCell
@property (nonatomic, assign) id <MUSGalleryOfPhotosCellDelegate> delegate;
@property (nonatomic, assign) BOOL isEditableCell;


+ (NSString*) cellID;
+ (instancetype) galleryOfPhotosCell;
+ (CGFloat) heightForGalleryOfPhotosCell : (NSInteger) countOfImages;


- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages andDateCreatePost:(NSString *)postDateCreate withReasonOfPost : (ReasonType) reasonOfPost andWithSocialNetworkIconName:(NSString *)socialNetworkIconName andUser: (User*)user;

@end
