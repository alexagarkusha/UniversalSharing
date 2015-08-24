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
- (void) arrayOfImagesOfUser : (NSArray*) arrayOfImages;
@optional
- (void) showImagePicker;
@end



@interface MUSGalleryOfPhotosCell : UITableViewCell
@property (nonatomic, assign) id <MUSGalleryOfPhotosCellDelegate> delegate;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, assign) BOOL isEditableCell;


+ (NSString*) cellID;
+ (instancetype) galleryOfPhotosCell;
+ (CGFloat) heightForGalleryOfPhotosCell : (NSInteger) countOfImages;

- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages andDateCreate : (NSString*) postDateCreate andUser : (User*) user;


@end
