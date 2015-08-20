//
//  MUSPostDescriptionCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostDescriptionCell.h"

@interface MUSPostDescriptionCell ()


@property (weak, nonatomic) IBOutlet UITextView *postDescriptionTextView;

@end


@implementation MUSPostDescriptionCell

- (void)awakeFromNib {
    // Initialization code
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

- (void) configurationPostDescriptionCellByPost: (Post*) currentPost {
    
    self.postDescriptionTextView.text = currentPost.postDescription;
    CGFloat width = self.postDescriptionTextView.bounds.size.width - 2.0 * self.postDescriptionTextView.textContainer.lineFragmentPadding;
    
    NSDictionary *options = @{ NSFontAttributeName: self.postDescriptionTextView.font };
    CGRect boundingRect = [self.postDescriptionTextView.text
                           boundingRectWithSize : CGSizeMake(width, NSIntegerMax)
                                        options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes : options context:nil];
    self.postDescriptionTextView.frame = CGRectMake(self.postDescriptionTextView.frame.origin.x, self.postDescriptionTextView.frame.origin.y, self.postDescriptionTextView.frame.size.width, boundingRect.size.height + 15);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.postDescriptionTextView.frame.origin.y + self.postDescriptionTextView.frame.size.height + 4);
    
    [self.delegate heightOfPostDescriptionRow : self.frame.size.height];

}


@end
