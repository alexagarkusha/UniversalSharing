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
#import "SocialManager.h"

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
        self.postsArray = [[NSMutableArray alloc] init];
        [self.postsArray addObjectsFromArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper stringForAllPosts]]];
        
    }
    return self;
}

- (void)setPostsArray:(NSMutableArray *)postsArray {
    _postsArray = postsArray;
}

- (void) updatePostsArray {
    [self.postsArray removeAllObjects];
    [self.postsArray addObjectsFromArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper stringForAllPosts]]];
}

- (NSArray*) networkPostsArrayForNetworkType : (NetworkType) networkType {
   return [[DataBaseManager sharedManager] obtainNetworkPostsFromDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForNetworkPostWithReason: MUSConnect andNetworkType: networkType]];
}

- (void) updateNetworkPostsWithComplition : (Complition) block {
    //Need to add a check isLogin socialNetwork or not in each social network?
    
    NSMutableArray *allSocialNetworksArray = [[SocialManager sharedManager] allNetworks];
    __block NSUInteger numberOfActiveSocialNetworks = allSocialNetworksArray.count;
    __block NSUInteger counterOfSocialNetworks = 0;
    __block NSString *blockResultString = @"Result: \n";
    
    for (int i = 0; i < allSocialNetworksArray.count; i++) {
        SocialNetwork *currentSocialNetwork = [allSocialNetworksArray objectAtIndex: i];
        [currentSocialNetwork updateNetworkPostWithComplition:^(id result) {
            counterOfSocialNetworks++;
            //NSLog(@"counter = %d", counterOfSocialNetworks);
            NSLog(@"%@", result);
            
            blockResultString = [blockResultString stringByAppendingString: [NSString stringWithFormat: @"%@, \n", result]];
            if (counterOfSocialNetworks == numberOfActiveSocialNetworks) {
                block (blockResultString, nil);
            }
        }];
    }
}

- (void) deleteNetworkPostForNetworkType : (NetworkType) networkType {
    for (Post *currentPost in self.postsArray) {
        [currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
        for (NetworkPost *networkPost in currentPost.networkPostsArray) {
            if (networkPost.networkType == networkType) {
                // Delete NetworkPost ID from post
                [currentPost.networkPostIdsArray removeObject: [NSString stringWithFormat: @"%ld", (long)networkPost.primaryKey]];
                // Delete NetworkPost from Data Base
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForDeleteNetworkPost: networkPost]];
            }
        }
        
        if (!currentPost.networkPostIdsArray.count) {
            // Delete all images from documents
            [[PostImagesManager manager] removeImagesFromPostByArrayOfImagesUrls : currentPost.imageUrlsArray];
            // Delete post from Data Base
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForDeletePostByPrimaryKey: currentPost.primaryKey]];
        } else {
            //Update post in Data Base
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForUpdatePost: currentPost]];
        }
    }
    [self updatePostsArray];
}



@end
