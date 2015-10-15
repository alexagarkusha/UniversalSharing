//
//  ProfileUserTableViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSTopUserProfileCell.h"

#import "UIImageView+RoundImage.h"

@interface MUSTopUserProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLastNameLabel;

@end


@implementation MUSTopUserProfileCell

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) profileUserTableViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void)awakeFromNib {
    [self.userImageView roundImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSTopUserProfileCell cellID];
}

- (void) configurationProfileUserTableViewCell: (MUSUser*) currentUser {
    self.userNameLabel.text = currentUser.firstName;
    self.userLastNameLabel.text = currentUser.lastName;
    NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder:currentUser.photoURL]];
    self.self.userImageView.image = [UIImage imageWithData:data];
}

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}

@end
