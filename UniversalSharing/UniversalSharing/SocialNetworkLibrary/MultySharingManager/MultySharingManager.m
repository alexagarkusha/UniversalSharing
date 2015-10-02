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

@interface MultySharingManager ()

@property (copy, nonatomic) Complition copyComplition;
@property (copy, nonatomic) ComplitionProgressLoading copyProgressLoading;
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

- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) arrayOfNetworksType withComplition : (Complition) block andComplitionProgressLoading :(ComplitionProgressLoading) blockLoading {
    NSMutableArray *arrayWithNetworks = [self arrayWithNetworks: arrayOfNetworksType];
    self.copyComplition = block;
    self.copyProgressLoading = blockLoading;
    if (!post.primaryKey) {
        [self shareNewPost: post toSocialNetworks: arrayWithNetworks];
    } else {
        [self updatePost: post toSocialNetworks: arrayWithNetworks];
    }
}

- (void) shareNewPost : (Post*) newPost toSocialNetworks : (NSArray*) arrayWithNetworks {
#warning Need to refactor this
    
    if (!newPost.arrayWithNetworkPostsId.count) {
        newPost.arrayWithNetworkPostsId = [[NSMutableArray alloc] init];
    }
    __block Post *postCopy = newPost;
    __block NSUInteger numberOfSocialNetworks = arrayWithNetworks.count;
    __block int counterOfSocialNetwork = 0;
    __block NSString *blockResultString = @"Result: \n";
    __weak MultySharingManager *weakMultySharingManager = self;
    
    //dispatch_group_t group = dispatch_group_create();
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        //dispatch_group_async(group, queue, ^{
        [socialNetwork sharePost: newPost withComplition:^(id result, NSError *error) {
            //networkpost create
            counterOfSocialNetwork++;
            NetworkPost *networkPost;
            
            if ([result isKindOfClass: [NetworkPost class]]) {
                networkPost = (NetworkPost*) result;
                blockResultString = [blockResultString stringByAppendingString: [NSString stringWithFormat: @"%@ - post status is %@ \n", [NSString socialNetworkNameOfPost: networkPost.networkType], [NSString reasonNameOfPost: networkPost.reason]]];
                [postCopy.arrayWithNetworkPostsId addObject: [NSString stringWithFormat: @"%ld", (long)[[DataBaseManager sharedManager] saveNetworkPostToTableWithObject: networkPost]]];
            }
            
            NSLog(@"Current post ID = %@, networktype =%ld", networkPost.postID, (long)networkPost.networkType);
            
            
            if (counterOfSocialNetwork == numberOfSocialNetworks) {
                
                
                [weakMultySharingManager savePostImagesToDocument: postCopy];
                
                NSLog(@"Current post IDs = %@", postCopy.arrayWithNetworkPostsId);
                
                
                [[DataBaseManager sharedManager] insertIntoTable : postCopy];
                
                //NSLog(@"%@", blockResultString);
                [MUSPostManager manager].needToRefreshPosts = YES;
                [self updatePostInfoNotification];
                self.copyComplition (blockResultString, error);
            }

        } andComplitionLoading:^(float result) {
            self.copyProgressLoading(result);
        }];
        
        //});
    }
    //
    //    dispatch_group_notify(group, queue, ^{
    //        //Save Post to DataBase After Send POST TO SN;
    //        block (nil, nil);
    //        [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
    //        NSLog(@"ALL Tasks complete");
    //    });
}



- (void) updatePost : (Post*) post toSocialNetworks : (NSArray*) arrayWithNetworks {
    __block Post *postCopy = post;
    __block NSUInteger numberOfSocialNetworks = arrayWithNetworks.count;
    __block int counterOfSocialNetwork = 0;
    __block NSString *blockResultString = @"Result updating: \n";
    __weak MultySharingManager *weakMultySharingManager = self;

    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        [socialNetwork sharePost: post withComplition:^(id result, NSError *error) {
            
            //networkpost create
            counterOfSocialNetwork++;
            NetworkPost *networkPost;
            
            if ([result isKindOfClass: [NetworkPost class]]) {
                networkPost = (NetworkPost*) result;
                [weakMultySharingManager updateCurrentNetworkPost: networkPost andArrayOfOldNetworkPosts: postCopy.arrayWithNetworkPosts];
                blockResultString = [blockResultString stringByAppendingString: [NSString stringWithFormat: @"%@ - post status is %@ \n", [NSString socialNetworkNameOfPost: networkPost.networkType], [NSString reasonNameOfPost: networkPost.reason]]];
            }
            if (counterOfSocialNetwork == numberOfSocialNetworks) {
                self.copyComplition (blockResultString, error);
            }

        } andComplitionLoading:^(float result) {
            
        }];
    }
}

- (void) updateCurrentNetworkPost : (NetworkPost*) newNetworkPost andArrayOfOldNetworkPosts : (NSMutableArray*) arrayOfOldPosts {
    for (NetworkPost *currentNetworkPost in arrayOfOldPosts) {
        if (currentNetworkPost.networkType == newNetworkPost.networkType) {
            if (newNetworkPost.reason != Connect) {
                return;
            } else {
                currentNetworkPost.reason = newNetworkPost.reason;
                currentNetworkPost.postID = newNetworkPost.postID;
                currentNetworkPost.likesCount = newNetworkPost.likesCount;
                currentNetworkPost.commentsCount = newNetworkPost.commentsCount;
                currentNetworkPost.dateCreate = [NSString currentDate];
                [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper createStringForUpdateNetworkPost: currentNetworkPost]];
            }
        }
    }
}

- (NSMutableArray *) arrayWithNetworks : (NSArray*) arrayOfNetworksType {
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray: arrayOfNetworksType];
    NSArray *arrayWithNetworkWithoutDuplicates = [orderedSet array];
    
    NSMutableArray *arrayWithNetworks = [NSMutableArray new];
    [arrayWithNetworkWithoutDuplicates enumerateObjectsUsingBlock:^(id obj, NSUInteger currentIndex, BOOL *stop) {
        // If we repost post to another SN - we don't add SN with success reason to arrayWithNetworks
        [arrayWithNetworks addObject:[SocialNetwork sharedManagerWithType: [arrayOfNetworksType[currentIndex] integerValue]]];
    }];
    return arrayWithNetworks;
}

- (void) updateNetworkPostsWithComplition : (Complition) block {
    NSMutableArray *activeSocialNetworksArray = [[SocialManager sharedManager] activeSocialNetworks];
    __block NSUInteger numberOfActiveSocialNetworks = activeSocialNetworksArray.count;
    __block NSUInteger counterOfSocialNetworks = 0;
    __block NSString *blockResultString = @"Result: \n";
    
    for (int i = 0; i < activeSocialNetworksArray.count; i++) {
        SocialNetwork *currentSocialNetwork = [activeSocialNetworksArray objectAtIndex: i];
        [currentSocialNetwork updatePostWithComplition:^(id result) {
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

- (void) savePostImagesToDocument: (Post*) post {
    if (!post.arrayImagesUrl) {
        post.arrayImagesUrl = [NSMutableArray new];
    } else {
        [post.arrayImagesUrl removeAllObjects];
    }
    post.arrayImagesUrl = [[PostImagesManager manager] saveImagesToDocumentsFolderAndGetArrayWithImagesUrls: post.arrayImages];
}

- (void) updatePostInfoNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationPostsInfoWereUpDated object:nil];
}

                       
@end
