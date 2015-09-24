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

@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeNameLabelRightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *deletePlaceFromPostButton;

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
    CGFloat widthValue = ([UIScreen mainScreen].bounds.size.width / 3) * 2 - musAppLocationCell_LeftConstraintOfLabel - musAppLocationCell_RightConstraintOfLabel;
    if (place.isChosen) {
        widthValue -= musAppLocationCell_RightConstraintOfLabelWithDeletePlaceButton;
    }
        CGFloat result = font.pointSize;
        if (place.fullName)
        {
            CGSize size;
            CGRect frame = [place.fullName boundingRectWithSize:CGSizeMake(widthValue, 999)
                                        options : NSStringDrawingUsesLineFragmentOrigin
                                     attributes : @{NSFontAttributeName:font}
                                        context : nil];
            //NSLog(@"width = %f, height =%f", frame.size.width, frame.size.height);
            size = CGSizeMake(frame.size.width, frame.size.height);
            result = MAX(size.height, result); //At least one row
        }
    result += musAppLocationCell_LeftConstraintOfLabel + musAppLocationCell_RightConstraintOfLabel;
    return result;
}

+ (UIFont*) fontForCell {
    return [UIFont systemFontOfSize: 16.0];
}


- (void) configurationLocationCell: (Place*) currentPlace {
    if (currentPlace.isChosen) {
        self.placeNameLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.placeNameLabel.textColor = [UIColor blackColor];
        self.deletePlaceFromPostButton.hidden = YES;
        self.placeNameLabelRightConstraint.constant = 0;
    }
    self.placeNameLabel.text = currentPlace.fullName;
    self.placeNameLabel.numberOfLines = 0;
    self.placeNameLabel.font = [MUSLocationCell fontForCell];
}

- (void) initiationButtonDeletePlaceFromPost {
    [self.deletePlaceFromPostButton cornerRadius: self.deletePlaceFromPostButton.frame.size.height / 2];
    [self.deletePlaceFromPostButton setImage: [UIImage imageNamed: musAppButton_ImageName_ButtonDeleteLocation] forState:UIControlStateNormal];
    [self.deletePlaceFromPostButton addTarget:self action:@selector(deletePlaceFromPost:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) deletePlaceFromPost : (UIButton*) sender {
    [self.delegate deleteChosenPlaceFromTableViewAndMap];
}


@end
