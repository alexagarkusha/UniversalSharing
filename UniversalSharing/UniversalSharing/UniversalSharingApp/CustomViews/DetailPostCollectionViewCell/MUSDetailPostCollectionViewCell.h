//
//  MUSDetailPostCollectionViewCell.h
//  UniversalSharing
//
//  Created by U 2 on 31.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSDetailPostCollectionViewCell : UICollectionViewCell

+ (NSString*) customCellID;
+ (instancetype) musDetailPostCollectionViewCell;
- (void) configurationCellWithPhoto: (UIImage*) photoImageView;


@end
