//
//  MUSCollectionViewCellForDetailView.h
//  UniversalSharing
//
//  Created by Roman on 9/14/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSCollectionViewCellForDetailView : UICollectionViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setImageContext:(UIImage *)imageContext;

@end
