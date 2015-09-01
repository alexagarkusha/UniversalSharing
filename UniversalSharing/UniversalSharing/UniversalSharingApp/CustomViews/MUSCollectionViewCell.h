//
//  MUSCollectionViewCell.h
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUSCollectionViewCellDelegate <NSObject>
- (void) deletePhoto : (NSIndexPath*) currentInadexPath;
@end

@interface MUSCollectionViewCell : UICollectionViewCell

+ (NSString*) customCellID;
+ (instancetype) musCollectionViewCell;
- (void) configurationCellWithPhoto: (UIImage*) photoImageView;

@property (assign, nonatomic) id <MUSCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
//@property (assign, nonatomic) BOOL isEditable;


@property (weak, nonatomic) IBOutlet UIImageView *photoImageViewCell;

@end
