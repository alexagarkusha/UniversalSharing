//
//  UIImageView+MUSLoadImageFromDataBase.m
//  UniversalSharing
//
//  Created by U 2 on 21.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImageView+MUSLoadImageFromDataBase.h"

@implementation UIImageView (MUSLoadImageFromDataBase)

- (void) loadImageFromDataBase : (NSString*) socialNetworkIcon {
    NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder: socialNetworkIcon]];
    self.image = [UIImage imageWithData:data];
}

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}



@end
