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

//TODO : get the knowledge of threads

- (NSString*) saveImageOfUserToDocumentsFolder :(NSString*) photoURL{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = @"image";
    filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]];
    filePath = [filePath stringByAppendingString:@".png"];
    NSString *finalFilePath = [documentsPath stringByAppendingPathComponent:filePath];
    
    
    //    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //    dispatch_async(q, ^{
    /* Fetch the image from the server... */
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: photoURL]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    // dispatch_async(dispatch_get_main_queue(), ^{
    //            dispatch_async(dispatch_get_main_queue(), ^{
    NSData *dataFolder = UIImagePNGRepresentation(image);
    
    
    [dataFolder writeToFile:finalFilePath atomically:YES]; //Write the file
    
    //});
    //});
    //});
    return filePath;
}
@end
