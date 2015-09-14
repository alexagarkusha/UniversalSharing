//
//  UIImageView+MUSLoadImageFromDataBase.m
//  UniversalSharing
//
//  Created by U 2 on 21.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImageView+MUSLoadImageFromDataBase.h"

@implementation UIImageView (MUSLoadImageFromDataBase)

- (void) loadImageFromDataBase : (NSString*) urlOfImage {
    NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder: urlOfImage]];
    self.image = [UIImage imageWithData:data];
    
    
//    __weak UIImageView *weakSelf = self;
//    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
//    dispatch_async(q, ^{
//        /* Fetch the image from the server... */
//        //NSData *data = [NSData dataWithContentsOfURL:url];
//        NSData *data = [NSData dataWithContentsOfFile:[weakSelf obtainPathToDocumentsFolder: urlOfImage]];
//        UIImage *image = [[UIImage alloc] initWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.image = image;
//            });
//        });
//    });

}

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}



@end
