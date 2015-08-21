//
//  MUSGalleryOfPhotosCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSGalleryOfPhotosCell.h"
#import "MUSCollectionViewCell.h"
#import "ConstantsApp.h"
#import "UIImageView+LoadImageFromNetwork.h"
#import "UIButton+MUSEditableButton.h"
#import "MUSPhotoManager.h"
#import "MUSGalleryViewOfPhotos.h"

@interface MUSGalleryOfPhotosCell () <MUSGalleryViewOfPhotosDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfPostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;

@property (strong, nonatomic) NSString *postDateCreate;
@property (strong, nonatomic)  NSMutableArray *arrayWithImages;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButtonOutlet;
@property (assign, nonatomic) BOOL isEditableGallery;
@property (weak, nonatomic) IBOutlet MUSGalleryViewOfPhotos *galleryViewOfPhotos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonButtomConstraint;

//@property (assign, nonatomic) CGFloat heightOfRow;

//@property (strong, nonatomic) MUSGalleryViewOfPhotos *galleryViewOfPhotos;

- (IBAction)addPhotoTouch:(id)sender;

@end


@implementation MUSGalleryOfPhotosCell

- (void)awakeFromNib {
    // Initialization code
    //self.galleryViewOfPhotos = [[MUSGalleryViewOfPhotos alloc] init];
    [self.addPhotoButtonOutlet editableButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSGalleryOfPhotosCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) galleryOfPhotosCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

+ (CGFloat) heightForGalleryOfPhotosCell : (NSInteger) countOfImages {
    CGFloat heightOfRow;
    if (countOfImages > 0) {
        return heightOfRow = 150;
    } else {
        return heightOfRow = 70;
    }
}

- (void) configurationGalleryOfPhotosCellByArrayOfImages: (NSMutableArray*) arrayOfImages andDateCreate : (NSString*) postDateCreate andUser : (User*) user {
    [self checkGalleryOfPhotosStatus];
    self.postDateCreate = postDateCreate;
    
    self.currentUser = user;
    self.arrayWithImages = [NSMutableArray arrayWithArray: arrayOfImages];
    
    [self initiationAddButton];
    [self initiationGalleryViewOfPhotos];
    [self initiationGalleryOfPhotosCell];
}

#pragma mark initiation HeightOfRow

- (void) initiationAddButton {
    if (self.arrayWithImages.count > 0) {
        self.addButtonButtomConstraint.constant = 50;
    } else {
        self.addButtonButtomConstraint.constant = 15;
    }
}

#pragma mark initiation GalleryViewOfPhotos

- (void) initiationGalleryViewOfPhotos { /////////// ERROR //////
    
        NSLog(@"Gallery view 1 x =%f, y=%f, w =%f, h=%f", self.galleryViewOfPhotos.frame.origin.x,
          self.galleryViewOfPhotos.frame.origin.y, self.galleryViewOfPhotos.frame.size.width, self.galleryViewOfPhotos.frame.size.height);
        NSLog(@"Gallery collection view 1 x =%f, y=%f, w =%f, h=%f", self.galleryViewOfPhotos.collectionView.frame.origin.x,
          self.galleryViewOfPhotos.collectionView.frame.origin.y, self.galleryViewOfPhotos.collectionView.frame.size.width, self.galleryViewOfPhotos.collectionView.frame.size.height);
        //self.galleryViewOfPhotos.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
        //self.galleryViewOfPhotos.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    
        self.galleryViewOfPhotos.delegate = self;
        self.galleryViewOfPhotos.collectionView.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 251.0/255.0 blue: 241.0/255.0 alpha: 1.0];
        self.galleryViewOfPhotos.arrayOfPhotos = [NSMutableArray arrayWithArray: self.arrayWithImages];
    
        [self.galleryViewOfPhotos isVisiblePageControl : YES];
        [self.galleryViewOfPhotos.collectionView reloadData];
}

#pragma mark initiation GalleryOfPhotosCell 

- (void) initiationGalleryOfPhotosCell {
    if (self.arrayWithImages.count > 0) {
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.dateOfPostLabel.textColor = [UIColor whiteColor];
    } else {
        self.usernameLabel.textColor = [UIColor blackColor];
        self.dateOfPostLabel.textColor = [UIColor blackColor];
    }
    
    self.usernameLabel.text = [NSString stringWithFormat: @"%@ %@", self.currentUser.lastName, self.currentUser.firstName];
    //self.usernameLabel.text = self.currentUser.username;
    self.dateOfPostLabel.text = [self timeInDoubleFormatte: [self.postDateCreate integerValue]];
    
    [self.userPhotoImageView loadImageFromUrl: [NSURL URLWithString: self.currentUser.photoURL]];
    [self.usernameLabel sizeToFit];
    [self.dateOfPostLabel sizeToFit];
}


- (NSString*) timeInDoubleFormatte: (double) dateInDouble {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInDouble];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateStr = [formatDate stringFromDate:date];
    return dateStr;
}


#pragma mark - UIButton

- (IBAction)addPhotoTouch:(id)sender {
    [self.delegate showImagePicker];
}

- (void) checkGalleryOfPhotosStatus {
    if (!self.isEditableCell) {
        self.addPhotoButtonOutlet.hidden = YES;
        self.galleryViewOfPhotos.isEditableGallery = NO;
    } else {
        self.addPhotoButtonOutlet.hidden = NO;
        self.galleryViewOfPhotos.isEditableGallery = YES;
    }
}

#pragma mark - MUSGalleryViewOfPhotosDelegate

- (void) arrayOfPhotos:(NSArray *)arrayOfPhotos {
    [self.delegate arrayOfImagesOfUser: arrayOfPhotos];
}


@end
