//
//  MUSPostDescriptionCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostDescriptionCell.h"
#import "ConstantsApp.h"

@interface MUSPostDescriptionCell () <UITextViewDelegate>

@end


@implementation MUSPostDescriptionCell

- (void)awakeFromNib {
    // Initialization code
    self.postDescriptionTextView.delegate = self;
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
    UITextView *calculationView = [[UITextView alloc] init];
    NSDictionary *options = @{ NSFontAttributeName: [UIFont
                            fontWithName : musApp_PostDescriptionCell_TextView_Font_Name
                                    size : musApp_PostDescriptionCell_TextView_Font_Size]};
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString : postDescription
                                                                     attributes : options];
    [calculationView setAttributedText : attrString];
    CGSize size = [calculationView sizeThatFits: CGSizeMake ([UIScreen mainScreen].bounds.size.width - musApp_PostDescriptionCell_TextView_LeftConstraint - musApp_PostDescriptionCell_TextView_RightConstraint, FLT_MAX)];
    return size.height + musApp_PostDescriptionCell_TextView_BottomConstraint + musApp_PostDescriptionCell_TextView_TopConstraint;

}

#pragma mark - configuration PostDescriptionCell

- (void) configurationPostDescriptionCell: (NSString*) postDescription {
    [self checkPostDescriptionTextViewStatus];
    
    if (![postDescription isEqualToString: changePlaceholderWhenStartEditing] && ![postDescription isEqualToString: kPlaceholderText]) {
        [self initialParametersOfTextInTextView: postDescription];
        self.postDescriptionTextView.tag = 1;
    } else {
        [self initialPostDescriptionTextView];
    }
}

#pragma mark - Check PostDescriptionTextView status

- (void) checkPostDescriptionTextViewStatus {
    if (!self.isEditableCell) {
        self.postDescriptionTextView.editable = NO;
        self.postDescriptionTextView.scrollEnabled = NO;
    } else {
        self.postDescriptionTextView.editable = YES;
        self.postDescriptionTextView.scrollEnabled = YES;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        [self initialParametersOfTextInTextView: changePlaceholderWhenStartEditing];
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    [self.delegate beginEditingPostDescription: self.currentIndexPath];    
    return YES;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    [txtView resignFirstResponder];
    return NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text length] == 0) {
        [self initialPostDescriptionTextView];
        [self.delegate saveChangesInPostDescription: textView.text];
    } else {
        [self.delegate saveChangesInPostDescription: textView.text];
    }
}

#pragma mark initiation PostDescriptionTextView

- (void) initialPostDescriptionTextView {
    self.postDescriptionTextView.tag = 0;
    [self initialParametersOfTextInTextView: kPlaceholderText];
    self.postDescriptionTextView.textColor = [UIColor lightGrayColor];
}

#pragma mark initiation Parameters of text in text view

- (void) initialParametersOfTextInTextView : (NSString*) text {
    NSDictionary *options = @{ NSFontAttributeName: [UIFont
                                fontWithName : musApp_PostDescriptionCell_TextView_Font_Name
                                        size : musApp_PostDescriptionCell_TextView_Font_Size]};
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString : text
                                                                     attributes : options];
    [self.postDescriptionTextView setAttributedText : attrString];
}

@end
