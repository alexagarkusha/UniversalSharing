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

@implementation Post

- (NSString*) convertArrayImagesUrlToString {
    NSString *url = @"";
    for (int i = 0; i < self.arrayImagesUrl.count; i++) {
        url = [url stringByAppendingString:self.arrayImagesUrl[i]];
        if(self.arrayImagesUrl.count - 1 != i)
            url = [url stringByAppendingString:@", "];
    }
    return url;    
}

- (id)copy
{
    Post *copyPost = [Post new];
    copyPost.postID = [self.postID copy];
    copyPost.postDescription = [self.postDescription copy];
    copyPost.arrayImages = [self.arrayImages mutableCopy];
    copyPost.likesCount = self.likesCount;
    copyPost.commentsCount = self.commentsCount;
    copyPost.placeID = self.placeID;
    copyPost.networkType = self.networkType;
    copyPost.primaryKey = self.primaryKey;
    copyPost.arrayImagesUrl = [self.arrayImagesUrl mutableCopy];
    copyPost.userId = [self.userId copy];
    copyPost.dateCreate = [self.dateCreate copy];
    copyPost.reason = self.reason;
    copyPost.locationId = [self.locationId copy];
    copyPost.place = [self.place copy];
    //copyPost.networkPost = [self.networkPost copy];
    copyPost.arrayWithNetworkPosts = [self.arrayWithNetworkPosts mutableCopy];
    copyPost.arrayWithNetworkPostsId = [self.arrayWithNetworkPostsId mutableCopy];
    return copyPost;
}

- (void) updateAllNetworkPostsFromDataBaseForCurrentPost {
    if (!_arrayWithNetworkPosts) {
        _arrayWithNetworkPosts = [[NSMutableArray alloc] init];
    }
    [_arrayWithNetworkPosts removeAllObjects];
    [_arrayWithNetworkPostsId enumerateObjectsUsingBlock:^(NSString *primaryKeyNetPost, NSUInteger idx, BOOL *stop) {
        [_arrayWithNetworkPosts addObject: [[DataBaseManager sharedManager] obtainNetworkPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForNetworkPostWithPrimaryKey:[primaryKeyNetPost integerValue]]]];
    }];
}

#pragma mark - GETTERS

- (NSString *)postDescription {
    if (!_postDescription || [_postDescription isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _postDescription;
}



@end
