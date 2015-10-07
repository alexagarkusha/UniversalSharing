//
//  UIImageView+MUSLoadImageFromDataBase.m
//  UniversalSharing
//
//  Created by U 2 on 21.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImageView+MUSLoadImageFromDataBase.h"
#import "ConstantsApp.h"


@implementation UIImageView (MUSLoadImageFromDataBase)

- (void) loadImageFromDataBase : (NSString*) urlOfImage {
    __weak UIImageView *weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(queue, ^{
        NSString *imagepath = [self obtainPathToDocumentsFolder: urlOfImage];
        UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf setImage:image];
        });
    });
}

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}

@end
