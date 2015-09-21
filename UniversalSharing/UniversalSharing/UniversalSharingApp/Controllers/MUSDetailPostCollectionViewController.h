//
//  MUSDitailPostCollectionViewController.h
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialNetwork.h"

//@protocol MUSDetailPostCollectionViewControllerDelegate <NSObject>
//@required
//- (void) updateCollectionView;
//@end

@interface MUSDetailPostCollectionViewController : UIViewController

//@property (nonatomic, assign) id <MUSDetailPostCollectionViewControllerDelegate> delegateDetailPostCollectionViewController;
//===
- (void) setObjectsWithPost :(Post*) currentPost andCurrentSocialNetwork :(id)currentSocialNetwork andIndexPicTapped :(NSInteger) indexPicTapped;

@end
