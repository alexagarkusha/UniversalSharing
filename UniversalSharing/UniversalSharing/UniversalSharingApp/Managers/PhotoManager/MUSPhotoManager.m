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
#import "ImageToPost.h"


@interface MUSPhotoManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIViewController *viewController;
@end

static MUSPhotoManager* sharedManager = nil;
@implementation MUSPhotoManager

//#warning "init UIImagePickerController just ones in shareManager"

+ (MUSPhotoManager*) sharedManager {
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^
                   {
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

- (void) photoShowFromViewController :(UIViewController*) viewController withComplition: (Complition) block {
    self.copyComplition = block;
    self.viewController = viewController;
    [self photoAlertShow];
}

- (void) photoAlertShow {
    UIAlertView *photoAlert = [[UIAlertView alloc] initWithTitle:@"Share photo" message: nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Album", @"Camera", nil];
    photoAlert.tag = 0;
    [photoAlert show];
}

- (void) warningNotAddMorePicsAlertShow {
    UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"You can not add pics anymore :[" message: nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    warningAlert.tag = 2;
    [warningAlert show];
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
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:_imagePickerController animated:YES completion:nil];
    }

}

#warning "Replace strings and code to Constants"
- (NSError*) cameraError {
    NSError *error = [[NSError alloc] initWithDomain:@"Universal Sharing" code: 1000 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Device has no camera"}];
    return error;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    if (image != nil) {
        ImageToPost *imageToPost = [[ImageToPost alloc] init];
        imageToPost.image = image;
        imageToPost.imageType = JPEG;
        imageToPost.quality = 0.8f;
        self.copyComplition (imageToPost, nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
