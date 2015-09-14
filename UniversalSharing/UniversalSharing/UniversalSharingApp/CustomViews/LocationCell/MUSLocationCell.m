//
//  MUSLocationCell.m
//  UniversalSharing
//
//  Created by U 2 on 11.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSLocationCell.h"
#import "UIButton+CornerRadiusButton.h"
#import "ConstantsApp.h"

@interface MUSLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelPlaceName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelPlaceNameRightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *buttonOutletDeletePlaceFromPost;

@end


@implementation MUSLocationCell

- (void)awakeFromNib {
    [self initiationButtonDeletePlaceFromPost];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier{
    return [MUSLocationCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) locationCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self reuseIdentifier] owner:nil options:nil];
    return nibArray[0];
}

+ (CGFloat) heightForLocationCell: (Place *) place {
    UIFont *font = [MUSLocationCell fontForCell];
    CGFloat widthValue = ([UIScreen mainScreen].bounds.size.width / 3) * 2 - 20;
    if (place.isChosen) {
        widthValue -= 36;
    }
        CGFloat result = font.pointSize;
        if (place.fullName)
        {
            CGSize size;
            CGRect frame = [place.fullName boundingRectWithSize:CGSizeMake(widthValue, 999)
                                        options : NSStringDrawingUsesLineFragmentOrigin
                                     attributes : @{NSFontAttributeName:font}
                                        context : nil];
            size = CGSizeMake(frame.size.width, frame.size.height);
            result = MAX(size.height, result); //At least one row
        }
    return result + 20;
}

+ (UIFont*) fontForCell {
    return [UIFont systemFontOfSize: 16.0];
}


- (void) configurationLocationCell: (Place*) currentPlace {
    if (currentPlace.isChosen) {
        self.labelPlaceName.textColor = [UIColor lightGrayColor];
    } else {
        self.labelPlaceName.textColor = [UIColor blackColor];
        self.buttonOutletDeletePlaceFromPost.hidden = YES;
        self.labelPlaceNameRightConstraint.constant = 0;
    }
    self.labelPlaceName.text = currentPlace.fullName;
    self.labelPlaceName.numberOfLines = 0;
    self.labelPlaceName.font = [MUSLocationCell fontForCell];
}

- (void) initiationButtonDeletePlaceFromPost {
    [self.buttonOutletDeletePlaceFromPost cornerRadius: self.buttonOutletDeletePlaceFromPost.frame.size.height / 2];
    [self.buttonOutletDeletePlaceFromPost setImage: [UIImage imageNamed: musAppButton_ImageName_ButtonDeleteLocation] forState:UIControlStateNormal];
    [self.buttonOutletDeletePlaceFromPost addTarget:self action:@selector(deletePlaceFromPost:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) deletePlaceFromPost : (UIButton*) sender {
    [self.delegate deleteChosenPlaceFromTableViewAndMap];
}


@end
