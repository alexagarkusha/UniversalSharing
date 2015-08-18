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
- (void) heightOfGalleryOfPhotosRow : (CGFloat) heightRow;
@end



@interface MUSGalleryOfPhotosCell : UITableViewCell
@property (nonatomic, assign) id <MUSGalleryOfPhotosCellDelegate> delegate;
@property (nonatomic, strong) Post *currentPost;
@property (nonatomic, strong) User *currentUser;

+ (NSString*) cellID;
+ (instancetype) galleryOfPhotosCell;

- (void) configurationGalleryOfPhotosCellByPost: (Post*) currentPost andUser : (User*) user;

@end
