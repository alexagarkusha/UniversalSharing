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



@interface MUSPhotoManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy, nonatomic)    ComplitionPhoto     copyComplition;

@end

@implementation MUSPhotoManager

#warning "init UIImagePickerController just ones in shareManager"

+ (MUSPhotoManager*) sharedManager {
    static MUSPhotoManager* sharedManager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^
                   {
                       sharedManager = [MUSPhotoManager new];
                   });
    return sharedManager;
}

- (UIViewController*) viewConterollerForImagePickerController {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *viewController=[window rootViewController];
    if(viewController.presentedViewController)
        return viewController.presentedViewController;
    else
        return viewController;
}


- (void) selectPhotoFromAlbumFromViewController : (UIViewController*) viewController withComplition: (ComplitionPhoto) block{
    self.copyComplition = block;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) takePhotoFromCameraFromViewController : (UIViewController*) viewController withComplition: (ComplitionPhoto) block {
    self.copyComplition = block;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        block (nil, [self cameraError]);
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [viewController presentViewController:picker animated:YES completion:nil];
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
        self.copyComplition (image, nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
