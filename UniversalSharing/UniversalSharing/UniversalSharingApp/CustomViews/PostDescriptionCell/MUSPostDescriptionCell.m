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

@property (weak, nonatomic)     IBOutlet   MUSChangeButton    *changeButtonOutlet;
@property (nonatomic, assign)              NetworkType        currentNetworkType;

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
    CGFloat heightOfRow = size.height + musApp_PostDescriptionCell_TextView_BottomConstraint + musApp_PostDescriptionCell_TextView_TopConstraint;
    if (heightOfRow < 100 && isEditableCell) {
        return 100;
    }
    return heightOfRow;
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

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        NSString *rawString = [textView text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        if ([trimmed length] == 0) {
            [self initialPostDescriptionTextView];
            [self.postDescriptionTextView setSelectedRange:NSMakeRange(0, 0)];
            return;
        }
    } else {
        [self initialPostDescriptionTextView];
        [self.postDescriptionTextView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        if (textView.tag == 0 && text.length > 0) {
            [self initialPostDescriptionTextViewWhenStartingEditingText];
        }
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
        [self.delegate endEditingPostDescriptionAndReloadTableView];
    } else {
        [self.delegate endEditingPostDescriptionAndReloadTableView];
    }
    [self.postDescriptionTextView setEditable: NO];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([textView.text isEqualToString: kPlaceholderText] && textView.textColor == [UIColor lightGrayColor]) {
        [self.postDescriptionTextView setSelectedRange:NSMakeRange(0, 0)];
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

- (void) initialPostDescriptionTextViewWhenStartingEditingText {
    self.postDescriptionTextView.text = changePlaceholderWhenStartEditing;
    self.postDescriptionTextView.textColor = [UIColor blackColor];
    self.postDescriptionTextView.tag = 1;
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
    self.postDescriptionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.delegate beginEditingPostDescription: self.currentIndexPath];
    [self.postDescriptionTextView becomeFirstResponder];
    self.postDescriptionTextView.selectedRange = NSMakeRange([self.postDescriptionTextView.text length], 0);
}

@end
