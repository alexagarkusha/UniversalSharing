//
//  MUSGaleryView.h
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageToPost.h"

@interface MUSGaleryView : UIView

- (void) passChosenImageForCollection :(ImageToPost*) imageForPost;
- (NSArray*) obtainArrayWithChosedPics;
@end
