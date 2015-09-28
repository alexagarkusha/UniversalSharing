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

static MultySharingManager *model = nil;


@implementation MultySharingManager

+ (MultySharingManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MultySharingManager alloc] init];
    });
    return  model;
}

- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) arrayOfNetworksType withComplition : (Complition) block {
    NSMutableArray *arrayWithNetworks = [self arrayWithNetworks: arrayOfNetworksType];
#warning Need to refactor this
    
    if (!post.arrayWithNetworkPostsId.count) {
        post.arrayWithNetworkPostsId = [[NSMutableArray alloc] init];
    }
    
    __block Post *postCopy = post;
    __block NSUInteger numberOfSocialNetworks = arrayWithNetworks.count;
    __block int counterOfSocialNetwork = 0;
    __block NSString *blockResultString = @"Result: \n";
    __weak MultySharingManager *weakMultySharingManager = self;

    //dispatch_group_t group = dispatch_group_create();
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        //dispatch_group_async(group, queue, ^{
            [socialNetwork sharePost: post withComplition:^(id result, NSError *error) {
                //networkpost create
                counterOfSocialNetwork++;
                NetworkPost *networkPost;
                
                if ([result isKindOfClass: [NetworkPost class]]) {
                    networkPost = (NetworkPost*) result;
                    blockResultString = [blockResultString stringByAppendingString: [NSString stringWithFormat: @"%@ - post status is %@ \n", [NSString socialNetworkNameOfPost: networkPost.networkType], [NSString reasonNameOfPost: networkPost.reason]]];
                }
                
                [postCopy.arrayWithNetworkPostsId addObject: [NSString stringWithFormat: @"%ld", (long)[[DataBaseManager sharedManager] saveNetworkPostToTableWithObject: networkPost]]];
                if (counterOfSocialNetwork == numberOfSocialNetworks) {
                    [weakMultySharingManager savePostImagesToDocument: postCopy];
                    [[DataBaseManager sharedManager] insertIntoTable : postCopy];
                    NSLog(@"%@", blockResultString);
                    block (blockResultString, error);
                }
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

- (void) stopUpdatingPostWithObject : (id) object {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationStopUpdatingPost object: object];
}

- (void) savePostImagesToDocument: (Post*) post {
    if (!post.arrayImagesUrl) {
        post.arrayImagesUrl = [NSMutableArray new];
    } else {
        [post.arrayImagesUrl removeAllObjects];
    }
    post.arrayImagesUrl = [[PostImagesManager manager] saveImagesToDocumentsFolderAndGetArrayWithImagesUrls: post.arrayImages];
}


                       
@end
