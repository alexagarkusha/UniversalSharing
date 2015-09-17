//
//  MUSDitailPostCollectionViewController.h
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialNetwork.h"

@interface MUSDetailPostCollectionViewController : UIViewController

- (void) setObjectsWithArray :(NSArray*) arrayOfPics andCurrentSocialNetwork :(id)currentSocialNetwork andIndexPicTapped :(NSInteger) indexPicTapped;

@end
