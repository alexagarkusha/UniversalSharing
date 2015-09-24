//
//  MUSTopBarForDetailCollectionView.m
//  UniversalSharing
//
//  Created by Roman on 9/16/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSTopBarForDetailCollectionView.h"
#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "UIImage+LoadImageFromDataBase.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"
#import "ConstantsApp.h"

@interface MUSTopBarForDetailCollectionView()

@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* buttonConstrain;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* labelConstrain;
//@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint* imageViewConstrain;
@property (weak, nonatomic)     IBOutlet    NSLayoutConstraint *showUserProfileButtonTopConstraint;

@property (weak, nonatomic)     IBOutlet    UILabel *lableCountImages;
//@property (weak, nonatomic)     IBOutlet    UIImageView *imageView;
//===
@property (assign, nonatomic) BOOL hideProperties;
@property (strong, nonatomic) UIView *view;

@end

@implementation MUSTopBarForDetailCollectionView

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
    NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"MUSTopBarForDetailCollectionView" owner:self options:nil];
    return [nibObjects firstObject];
}

- (void) awakeFromNib {
   
    
}

- (void) initializeLableCountImages:(NSString *)stringLableCountImages {
    self.lableCountImages.text = stringLableCountImages;
}

- (void) initializeImageView:(NSString *)stringPathImage {
    UIImage *profileImage = [[UIImage alloc] init];
    if (stringPathImage.length > 0) {
        profileImage = [profileImage loadImageFromDataBase: stringPathImage];
        [self.showUserProfileButton setImage: profileImage forState:UIControlStateNormal];
    } else {
        [self.showUserProfileButton setImage: [UIImage imageNamed:musAppButton_ImageName_UnknownUser]  forState:UIControlStateNormal];
    }

    
    
//    [self.imageView loadImageFromDataBase: stringPathImage];
//    [self.imageView cornerRadius: CGRectGetHeight(self.imageView.frame) / 2 andBorderWidth: 1.5 withBorderColor: [UIColor whiteColor]];
}

- (void) hidePropertiesWithAnimation {
    if (!_hideProperties) {
    
            _labelConstrain.constant -= _view.frame.size.height;
            //_imageViewConstrain.constant -=  _view.frame.size.height;
            _showUserProfileButtonTopConstraint.constant -= _view.frame.size.height;
            _buttonConstrain.constant -= _view.frame.size.height;
        
        [UIView animateWithDuration: 0.4  animations:^{
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        }];
        [UIView commitAnimations];
       
    } else  {
        _labelConstrain.constant += _view.frame.size.height;
        //_imageViewConstrain.constant +=  _view.frame.size.height;
        _showUserProfileButtonTopConstraint.constant += _view.frame.size.height;
        _buttonConstrain.constant += _view.frame.size.height;
       
        [UIView animateWithDuration: 0.4  animations:^{
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        }];
        [UIView commitAnimations];
        
    }
    
    _hideProperties = (_hideProperties)? NO : YES;

    
}
- (IBAction)showUserProfileButtonTouch:(id)sender {

}

@end
