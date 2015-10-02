//
//  MUSProgressBar.h
//  UniversalSharing
//
//  Created by Roman on 10/2/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSProgressBar : UIView
// as long as it is so, then we would change to private)

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPost;
@property (weak, nonatomic) IBOutlet UILabel *labelStutus;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
//@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic)  UIView *view;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* lableConstraint;

@end
