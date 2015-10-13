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
    post.userId = @"";
    post.dateCreate = @"";
    post.reason = MUSAllReasons;
    post.locationId = @"";
    post.place = [Place create];
    post.networkPost = [NetworkPost create];
    post.arrayWithNetworkPosts = [[NSMutableArray alloc] init];
    post.arrayWithNetworkPostsId = [[NSMutableArray alloc] init];
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
    copyPost.userId = [self.userId copy];
    copyPost.dateCreate = [self.dateCreate copy];
    copyPost.reason = self.reason;
    copyPost.locationId = [self.locationId copy];
    copyPost.place = [self.place copy];
    //copyPost.networkPost = [self.networkPost copy];
    copyPost.arrayWithNetworkPosts = [self.arrayWithNetworkPosts mutableCopy];
    copyPost.arrayWithNetworkPostsId = [self.arrayWithNetworkPostsId mutableCopy];
    copyPost.longitude = self.longitude;
    copyPost.latitude = self.latitude;
    return copyPost;
}

- (void) updateAllNetworkPostsFromDataBaseForCurrentPost {
    if (!_arrayWithNetworkPosts) {
        _arrayWithNetworkPosts = [[NSMutableArray alloc] init];
    }
    [_arrayWithNetworkPosts removeAllObjects];
    [_arrayWithNetworkPostsId enumerateObjectsUsingBlock:^(NSString *primaryKeyNetPost, NSUInteger idx, BOOL *stop) {
        [_arrayWithNetworkPosts addObject: [[DataBaseManager sharedManager] obtainNetworkPostFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForNetworkPostWithPrimaryKey:[primaryKeyNetPost integerValue]]]];
    }];
    
    [_arrayWithNetworkPosts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"networkType" ascending:YES]]];
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
    for (int i = 0; i < _arrayWithNetworkPostsId.count; i++) {
        _postID = [_postID stringByAppendingString: [_arrayWithNetworkPostsId objectAtIndex:i]];
        if (i != _arrayWithNetworkPostsId.count - 1) {
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
