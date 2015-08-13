//
//  LoginTableViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSAccountTableViewCell.h"
#import "UIImageView+RoundImage.h"
#import "UIImageView+LoadImageFromNetwork.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MUSAccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *networkIconImageView;
@property (weak, nonatomic) IBOutlet UIView *viewAccountTableCell;
@end


@implementation MUSAccountTableViewCell


+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) accountTableViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void)awakeFromNib {
    [self.networkIconImageView roundImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSAccountTableViewCell cellID];
}

- (void) configurateCellForNetwork:(SocialNetwork *)socialNetwork {
    
    if (socialNetwork.isLogin && !socialNetwork.isVisible) {
        __weak MUSAccountTableViewCell *weakSelf = self;
        [socialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
            [weakSelf.networkIconImageView loadImageFromUrl:[NSURL URLWithString:socialNetwork.icon]];
            weakSelf.loginLabel.text = socialNetwork.title;
            self.loginLabel.textColor = [UIColor blackColor];
        }];
    } else if(socialNetwork.isLogin && socialNetwork.isVisible){
        __weak MUSAccountTableViewCell *weakSelf = self;
        [socialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
            //UIImage * image = [UIImage l]
            [weakSelf.networkIconImageView  loadImageFromUrl:[NSURL URLWithString:socialNetwork.icon]];
            self.networkIconImageView.image = [self translucentImageFromImage:self.networkIconImageView.image withAlpha:0.3f];
            weakSelf.loginLabel.text = socialNetwork.title;
            self.loginLabel.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3f];
        }];
    }
    else {
        self.networkIconImageView.image = [UIImage imageNamed:socialNetwork.icon];
        self.loginLabel.text = socialNetwork.title;
        self.loginLabel.textColor = [UIColor blackColor];
    }
    
//    if (socialNetwork.isVisible) {
//        //self.viewAccountTableCell.backgroundColor = [UIColor grayColor];
//        self.loginLabel.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3f];;
//        self.networkIconImageView.image = [self translucentImageFromImage:self.networkIconImageView.image withAlpha:0.5f];
//        //self.networkIconImageView.image =
//
//    } else {
//        //self.viewAccountTableCell.backgroundColor = [UIColor whiteColor];
//        self.loginLabel.textColor = [UIColor blackColor];
//    }
   
}

- (void) changeColorOfCell :(SocialNetwork *)socialNetwork {
    if (!socialNetwork.isVisible) {
        socialNetwork.isVisible = YES;
    } else {
        socialNetwork.isVisible = NO;
    }
}

- (UIImage *)translucentImageFromImage:(UIImage *)image withAlpha:(CGFloat)alpha
{
    CGRect rect = CGRectZero;
    rect.size = image.size;
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:rect blendMode:kCGBlendModeScreen alpha:alpha];
    UIImage * translucentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return translucentImage;
}






@end

