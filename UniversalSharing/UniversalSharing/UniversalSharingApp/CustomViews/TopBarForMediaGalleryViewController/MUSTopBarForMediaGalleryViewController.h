//
//  MUSTopBarForDetailCollectionView.h
//  UniversalSharing
//
//  Created by Roman on 9/16/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSTopBarForMediaGalleryViewController : UIView

@property (weak, nonatomic) IBOutlet UIButton *backButton;
//===
- (void) initializeCounterImages:(NSString *)stringFiguredOutCounterImages;
- (void) hidePropertiesWithAnimation;

@end
