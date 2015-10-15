//
//  LoginTableViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSAccountTableViewCell.h"
#import "MUSDataBaseManager.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSAccountTableViewCell cellID];
}

- (void) configurateCellForNetwork:(MUSSocialNetwork *)socialNetwork {
    self.networkIconImageView.image = [UIImage imageNamed:socialNetwork.icon];
    self.loginLabel.text = socialNetwork.title;
    self.loginLabel.textColor = [UIColor blackColor];
}

@end

