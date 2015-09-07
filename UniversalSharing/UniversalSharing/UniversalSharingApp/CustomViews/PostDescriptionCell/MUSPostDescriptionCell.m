//
//  MUSPostDescriptionCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostDescriptionCell.h"
#import "ConstantsApp.h"
#import "MUSChangeButton.h"

@interface MUSPostDescriptionCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet MUSChangeButton *changeButtonOutlet;
@property (nonatomic, assign) NetworkType currentNetworkType;

@end


@implementation MUSPostDescriptionCell

- (void)awakeFromNib {
    // Initialization code
    self.postDescriptionTextView.delegate = self;
    //self.postDescriptionTextView.editable = NO;
    //self.postDescriptionTextView.scrollEnabled = NO;
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

+ (CGFloat) heightForPostDescriptionCell : (NSString*) postDescription andIsEditableCell : (BOOL) isEditableCell {
    if (!postDescription.length > 0 && !isEditableCell) {
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
    return size.height + musApp_PostDescriptionCell_TextView_BottomConstraint + musApp_PostDescriptionCell_TextView_TopConstraint;

}

#pragma mark - configuration PostDescriptionCell

- (void) configurationPostDescriptionCell: (NSString*) postDescription andNetworkType: (NetworkType) networkType {
    [self checkPostDescriptionStatus];
    self.currentNetworkType = networkType;
    if (![postDescription isEqualToString: changePlaceholderWhenStartEditing] && ![postDescription isEqualToString: kPlaceholderText]) {
        [self initialParametersOfTextInTextView: postDescription];
        self.postDescriptionTextView.tag = 1;
    } else {
        [self initialPostDescriptionTextView];
    }
}

#pragma mark - Check PostDescriptionTextView status

- (void) checkPostDescriptionStatus {
    if (!self.isEditableCell) {
        self.changeButtonOutlet.hidden = YES;
        self.postDescriptionTextView.scrollEnabled = NO;
    } else {
        self.changeButtonOutlet.hidden = NO;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        [self initialParametersOfTextInTextView: changePlaceholderWhenStartEditing];
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        if (self.currentNetworkType != Twitters) {
            return textView.text.length + (text.length - range.length) <= countOfAllowedLettersInTextView;
        } else {
            return textView.text.length + (text.length - range.length) <= musApp_TextView_CountOfAllowedLetters_ForTwitter;
        }
    }
    [textView resignFirstResponder];
    return NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if([textView.text length] == 0) {
        [self initialPostDescriptionTextView];
        [self.delegate saveChangesInPostDescription: textView.text];
    } else {
        [self.delegate saveChangesInPostDescription: textView.text];
    }
    [self.postDescriptionTextView setEditable: NO];
    //self.postDescriptionTextView.selectable = NO;
    //self.postDescriptionTextView.scrollEnabled = NO;
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
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                  initWithString : text
                                      attributes : options];
    [self.postDescriptionTextView setAttributedText : attrString];
    
    if (self.isEditableCell) {
        UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width - 30, 0, 30, 30)];
        [[self.postDescriptionTextView textContainer] setExclusionPaths:@[rectanglePath]];
    }
    
}


- (IBAction)changeButtonTouch:(id)sender {
    self.postDescriptionTextView.editable = YES;
    //self.postDescriptionTextView.scrollEnabled = YES;
    //self.postDescriptionTextView.selectable = YES;
    
    self.postDescriptionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.postDescriptionTextView becomeFirstResponder];
    self.postDescriptionTextView.selectedRange = NSMakeRange([self.postDescriptionTextView.text length], 0);
    [self.delegate beginEditingPostDescription: self.currentIndexPath];
}

@end
