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

//TODO : get the knowledge of streams

- (NSString*) saveImageOfUserToDocumentsFolder :(NSString*) photoURL{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = @"image";
    filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]];
    filePath = [filePath stringByAppendingString:@".png"];
    NSString *finalFilePath = [documentsPath stringByAppendingPathComponent:filePath];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: photoURL]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    NSData *dataFolder = UIImagePNGRepresentation(image);
    
    
    [dataFolder writeToFile:finalFilePath atomically:YES]; //Write the file
    return filePath;
}
@end
