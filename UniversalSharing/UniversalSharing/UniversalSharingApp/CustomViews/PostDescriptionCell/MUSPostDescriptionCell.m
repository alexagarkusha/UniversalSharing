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

+ (CGFloat) heightForPostDescriptionCell : (NSString*) postDescription {

    UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(8, 8, [UIScreen mainScreen].bounds.size.width - 8, 50)];
                            
    
    textView.text = postDescription;
    
    CGFloat width = textView.bounds.size.width - 2.0 * textView.textContainer.lineFragmentPadding;
    
    NSDictionary *options = @{ NSFontAttributeName: [UIFont fontWithName: @"Times New Roman" size: 17]};
    CGRect boundingRect = [textView.text
                           boundingRectWithSize : CGSizeMake(width, NSIntegerMax)
                           options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes : options context:nil];
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, boundingRect.size.height);
    
    CGRect frame = CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.width, textView.frame.origin.y + textView.frame.size.height + 16);
    
    return frame.size.height;
}

- (void) configurationPostDescriptionCell: (NSString*) postDescription {
    [self checkpostDescriptionTextViewStatus];
    if (![postDescription isEqualToString: changePlaceholderWhenStartEditing] && ![postDescription isEqualToString: kPlaceholderText]) {
        self.postDescriptionTextView.text = postDescription;
        self.postDescriptionTextView.tag = 1;
    } else {
        [self initialPostDescriptionTextView];
    }
}

- (void) checkpostDescriptionTextViewStatus {
    if (!self.isEditableCell) {
        self.postDescriptionTextView.editable = NO;
    } else {
        self.postDescriptionTextView.editable = YES;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        textView.text = changePlaceholderWhenStartEditing;
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

- (void) initialPostDescriptionTextView {
    self.postDescriptionTextView.editable = YES;
    self.postDescriptionTextView.scrollEnabled = YES;
    self.postDescriptionTextView.delegate = self;
    self.postDescriptionTextView.textColor = [UIColor lightGrayColor];
    self.postDescriptionTextView.tag = 0;
    self.postDescriptionTextView.text = kPlaceholderText;
}


@end
