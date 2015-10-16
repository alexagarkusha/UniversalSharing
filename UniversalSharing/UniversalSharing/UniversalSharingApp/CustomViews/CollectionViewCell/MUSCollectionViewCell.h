//
//  MUSCollectionViewCell.h
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUSCollectionViewCellDelegate <NSObject>
@optional
- (void) deletePhotoBySelectedImageIndex : (NSIndexPath*) selectedImageIndex;
- (void) addPhotoToCollection;
@end

@interface MUSCollectionViewCell : UICollectionViewCell

+ (NSString*) customCellID;
+ (instancetype) musCollectionViewCell;
//===
- (void) configurationCellWithPhoto:(UIImage *) photoImageView andEditableState : (BOOL) isEditable;
- (void) configurationCellForFirstSection;
//===
@property (assign, nonatomic) id <MUSCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
//===
@property (weak, nonatomic) IBOutlet UIImageView *photoImageViewCell;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButtonOutlet;

@end
