//
//  MUSCollectionViewCell.m
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCollectionViewCell.h"
#import "ConstantsApp.h"
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
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationImagePickerForCollection object:nil];
    
}

- (IBAction)deletePhoto:(id)sender {
    [self.delegate deletePhotoBySelectedImageIndex: self.indexPath];
}

@end
