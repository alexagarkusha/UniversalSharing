//
//  MUSTopBarForDetailCollectionView.m
//  UniversalSharing
//
//  Created by Roman on 9/16/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSTopBarForMediaGalleryViewController.h"
#import "UIImage+LoadImageFromDataBase.h"
#import "MUSConstantsApp.h"

@interface MUSTopBarForMediaGalleryViewController()

@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* buttonTopConstraint;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* labelTopConstraint;
@property (weak, nonatomic)     IBOutlet    UILabel *counterImagesLabel;
//===
@property (assign, nonatomic) BOOL hideProperties;
@property (strong, nonatomic) UIView *view;

@end

@implementation MUSTopBarForMediaGalleryViewController

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xibSetup];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self xibSetup];
    }
    return self;
}

- (void) xibSetup {
    _hideProperties = NO;
    self.view = [self loadViewFromNib];
    self.view.frame = self.bounds;
    [self addSubview:self.view];    
}

-(UIView*)loadViewFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:MUSApp_MUSTopBarForMediaGalleryViewController_NibName owner:self options:nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
    [self.backButton setTitleColor: BROWN_COLOR forState:UIControlStateNormal];
}

- (void) initializeCounterImages:(NSString *)stringFiguredOutCounterImages {
    self.counterImagesLabel.textColor = BROWN_COLOR;
    self.counterImagesLabel.text = stringFiguredOutCounterImages;
}

- (void) hidePropertiesWithAnimation {
    if (!_hideProperties) {
        [self.view layoutIfNeeded];
            _labelTopConstraint.constant -= _view.frame.size.height;
            _buttonTopConstraint.constant -= _view.frame.size.height;
        [UIView animateWithDuration: 0.4  animations:^{
            [self.view layoutIfNeeded];
        }];
        [UIView commitAnimations];
    } else  {
        [self.view layoutIfNeeded];
        _labelTopConstraint.constant += _view.frame.size.height;
        _buttonTopConstraint.constant += _view.frame.size.height;
        [UIView animateWithDuration: 0.4  animations:^{
            [self.view layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }
    _hideProperties = (_hideProperties)? NO : YES;
}

@end
