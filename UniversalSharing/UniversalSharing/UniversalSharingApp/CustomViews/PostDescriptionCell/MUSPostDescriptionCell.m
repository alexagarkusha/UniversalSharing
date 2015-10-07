//
//  MUSPostDescriptionCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostDescriptionCell.h"
#import "ConstantsApp.h"


@implementation MUSPostDescriptionCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = BROWN_COLOR_Lightly;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSPostDescriptionCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) postDescriptionCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

#pragma mark - height for PostDescriptionCell

+ (CGFloat) heightForPostDescriptionCell : (NSString*) postDescription {
    if (!postDescription.length > 0) {
        return 0;
    }
    UITextView *calculationView = [[UITextView alloc] init];
    NSDictionary *options = @{ NSFontAttributeName: [UIFont
                            fontWithName : musApp_PostDescriptionCell_TextView_Font_Name
                                    size : musApp_PostDescriptionCell_TextView_Font_Size]};
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString : postDescription
                                                                     attributes : options];
    [calculationView setAttributedText : attrString];
    CGSize size = [calculationView sizeThatFits: CGSizeMake ([UIScreen mainScreen].bounds.size.width - musApp_PostDescriptionCell_TextView_LeftConstraint - musApp_PostDescriptionCell_TextView_RightConstraint, FLT_MAX)];
    CGFloat heightOfRow = size.height + musApp_PostDescriptionCell_TextView_BottomConstraint + musApp_PostDescriptionCell_TextView_TopConstraint;
    return heightOfRow;
}

#pragma mark - configuration PostDescriptionCell

- (void) configurationPostDescriptionCell: (NSString*) postDescription {
    [self initialParametersOfTextInTextView: postDescription];
}

#pragma mark initiation Parameters of text in text view

- (void) initialParametersOfTextInTextView : (NSString*) text {
    NSDictionary *options = @{ NSFontAttributeName: [UIFont
                fontWithName : musApp_PostDescriptionCell_TextView_Font_Name
                        size : musApp_PostDescriptionCell_TextView_Font_Size]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString : text
                                                                           attributes : options];
    [self.postDescriptionTextView setAttributedText : attributedString];
}


@end
