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
#import "UIButton+MUSAddPhotoButton.h"
#import "MUSAddPhotoButton.h"

@interface MUSCollectionViewCell()

- (IBAction)deletePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButtonOutlet;

@end
@implementation MUSCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
#warning need to do custom button
/////////// Start ////////////////
//    UIImage *deleteIconImage = [UIImage imageNamed: @"btn-close@2x.png"];
//    
//    float width = deleteIconImage.size.width + 20; // new width
//    float height = deleteIconImage.size.height + 20; // new height
//    
//    CGRect rect = CGRectMake(0, 0, width, height);
//
//    UIGraphicsBeginImageContext(rect.size);
//    rect.origin.y = 2;
//    rect.origin.x = 2;
//    rect.size.height = height - 4;
//    rect.size.width = width - 4;
//    [deleteIconImage drawInRect: rect];
//    deleteIconImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    //self.deletePhotoButtonOutlet.hidden = YES;
//    self.deletePhotoButtonOutlet.layer.masksToBounds = YES;
//    self.deletePhotoButtonOutlet.tintColor = [UIColor whiteColor];
//    
//    [self.deletePhotoButtonOutlet setImage: deleteIconImage forState:UIControlStateNormal];
//    self.deletePhotoButtonOutlet.imageEdgeInsets = UIEdgeInsetsMake(3, self.deletePhotoButtonOutlet.frame.size.height / 2, self.deletePhotoButtonOutlet.frame.size.height / 2, 3);
//    self.deletePhotoButtonOutlet.imageView.backgroundColor = [UIColor grayColor];
//    self.deletePhotoButtonOutlet.imageView.alpha = 0.6f;
//    [self.deletePhotoButtonOutlet.imageView cornerRadius: 5.0f andBorderWidth: 1.0f withBorderColor:[UIColor darkGrayColor]];
//    [self.deletePhotoButtonOutlet.imageView setContentMode : UIViewContentModeScaleAspectFit];
    /////////// END ////////////////
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

//<<<<<<< HEAD
- (void) configurationCellWithPhoto:(UIImage *)photoImageView andEditableState: (BOOL)isEditable {
    self.photoImageViewCell.alpha = 1;
    //self.deleteIconImageView.alpha = 1;
    
    if (!photoImageView && isEditable) {
        [self hideDeleteButton];
        self.photoImageViewCell.hidden = YES;
        [self showAddPhotoButton];
        //self.addPhotoToCollectionOutlet.hidden = NO;
    } else if (photoImageView && isEditable) {
        [self showDeleteButton];
        self.photoImageViewCell.hidden = NO;
        //[self showAddPhotoButton];
        //self.addPhotoToCollectionOutlet.hidden = YES;
        self.photoImageViewCell.image = photoImageView;
    } else {
        [self hideDeleteButton];
        self.photoImageViewCell.image = photoImageView;
    }
}

- (void) showAddPhotoButton {
   
    MUSAddPhotoButton *addPhotoButton = [[MUSAddPhotoButton alloc] initWithFrame: CGRectMake( 50, 20, self.frame.size.width - 100, self.frame.size.height - 70)];
    [self addSubview: addPhotoButton];
    [addPhotoButton addTarget:self
               action:@selector(addPhotoToCollectionTouch:)forControlEvents:UIControlEventTouchUpInside];

}


- (void) hideDeleteButton {
    self.deletePhotoButtonOutlet.hidden = YES;
}

- (void) showDeleteButton {
    self.deletePhotoButtonOutlet.hidden = NO;
//=======
//- (void) configurationCellWithPhoto: (UIImage*) photoImageView {
//    self.photoImageViewCell.alpha = 1;
//     self.deleteIconImageView.alpha = 1;
//    self.photoImageViewCell.image = photoImageView;
//>>>>>>> d7110c7994ff5a4e92ad4ce34f8737fdb345df2e
}


- (IBAction)deletePhoto:(id)sender {
    [self.delegate deletePhoto: self.indexPath];
}


- (IBAction)addPhotoToCollectionTouch:(id)sender {
    [self.delegate addPhotoToCollection];
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
