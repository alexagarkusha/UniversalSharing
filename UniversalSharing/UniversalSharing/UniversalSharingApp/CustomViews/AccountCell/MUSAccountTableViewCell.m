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

@interface MUSAccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *networkIconImageView;
@property (weak, nonatomic) IBOutlet UIView *viewAccountTableCell;

@end


@implementation MUSAccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.networkIconImageView roundImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSAccountTableViewCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) accountTableViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void) configurateCellForNetwork:(SocialNetwork *)socialNetwork {    
    if (socialNetwork.isLogin) {
        __weak MUSAccountTableViewCell *weakSelf = self;
        [socialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
            [weakSelf.networkIconImageView loadImageFromUrl:[NSURL URLWithString:socialNetwork.icon]];
            weakSelf.loginLabel.text = socialNetwork.title;
            
        }];
    }
    else {
        self.networkIconImageView.image = [UIImage imageNamed:socialNetwork.icon];
        self.loginLabel.text = socialNetwork.title;
    }
    
    if (socialNetwork.isVisible) {
        self.viewAccountTableCell.backgroundColor = [UIColor grayColor];
    } else {
        self.viewAccountTableCell.backgroundColor = [UIColor whiteColor];
    }
}

- (void) changeColorOfCell :(SocialNetwork *)socialNetwork {
    if (!socialNetwork.isVisible) {
        socialNetwork.isVisible = YES;
    } else {
        socialNetwork.isVisible = NO;
    }
}
@end
