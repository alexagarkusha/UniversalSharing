//
//  MUSProgressBar.m
//  UniversalSharing
//
//  Created by Roman on 10/2/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSProgressBar.h"
#import "ConstantsApp.h"
@implementation MUSProgressBar
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [self loadViewFromNib];
        self.view.frame = frame;
        [self addSubview:self.view];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [self loadViewFromNib];
        [self addSubview:self.view];
    }
    return self;
}


-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"MUSProgressBar" owner:self options:nil];
    self.progressView.trackTintColor = BROWN_COLOR_MIDLight;
    //[self initiationGestureRecognizer];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
   
}
@end
