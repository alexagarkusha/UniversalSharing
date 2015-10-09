//
//  LoginTableViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSAccountTableViewCell.h"
#import "DataBaseManager.h"
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSAccountTableViewCell cellID];
}
- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}
- (void) configurateCellForNetwork:(SocialNetwork *)socialNetwork {
        self.networkIconImageView.image = [UIImage imageNamed:socialNetwork.icon];
        self.loginLabel.text = socialNetwork.title;
        self.loginLabel.textColor = [UIColor blackColor];
}


- (UIImage *)translucentImageFromImage:(UIImage *)image withAlpha:(CGFloat)alpha {
    CGRect rect = CGRectZero;
    rect.size = image.size;
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:rect blendMode:kCGBlendModeScreen alpha:alpha];
    UIImage * translucentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return translucentImage;
}

@end

