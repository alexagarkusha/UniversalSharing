//
//  UIImage+LoadImageFromDataBase.m
//  UniversalSharing
//
//  Created by U 2 on 25.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImage+LoadImageFromDataBase.h"

@implementation UIImage (LoadImageFromDataBase)

- (UIImage*) loadImageFromDataBase : (NSString*) urlOfImage {
    NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder: urlOfImage]];
    
    return [UIImage imageWithData:data];
}

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}


@end
