//
//  MUSTopBarForDetailCollectionView.h
//  UniversalSharing
//
//  Created by Roman on 9/16/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSUserProfileButton.h"

@interface MUSTopBarForDetailCollectionView : UIView

@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
//@property (weak, nonatomic) IBOutlet MUSUserProfileButton *showUserProfileButton;

//===
- (void) initializeLableCountImages:(NSString *)stringLableCountImages;
//- (void) initializeImageView:(NSString *)stringPathImage;
- (void) hidePropertiesWithAnimation;

@end
