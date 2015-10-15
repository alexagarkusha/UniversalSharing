//
//  MUSPhotoManager.m
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPhotoManager.h"
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ConstantsApp.h"
#import "MUSImageToPost.h"
#import "UIImage+Scale.h"

@interface MUSPhotoManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIViewController *viewController;

@end

static MUSPhotoManager* sharedManager = nil;

@implementation MUSPhotoManager

+ (MUSPhotoManager*) sharedManager {
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^ {
        sharedManager = [MUSPhotoManager new];
    });
    return sharedManager;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
    }
    return self;
}

- (void) showPhotoFromViewController :(UIViewController*) viewController withComplition: (Complition) block {
    self.copyComplition = block;
    self.viewController = viewController;
    [self showPhotoAlert];
}

- (void) showPhotoAlert {
    UIAlertView *photoAlert = [[UIAlertView alloc]
                               initWithTitle : MUSApp_MUSPhotoManager_Alert_Title_Share_Photo
                               message : nil
                               delegate : self
                               cancelButtonTitle : MUSApp_Button_Title_Cancel
                               otherButtonTitles : MUSApp_Button_Title_Album, MUSApp_Button_Title_Camera, nil];
    photoAlert.tag = 0;
    [photoAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case Cancel:
            break;
        case Album:
            [self selectPhotoFromAlbum];
            break;
        case Camera:
            [self takePhotoFromCamera];
            break;
            
        default:
            break;
    }
}

- (void) selectPhotoFromAlbum {
    _imagePickerController.delegate = self ;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
    [self.viewController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void) takePhotoFromCamera {    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.copyComplition (nil, [self cameraError]);
    } else {
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO; // If you want to edit photo - you need to set YES
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:_imagePickerController animated: YES completion:nil];
    }
    
}

- (NSError*) cameraError {
    NSError *error = [[NSError alloc] initWithDomain: MUSApp_Error_With_Domain_Universal_Sharing code: MUSApp_MUSPhotoManager_Error_NO_Camera_Code userInfo:@{ NSLocalizedFailureReasonErrorKey: MUSApp_MUSPhotoManager_Error_NO_Camera}];
    return error;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage]; // If you want to show editable photo - you need to set UIImagePickerControllerEditedImage
    
    if (image != nil) {
        MUSImageToPost *imageToPost = [[MUSImageToPost alloc] init];
        UIImage *compressedImage = [UIImage scaleImage: image toSize: CGSizeMake(MUSApp_MUSPhotoManager_CompressionSizePicture_By_Width, MUSApp_MUSPhotoManager_CompressionSizePicture_By_Height)];
        imageToPost.image = compressedImage;
        imageToPost.imageType = MUSJPEG;
        imageToPost.quality = 1.0f;
        self.copyComplition (imageToPost, nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
