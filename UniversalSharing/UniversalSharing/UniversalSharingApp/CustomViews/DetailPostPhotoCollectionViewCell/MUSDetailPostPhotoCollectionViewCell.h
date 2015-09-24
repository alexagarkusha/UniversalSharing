//
//  MUSDetailPostPhotoCollectionViewCell.h
//  UniversalSharing
//
//  Created by U 2 on 24.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSDetailPostPhotoCollectionViewCell : UICollectionViewCell

+ (NSString*) detailPostPhotoCellID;
+ (instancetype) detailPostPhotoCell;

- (void) configurationCellWithPhoto:(UIImage *) image;

@end
