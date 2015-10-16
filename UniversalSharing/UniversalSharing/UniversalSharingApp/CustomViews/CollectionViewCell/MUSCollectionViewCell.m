//
//  MUSCollectionViewCell.m
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCollectionViewCell.h"
#import "MUSConstantsApp.h"
#import "MUSAddPhotoButton.h"

@interface MUSCollectionViewCell()

@property (strong, nonatomic) MUSAddPhotoButton *addPhotoButton;
@property (strong, nonatomic) MUSAddPhotoButton *addPhotoButtonForFirstSection;
//===
- (IBAction)deletePhoto:(id)sender;

@end

@implementation MUSCollectionViewCell

+ (NSString*) customCellID {
    return NSStringFromClass([MUSCollectionViewCell class]);
}

+ (instancetype) musCollectionViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self customCellID] owner:nil options:nil];
    return nibArray[0];
}

- (NSString *)reuseIdentifier{
    return [MUSCollectionViewCell customCellID];
}

- (void) configurationCellWithPhoto:(UIImage *)photoImageView andEditableState: (BOOL)isEditable {
    [self.addPhotoButton removeFromSuperview];
    [self.addPhotoButtonForFirstSection removeFromSuperview];
    
    if (!photoImageView && isEditable) {
        [self hideDeleteButton];
        self.photoImageViewCell.hidden = YES;
        [self showAddPhotoButton];
    } else if (photoImageView && isEditable) {
        [self showDeleteButton];
        self.photoImageViewCell.hidden = NO;
        self.photoImageViewCell.image = photoImageView;
    } else {
        [self hideDeleteButton];
        self.photoImageViewCell.image = photoImageView;
    }
}

- (void) configurationCellForFirstSection {
    [self.addPhotoButtonForFirstSection removeFromSuperview];
    [self hideDeleteButton];
    self.photoImageViewCell.hidden = YES;
    [self showAddPhotoButtonForFirstSection];
    
}

- (void) showAddPhotoButtonForFirstSection {
    self.addPhotoButtonForFirstSection = [[MUSAddPhotoButton alloc] initWithFrame: CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview: self.addPhotoButtonForFirstSection];
    [self.addPhotoButtonForFirstSection addTarget:self
                                           action:@selector(addPhotoToCollectionForFirstSection:)forControlEvents:UIControlEventTouchUpInside];
}

- (void) showAddPhotoButton {
    self.addPhotoButton = [[MUSAddPhotoButton alloc] initWithFrame: CGRectMake( 50, 20, self.frame.size.width - 100, self.frame.size.height - 40)];
    [self addSubview: self.addPhotoButton];
    [self.addPhotoButton addTarget:self
                            action:@selector(addPhotoToCollectionTouch:)forControlEvents:UIControlEventTouchUpInside];
}

- (void) hideDeleteButton {
    self.deletePhotoButtonOutlet.hidden = YES;
}

- (void) showDeleteButton {
    self.deletePhotoButtonOutlet.hidden = NO;
}

- (void)addPhotoToCollectionTouch:(id)sender {
    [self.delegate addPhotoToCollection];
}

- (void)addPhotoToCollectionForFirstSection:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSShowImagePickerForAddImageInCollectionView object:nil];
}

- (IBAction)deletePhoto:(id)sender {
    [self.delegate deletePhotoBySelectedImageIndex: self.indexPath];
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
=======
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationImagePickerForCollection object:nil];
>>>>>>> 5aba6b074a89608b7bd9b2f4506418c85f9fccf9
    
}

*/

@end
