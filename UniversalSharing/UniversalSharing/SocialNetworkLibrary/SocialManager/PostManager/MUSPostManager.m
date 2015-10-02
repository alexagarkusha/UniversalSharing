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

@property (strong, nonatomic) NSArray *arrayOfPosts;

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
        self.arrayOfPosts = [[NSArray alloc] initWithArray: [[[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForAllPosts]] mutableCopy]];
    }
    return self;
}

- (NSArray*) arrayOfAllPosts {
    return self.arrayOfPosts;
}

- (NSArray*) updateArrayOfPost {
    self.arrayOfPosts = [[NSArray alloc] initWithArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForAllPosts]]];
    return self.arrayOfPosts;
}

- (void) updateNetworkPosts {
    
}

- (void) deleteNetworkPostFromPostsOfSocialNetworkType : (NetworkType) networkType {
    for (Post *currentPost in self.arrayOfPosts) {
        [currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
        for (NetworkPost *networkPost in currentPost.arrayWithNetworkPosts) {
            if (networkPost.networkType == networkType) {
                // Delete NetworkPost ID from post
                [currentPost.arrayWithNetworkPostsId removeObject: [NSString stringWithFormat: @"%d", networkPost.primaryKey]];
                // Delete NetworkPost from Data Base
                [[DataBaseManager sharedManager] deleteObjectFromDataDase: [MUSDatabaseRequestStringsHelper createStringForDeleteNetworkPost: networkPost]];
            }
        }
        
        if (!currentPost.arrayWithNetworkPostsId.count) {
            // Delete all images from documents
            [[PostImagesManager manager] removeAllImagesFromPostByArrayOfImagesUrls : currentPost.arrayImagesUrl];
            // Delete post from Data Base
            [[DataBaseManager sharedManager] deleteObjectFromDataDase: [MUSDatabaseRequestStringsHelper createStringForDeletePostWithPrimaryKey: currentPost.primaryKey]];
        } else {
            //Update post in Data Base
            [[DataBaseManager sharedManager] deleteObjectFromDataDase: [MUSDatabaseRequestStringsHelper createStringForUpdateNetworkPostIdsInPost: currentPost]];
        }
    }
    [self updatePostInfoNotification];
}

- (void) updatePostInfoNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationPostsInfoWereUpDated object:nil];
}


@end
