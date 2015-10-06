//
//  PostImagesManager.h
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface PostImagesManager : NSObject


+ (PostImagesManager*) manager;

- (NSMutableArray*) saveImagesToDocumentsFolderAndGetArrayWithImagesUrls :(NSMutableArray*) arrayWithImages;

- (void) removeAllImagesFromAllPostsByUserID :(NSString*) userID;

- (void) removeAllImagesFromPostByArrayOfImagesUrls : (NSMutableArray*) arrayOfImagesUrls;


@end