//
//  GeneralUserInfoTableViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSUserProfileCell.h"

@interface MUSUserProfileCell ()

@property (weak, nonatomic) IBOutlet UILabel *userPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPropertyInfoLabel;

@end


@implementation MUSUserProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSUserProfileCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) generalUserInfoTableViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void) configurationGeneralUserInfoTableViewCellWithUser: (User*) currentUser andCurrentProperty : (NSString*) userProperty {
    
    self.userPropertyLabel.text = userProperty;
    NSString *userPropertyInfoString = [currentUser valueForKey:userProperty];
    
    if ([userProperty isEqualToString:@"dateOfBirth"]) {
        self.userPropertyLabel.text = @"Date of birthday";
    }
    
    if (userPropertyInfoString.length > 0) {
        self.userPropertyInfoLabel.text = userPropertyInfoString;
    } else {
        self.userPropertyInfoLabel.text = @"?";
    }
    
    [self.userPropertyLabel sizeToFit];
    [self.userPropertyInfoLabel sizeToFit];
}




@end
