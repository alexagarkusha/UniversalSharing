//
//  PostImagesManager.m
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "PostImagesManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "ImageToPost.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"


static PostImagesManager *model = nil;

@implementation PostImagesManager

+ (PostImagesManager*) manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[PostImagesManager alloc] init];
    });
    return  model;
}

- (NSMutableArray*) saveImagesToDocumentsFolderAndGetArrayWithImagesUrls :(NSMutableArray*) arrayWithImages {
    
    NSMutableArray *arrayWithImagesUrls = [[NSMutableArray alloc] init];
    [arrayWithImages enumerateObjectsUsingBlock:^(ImageToPost *image, NSUInteger index, BOOL *stop) {
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


//- (void) removeAllImagesFromAllPostsByUserID :(NSString*) userID {
//    __block NSError *error;
//    NSArray *arrayWithPostsOfUser = [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForPostWithUserId: userID]];
//    [arrayWithPostsOfUser enumerateObjectsUsingBlock:^(Post *post, NSUInteger idx, BOOL *stop) {
//        
//        if (![[post.arrayImagesUrl firstObject] isEqualToString: @""] && post.arrayImagesUrl.count > 0) {
//            [post.arrayImagesUrl enumerateObjectsUsingBlock:^(NSString *urlImage, NSUInteger idx, BOOL *stop) {
//                [[NSFileManager defaultManager] removeItemAtPath: [urlImage obtainPathToDocumentsFolder: urlImage] error: &error];
//                
//            }];
//        }
//    }];
//}

- (void) removeImagesFromPostByArrayOfImagesUrls : (NSMutableArray*) arrayOfImagesUrls {
    if (![[arrayOfImagesUrls firstObject] isEqualToString: @""] && arrayOfImagesUrls.count > 0) {
        __block NSError *error;
        [arrayOfImagesUrls enumerateObjectsUsingBlock:^(NSString *urlImage, NSUInteger idx, BOOL *stop) {
            [[NSFileManager defaultManager] removeItemAtPath: [urlImage obtainPathToDocumentsFolder: urlImage] error: &error];
        }];
    }
}



@end
