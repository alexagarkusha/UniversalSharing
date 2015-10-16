//
//  MUSPostManager.m
//  UniversalSharing
//
//  Created by U 2 on 30.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostManager.h"
#import "MUSDataBaseManager.h"
#import "MUSPostImagesManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "MUSInternetConnectionManager.h"
#import "MUSSocialManager.h"

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
        [self.postsArray addObjectsFromArray: [[MUSDataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper stringForAllPosts]]];
        
    }
    return self;
}

- (void)setPostsArray:(NSMutableArray *)postsArray {
    _postsArray = postsArray;
}

- (void) updatePostsArray {
    [self.postsArray removeAllObjects];
    [self.postsArray addObjectsFromArray: [[MUSDataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper stringForAllPosts]]];
    [self updatePostInfoNotification];
}

- (NSArray*) networkPostsArrayForNetworkType : (NetworkType) networkType {
   return [[MUSDataBaseManager sharedManager] obtainNetworkPostsFromDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForNetworkPostWithReason: MUSConnect andNetworkType: networkType]];
}

- (void) updateNetworkPostsWithComplition : (Complition) block {
    if (![MUSInternetConnectionManager connectionManager].isInternetConnection) {
        block (MUSConnectionError, nil);
        return;
    }
    
    NSMutableArray *allSocialNetworksArray = [[MUSSocialManager sharedManager] allNetworks];
    __block NSUInteger numberOfActiveSocialNetworks = allSocialNetworksArray.count;
    __block NSUInteger counterOfSocialNetworks = 0;
    __block NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < allSocialNetworksArray.count; i++) {
        MUSSocialNetwork *currentSocialNetwork = [allSocialNetworksArray objectAtIndex: i];
        [currentSocialNetwork updateNetworkPostWithComplition:^(id result) {
            counterOfSocialNetworks++;
            
            [resultDictionary setObject: result forKey: @(currentSocialNetwork.networkType)];
            if (counterOfSocialNetworks == numberOfActiveSocialNetworks) {
                block (resultDictionary, nil);
            }
            
        }];
    }
}

- (void) deleteNetworkPostForNetworkType : (NetworkType) networkType {
    for (MUSPost *currentPost in self.postsArray) {
        [currentPost updateAllNetworkPostsFromDataBaseForCurrentPost];
        for (MUSNetworkPost *networkPost in currentPost.networkPostsArray) {
            if (networkPost.networkType == networkType) {
                // Delete NetworkPost ID from post
                [currentPost.networkPostIdsArray removeObject: [NSString stringWithFormat: @"%ld", (long)networkPost.primaryKey]];
                // Delete NetworkPost from Data Base
                [[MUSDataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForDeleteNetworkPost: networkPost]];
            }
        }
        
        if (!currentPost.networkPostIdsArray.count) {
            // Delete all images from documents
            [[MUSPostImagesManager manager] removeImagesFromPostByArrayOfImagesUrls : currentPost.imageUrlsArray];
            // Delete post from Data Base
            [[MUSDataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForDeletePostByPrimaryKey: currentPost.primaryKey]];
        } else {
            //Update post in Data Base
            [[MUSDataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForUpdatePost: currentPost]];
        }
    }
    [self updatePostsArray];
}

- (void) updatePostInfoNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSInfoPostsDidUpDateNotification object:nil];
}


@end
