//
//  NSString+MUSPathToDocumentsdirectory.m
//  UniversalSharing
//
//  Created by Roman on 8/20/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+MUSPathToDocumentsdirectory.h"

@implementation NSString (MUSPathToDocumentsdirectory)

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}

@end
