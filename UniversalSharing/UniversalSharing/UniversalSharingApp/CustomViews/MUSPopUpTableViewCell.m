//
//  MUSPopUpTableViewCell.m
//  UniversalSharing
//
//  Created by Roman on 9/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPopUpTableViewCell.h"

@interface MUSPopUpTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNetwork;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation MUSPopUpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //[self.userImageView roundImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSPopUpTableViewCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) popUpTableViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void) configurationProfileUserTableViewCellWith: (SocialNetwork*) socialNetwork {
    self.imageViewNetwork.image = [UIImage imageNamed:socialNetwork.icon];
    self.switchButton.tag = socialNetwork.networkType;
    if (!socialNetwork.isLogin) {
        [self.switchButton setOn:NO animated:YES];
        self.switchButton.enabled = NO;
        self.switchButton.backgroundColor = [UIColor whiteColor];
        self.switchButton.layer.cornerRadius = 16.0;
    } else{
        
        [self.switchButton setOn:YES animated:YES];
        self.switchButton.enabled = YES;
    }
}
- (IBAction)switchEvent:(UISwitch*)sender {
    if (!sender.isOn) {
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.cornerRadius = 16.0;       
    }
    [self.delegate setChangeSwitchButtonWithValue:sender.isOn andKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}

@end
