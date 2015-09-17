//
//  MUSDetailPostViewController.h
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryHeader.h"

@protocol MUSDetailPostViewControllerDelegate <NSObject>

- (void) updatePostByPrimaryKey : (NSString*) primaryKey;

@end


@interface MUSDetailPostViewController : UIViewController

@property (assign, nonatomic) id <MUSDetailPostViewControllerDelegate> delegate;

@property (nonatomic, strong) Post *currentPost;

@end
