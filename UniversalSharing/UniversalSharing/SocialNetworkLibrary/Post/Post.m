//
//  Post.m
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "Post.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "UIImage+LoadImageFromDataBase.h"

@implementation Post

+ (instancetype)create {
    Post *post = [[Post alloc] init];
    
    post.postID = @"";
    post.postDescription = @"";
    post.imagesArray = [[NSMutableArray alloc] init];
    post.likesCount = 0;
    post.commentsCount = 0;
    post.placeID = @"";
    post.networkType = MUSAllNetworks;
    post.primaryKey = 0;
    post.imageUrlsArray = [[NSMutableArray alloc] init];
    //post.userId = @"";
    post.dateCreate = @"";
    //post.reason = MUSAllReasons;
    //post.locationId = @"";
    post.place = [Place create];
    //post.networkPost = [NetworkPost create];
    post.networkPostsArray = [[NSMutableArray alloc] init];
    post.networkPostIdsArray = [[NSMutableArray alloc] init];
    post.longitude = @"";
    post.latitude = @"";
    
    return post;
}



- (id)copy
{
    Post *copyPost = [Post new];
    copyPost.postID = [self.postID copy];
    copyPost.postDescription = [self.postDescription copy];
    copyPost.imagesArray = [self.imagesArray mutableCopy];
    copyPost.likesCount = self.likesCount;
    copyPost.commentsCount = self.commentsCount;
    copyPost.placeID = self.placeID;
    copyPost.networkType = self.networkType;
    copyPost.primaryKey = self.primaryKey;
    copyPost.imageUrlsArray = [self.imageUrlsArray mutableCopy];
    //copyPost.userId = [self.userId copy];
    copyPost.dateCreate = [self.dateCreate copy];
    //copyPost.reason = self.reason;
    //copyPost.locationId = [self.locationId copy];
    copyPost.place = [self.place copy];
    //copyPost.networkPost = [self.networkPost copy];
    copyPost.networkPostsArray = [self.networkPostsArray mutableCopy];
    copyPost.networkPostIdsArray = [self.networkPostIdsArray mutableCopy];
    copyPost.longitude = self.longitude;
    copyPost.latitude = self.latitude;
    return copyPost;
}

- (void) updateAllNetworkPostsFromDataBaseForCurrentPost {
    if (!_networkPostsArray) {
        _networkPostsArray = [[NSMutableArray alloc] init];
    }
    [_networkPostsArray removeAllObjects];
    [_networkPostIdsArray enumerateObjectsUsingBlock:^(NSString *primaryKeyNetPost, NSUInteger idx, BOOL *stop) {
        [_networkPostsArray addObject: [[DataBaseManager sharedManager] obtainNetworkPostFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForNetworkPostWithPrimaryKey:[primaryKeyNetPost integerValue]]]];
    }];
    
    [_networkPostsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"networkType" ascending:YES]]];
}

- (void) saveIntoDataBase {
    [self savePostImagesToDocument];
    [[DataBaseManager sharedManager] insertObjectIntoTable : self];
    [[MUSPostManager manager] updatePostsArray];
}

- (void) savePostImagesToDocument {
    if (!_imageUrlsArray) {
        _imageUrlsArray = [NSMutableArray new];
    } else {
        [_imageUrlsArray removeAllObjects];
    }
    _imageUrlsArray = [[PostImagesManager manager] saveImagesToDocumentsFolderAndGetArrayWithImagesUrls: _imagesArray];
}


- (NSString*) convertArrayImagesUrlToString {
    NSString *url = @"";
    for (int i = 0; i < self.imageUrlsArray.count; i++) {
        url = [url stringByAppendingString:self.imageUrlsArray[i]];
        if(self.imageUrlsArray.count - 1 != i)
            url = [url stringByAppendingString:@", "];
    }
    return url;
}

- (NSString *) convertArrayWithNetworkPostsIdsToString {
    _postID = @"";
    for (int i = 0; i < _networkPostIdsArray.count; i++) {
        _postID = [_postID stringByAppendingString: [_networkPostIdsArray objectAtIndex:i]];
        if (i != _networkPostIdsArray.count - 1) {
            _postID = [_postID stringByAppendingString: @","];
        }
    }
    return _postID;
}

- (NSMutableArray*) convertArrayOfImagesUrlToArrayImagesWithObjectsImageToPost {
    _imagesArray = [NSMutableArray new];
    for (int i = 0; i < _imageUrlsArray.count; i++) {
        UIImage *image = [UIImage new];
        image = [image loadImageFromDataBase: [_imageUrlsArray objectAtIndex: i]];
        ImageToPost *imageToPost = [[ImageToPost alloc] init];
        imageToPost.image = image;
        imageToPost.quality = 1.0f;
        imageToPost.imageType = MUSJPEG;
        [_imagesArray addObject: imageToPost];
    }
    return _imagesArray;
}

#pragma mark - GETTERS

- (NSString *)postDescription {
    if (!_postDescription || [_postDescription isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _postDescription;
}



@end
