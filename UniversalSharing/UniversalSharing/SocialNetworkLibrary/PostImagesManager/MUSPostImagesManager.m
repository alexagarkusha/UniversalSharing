//
//  PostImagesManager.m
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostImagesManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "MUSImageToPost.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"


static MUSPostImagesManager *model = nil;

@implementation MUSPostImagesManager

+ (MUSPostImagesManager*) manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSPostImagesManager alloc] init];
    });
    return  model;
}

- (NSMutableArray*) saveImagesToDocumentsFolderAndGetArrayWithImagesUrls :(NSMutableArray*) arrayWithImages {
    
    NSMutableArray *arrayWithImagesUrls = [[NSMutableArray alloc] init];
    [arrayWithImages enumerateObjectsUsingBlock:^(MUSImageToPost *image, NSUInteger index, BOOL *stop) {
        NSData *data = UIImagePNGRepresentation(image.image);
        //Get the docs directory
        NSString *filePath = @"image";
        filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]];
        filePath = [filePath stringByAppendingString:@".png"];
        [arrayWithImagesUrls addObject:filePath];
        [data writeToFile:[filePath obtainPathToDocumentsFolder:filePath] atomically:YES]; //Write the file
    }];
    return arrayWithImagesUrls;
}

- (void) removeImagesFromPostByArrayOfImagesUrls : (NSMutableArray*) arrayOfImagesUrls {
    if (![[arrayOfImagesUrls firstObject] isEqualToString: @""] && arrayOfImagesUrls.count > 0) {
        //__block NSError *error;
        [arrayOfImagesUrls enumerateObjectsUsingBlock:^(NSString *urlImage, NSUInteger idx, BOOL *stop) {
            [self removeImageFromFileManagerByImagePath: urlImage];
            //[[NSFileManager defaultManager] removeItemAtPath: [urlImage obtainPathToDocumentsFolder: urlImage] error: &error];
        }];
    }
}

- (void) removeImageFromFileManagerByImagePath : (NSString*) imagePathString {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath: [imagePathString obtainPathToDocumentsFolder: imagePathString] error: &error];
}




@end
