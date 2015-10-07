//
//  MUSPostManager.m
//  UniversalSharing
//
//  Created by U 2 on 30.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostManager.h"
#import "DataBaseManager.h"
#import "PostImagesManager.h"
#import "MUSDatabaseRequestStringsHelper.h"

@interface MUSPostManager ()


@end


static MUSPostManager *model = nil;

@implementation MUSPostManager

+ (MUSPostManager*) manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSPostManager alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.arrayOfPosts = [[NSMutableArray alloc] init];
        [self.arrayOfPosts addObjectsFromArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForAllPosts]]];
        
    }
    return self;
}

- (void)setArrayOfPosts:(NSMutableArray *)arrayOfPosts {
    _arrayOfPosts = arrayOfPosts;
}

- (void) updateArrayOfPost {
    [self.arrayOfPosts removeAllObjects];
    [self.arrayOfPosts addObjectsFromArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForAllPosts]]];
}

- (void) deleteNetworkPostForNetworkType : (NetworkType) networkType {
    for (Post *currentPost in self.arrayOfPosts) {
        [currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
        for (NetworkPost *networkPost in currentPost.arrayWithNetworkPosts) {
            if (networkPost.networkType == networkType) {
                // Delete NetworkPost ID from post
                [currentPost.arrayWithNetworkPostsId removeObject: [NSString stringWithFormat: @"%ld", (long)networkPost.primaryKey]];
                // Delete NetworkPost from Data Base
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForDeleteNetworkPost: networkPost]];
            }
        }
        
        if (!currentPost.arrayWithNetworkPostsId.count) {
            // Delete all images from documents
            [[PostImagesManager manager] removeImagesFromPostByArrayOfImagesUrls : currentPost.arrayImagesUrl];
            // Delete post from Data Base
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringForDeletePostWithPrimaryKey: currentPost.primaryKey]];
        } else {
            //Update post in Data Base
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringForUpdateNetworkPostIdsInPost: currentPost]];
        }
    }
    [self updateArrayOfPost];
}



@end
