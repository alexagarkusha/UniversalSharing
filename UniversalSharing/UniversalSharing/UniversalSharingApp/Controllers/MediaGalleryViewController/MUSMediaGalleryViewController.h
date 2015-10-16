//
//  MUSDitailPostCollectionViewController.h
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetwork.h"

@interface MUSMediaGalleryViewController : UIViewController

- (void) sendPost :(MUSPost*) currentPost andSelectedImageIndex :(NSInteger) selectedImageIndex;
//===
@property (assign, nonatomic) BOOL isEditableCollectionView;

@end
