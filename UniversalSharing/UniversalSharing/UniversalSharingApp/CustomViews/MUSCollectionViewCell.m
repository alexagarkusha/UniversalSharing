//
//  MUSCollectionViewCell.m
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCollectionViewCell.h"
#import "UIImageView+CornerRadiusBorderWidthAndBorderColorImageView.h"
#import "ConstantsApp.h"
@interface MUSCollectionViewCell()

- (IBAction)deletePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *deleteIconBackgroungImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButtonOutlet;

@end
@implementation MUSCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.deleteIconImageView.image = [UIImage imageNamed: @"btn-close@2x.png"];
    [self.deleteIconBackgroungImageView cornerRadius: 5.0f andBorderWidth: 1.0f withBorderColor:[UIColor darkGrayColor]];
    self.deleteIconBackgroungImageView.backgroundColor = [UIColor grayColor];
    self.deleteIconBackgroungImageView.alpha = 0.6f;
    [self.photoImageViewCell cornerRadius: 5.0f andBorderWidth: 2.0 withBorderColor: YELLOW_COLOR_Light];
}

- (NSString *)reuseIdentifier{
    return [MUSCollectionViewCell customCellID];
}

+ (NSString*) customCellID {
    return NSStringFromClass([MUSCollectionViewCell class]);
}

+ (instancetype) musCollectionViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self customCellID] owner:nil options:nil];
    return nibArray[0];
}

- (void) configurationCellWithPhoto: (UIImage*) photoImageView {
    self.photoImageViewCell.alpha = 1;
     self.deleteIconImageView.alpha = 1;
    self.photoImageViewCell.image = photoImageView;
}

- (IBAction)deletePhoto:(id)sender {
//    if (self.isEditable) {
        [self.delegate deletePhoto: self.indexPath];
//    }
}


/*
 - (void) editableCellConfiguration {
    self.deleteIconImageView.hidden = NO;
    self.deletePhotoButtonOutlet.hidden = NO;
    self.deleteIconBackgroungImageView.hidden = NO;
    [self startQuivering];
 }
 
 - (void) notEditableCellConfiguration {
    [self stopQuivering];
    self.deleteIconImageView.hidden = YES;
    self.deletePhotoButtonOutlet.hidden = YES;
    self.deleteIconBackgroungImageView.hidden = YES;
 }

 - (void) startQuivering {
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    float startAngle = (-4) * M_PI/180.0;
    float stopAngle = -startAngle;
    quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration = 0.2;
    quiverAnim.repeatCount = HUGE_VALF;
    float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset = timeOffset;
    CALayer *layerDeleteIconIV = self.deleteIconImageView.layer;
    CALayer *layerDeleteIconBackgroundIV = self.deleteIconBackgroungImageView.layer;
    
    [layerDeleteIconIV addAnimation:quiverAnim forKey:@"quivering"];
    [layerDeleteIconBackgroundIV addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering {
    CALayer *layer = self.layer;
    [layer removeAnimationForKey:@"quivering"];
}
*/
@end
