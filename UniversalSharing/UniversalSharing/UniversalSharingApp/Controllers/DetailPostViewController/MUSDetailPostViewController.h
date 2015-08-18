//
//  MUSDetailPostViewController.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@interface MUSDetailPostViewController : UIViewController

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) Post *currentPost;

@end
