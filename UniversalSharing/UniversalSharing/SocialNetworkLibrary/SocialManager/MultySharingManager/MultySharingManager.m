//
//  MultySharingManager.m
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MultySharingManager.h"
#import "SocialNetwork.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "PostImagesManager.h"
#import "NSString+MUSReasonNameOfPost.h"
#import "NSString+MUSSocialNetworkNameOfPost.h"
#import "SocialManager.h"
#import "MUSPostManager.h"
#import "NSString+MUSCurrentDate.h"
#import "MUSProgressBar.h"
#import "MUSProgressBarEndLoading.h"

@interface MultySharingManager ()

@property (copy, nonatomic) Complition complition;
@property (copy, nonatomic) ProgressLoadingComplition progressLoading;
@end


static MultySharingManager *model = nil;


@implementation MultySharingManager

+ (MultySharingManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MultySharingManager alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        if (!self.postsQueue) {
            self.postsQueue = [[NSMutableArray alloc] init];
            self.isPostLoading = NO;
        }
    }
    return self;
}


- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) arrayOfNetworksType withComplition : (Complition) block andProgressLoadingComplition :(ProgressLoadingComplition) blockLoading {
    
    NSMutableArray *arrayWithNetworks = [[SocialManager sharedManager]networksForKeys:arrayOfNetworksType];
    
    self.complition = block;
    self.progressLoading = blockLoading;
    
    NSDictionary *postDictionary = [NSDictionary
                                    dictionaryWithObjectsAndKeys: [post copy], @"post",
                                    arrayWithNetworks, @"arrayWithNetworks", nil];
    
    [self.postsQueue addObject: postDictionary];
    
    if (!self.isPostLoading) {
        NSDictionary *firstPostDictionary = [self.postsQueue firstObject];
        [self sharePostDictionary: firstPostDictionary];
    }
}

- (void) sharePostDictionary: (NSDictionary*) postDictionary {
    Post *currentPost =  [postDictionary objectForKey: @"post"];
#warning Start Posting Notification
    [[MUSProgressBar sharedProgressBar] startProgressViewWithImages: currentPost.imagesArray];
    [self sharePost: currentPost toSocialNetworks: [postDictionary objectForKey: @"arrayWithNetworks"]];
}

- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) arrayWithNetworks {
    //__block NSMutableArray *arrayOfLoadingObjects = [self arrayOfLoadingObjectsFromNetworks: arrayWithNetworks];
    __block NSMutableDictionary *loadingObjectsDictionary = [self dictionaryOfLoadingObjectsFromNetworks: arrayWithNetworks];
    
    self.isPostLoading = YES;
    
    if (!post.primaryKey) {
        post.networkPostIdsArray = [NSMutableArray new];
    }
    
    __block Post *postCopy = post;
    __block NSUInteger numberOfSocialNetworks = arrayWithNetworks.count;
    __block int counterOfSocialNetwork = 0;
    __weak MultySharingManager *weakMultySharingManager = self;

    __block NSMutableDictionary *multyResultDictionary = [[NSMutableDictionary alloc] init];
    
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        [socialNetwork sharePost: post withComplition:^(id result, NSError *error) {

            counterOfSocialNetwork++;
            
            NetworkPost *networkPost;
            
            if ([result isKindOfClass: [NetworkPost class]]) {
                networkPost = (NetworkPost*) result;
                
                NSDictionary* resultDictionary = @{
                                          @"Result" : [NSNumber numberWithInt: networkPost.reason],
                                           @"Error" : error ? error : [NSNull null]
                                          };
                [multyResultDictionary setObject: resultDictionary forKey: @(networkPost.networkType)];
                
                if (!postCopy.primaryKey) {
                    [postCopy.networkPostIdsArray addObject: [NSString stringWithFormat: @"%ld", (long)[[DataBaseManager sharedManager] saveNetworkPost: networkPost]]];
                } else {
                    [weakMultySharingManager updateCurrentNetworkPost: networkPost andArrayOfOldNetworkPosts: postCopy.networkPostsArray];
                }
            }

            if (counterOfSocialNetwork == numberOfSocialNetworks) {
                
                if (!postCopy.primaryKey) {
                    [postCopy saveIntoDataBase];
                }
                
                [[MUSProgressBarEndLoading sharedProgressBarEndLoading] endProgressViewWithCountConnect: multyResultDictionary andImagesArray: postCopy.imagesArray];
                
                weakMultySharingManager.complition (multyResultDictionary, nil);

                [weakMultySharingManager checkPostsQueue];
            }

        } progressLoadingBlock:^(id currentNetworkType, float result) {
            
            float totalProgress = [weakMultySharingManager totalResultOfLoadingToSocialNetworks: loadingObjectsDictionary withCurrentObject: currentNetworkType andResult: result];
            
            [[MUSProgressBar sharedProgressBar] setProgressViewSize: totalProgress / numberOfSocialNetworks];
            
            weakMultySharingManager.progressLoading (totalProgress / numberOfSocialNetworks);
        }];
    }
}

// add to network post

- (void) updateCurrentNetworkPost : (NetworkPost*) newNetworkPost andArrayOfOldNetworkPosts : (NSMutableArray*) arrayOfOldPosts {
    for (NetworkPost *currentNetworkPost in arrayOfOldPosts) {
        if (currentNetworkPost.networkType == newNetworkPost.networkType) {
            if (newNetworkPost.reason != MUSConnect) {
                return;
            } else {
                currentNetworkPost.reason = newNetworkPost.reason;
                currentNetworkPost.postID = newNetworkPost.postID;
                currentNetworkPost.likesCount = newNetworkPost.likesCount;
                currentNetworkPost.commentsCount = newNetworkPost.commentsCount;
                currentNetworkPost.dateCreate = [NSString currentDate];
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForUpdateNetworkPost: currentNetworkPost]];
            }
        }
    }
}

- (void) checkPostsQueue {
    [self.postsQueue removeObjectAtIndex: 0];
    if (self.postsQueue.count > 0) {
        NSDictionary *postDictionary = [self.postsQueue firstObject];
        [self sharePostDictionary: postDictionary];
    } else {
        self.isPostLoading = NO;
    }
}

- (BOOL) queueOfPosts:(NSInteger)primaryKeyOfPost {
    for (NSDictionary *dictionary in self.postsQueue) {
        Post *currentPost = [dictionary objectForKey: @"post"];
        if (currentPost.primaryKey == primaryKeyOfPost) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableDictionary*) dictionaryOfLoadingObjectsFromNetworks : (NSArray*) arrayWithNetworks {
    NSMutableDictionary *loadingObjectsDictionary = [[NSMutableDictionary alloc] init];
    
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        [loadingObjectsDictionary setObject: [NSNumber numberWithFloat: 0.000001] forKey: [NSNumber numberWithInt: socialNetwork.networkType]];
    }
    
    return loadingObjectsDictionary;
}

- (float) totalResultOfLoadingToSocialNetworks : (NSMutableDictionary*) loadingObjectsDictionary withCurrentObject : (NSNumber*) currentNetworkType andResult : (float) result {

    [loadingObjectsDictionary setObject:[NSNumber numberWithFloat: result] forKey: currentNetworkType];
    
    NSArray *allValues = [loadingObjectsDictionary allValues];
    NSNumber *sum = [allValues valueForKeyPath: @"@sum.self"];

    return [sum floatValue];
}

@end
