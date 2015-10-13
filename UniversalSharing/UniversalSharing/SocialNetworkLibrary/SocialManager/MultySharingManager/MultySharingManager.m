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

@property (copy, nonatomic) Complition copyComplition;
@property (copy, nonatomic) ProgressLoadingComplition copyProgressLoading;
//@property (strong, nonatomic) NSMutableArray *arrayWithQueueOfPosts;
//@property (assign, nonatomic) BOOL isPostLoading;

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
        if (!self.arrayWithQueueOfPosts) {
            self.arrayWithQueueOfPosts = [[NSMutableArray alloc] init];
            self.isPostLoading = NO;
        }
    }
    return self;
}


- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) arrayOfNetworksType withComplition : (Complition) block andProgressLoadingComplition :(ProgressLoadingComplition) blockLoading {
    NSMutableArray *arrayWithNetworks = [[SocialManager sharedManager]networksForKeys:arrayOfNetworksType];//[self arrayWithNetworks: arrayOfNetworksType];
    self.copyComplition = block;
    self.copyProgressLoading = blockLoading;
    
    NSDictionary *postDictionary = [NSDictionary
                                    dictionaryWithObjectsAndKeys: post, @"post",
                                    arrayWithNetworks, @"arrayWithNetworks", nil];
    [self.arrayWithQueueOfPosts addObject: postDictionary];
    if (!self.isPostLoading /*&& self.arrayWithQueueOfPosts.count == 1*/) {
        [self sharePost: post toSocialNetworks: arrayWithNetworks];
    }
}

- (void) sharePost: (Post*) post toSocialNetworks: (NSArray *) arrayWithNetworks {
    NSLog(@"New OBJECT");
    [[MUSProgressBar sharedProgressBar] startProgressViewWithImages:post.imagesArray];
    if (!post.primaryKey) {
        [self shareNewPost: post toSocialNetworks: arrayWithNetworks];
    } else {
        [self updatePost: post toSocialNetworks: arrayWithNetworks];
    }
}

- (void) shareNewPost : (Post*) newPost toSocialNetworks : (NSArray*) arrayWithNetworks {
#warning Need to refactor this
    __block NSMutableArray *arrayOfLoadingObjects = [self arrayOfLoadingObjectsFromNetworks: arrayWithNetworks];
    self.isPostLoading = YES;
    newPost.networkPostIdsArray = [NSMutableArray new];
    __block Post *postCopy = newPost;
    __block NSUInteger numberOfSocialNetworks = arrayWithNetworks.count;
    __block int counterOfSocialNetwork = 0;
    __block NSString *blockResultString = @"Result: \n";
    __weak MultySharingManager *weakMultySharingManager = self;
    __block int countConnectPosts = 0;
    __block NSDictionary *resultDictionary;
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
                if(networkPost.reason == MUSConnect){
                    countConnectPosts++;
                }
                [postCopy.networkPostIdsArray addObject: [NSString stringWithFormat: @"%ld", (long)[[DataBaseManager sharedManager] saveNetworkPost: networkPost]]];
            }
            //NSLog(@"Current post ID = %@, networktype =%ld", networkPost.postID, (long)networkPost.networkType);
            if (counterOfSocialNetwork == numberOfSocialNetworks) {
                [weakMultySharingManager savePostImagesToDocument: postCopy];
                //NSLog(@"Current post IDs = %@", postCopy.arrayWithNetworkPostsId);
                [[DataBaseManager sharedManager] insertObjectIntoTable : postCopy];
                //NSLog(@"%@", blockResultString);
                [[MUSPostManager manager] updatePostsArray];
                [weakMultySharingManager updatePostInfoNotification];
                //NSLog(@"END LOAD");
                resultDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:counterOfSocialNetwork], @"numberOfSocialNetworks", [NSNumber numberWithInt:countConnectPosts], @"countConnectPosts", nil];
                //weakMultySharingManager.copyComplition (blockResultString, error);
                [weakMultySharingManager checkArrayWithQueueOfPosts];
            }

        } progressLoadingBlock:^(id currentNetworkType, float result) {
            
            float totalProgress = [weakMultySharingManager totalResultOfLoadingToSocialNetworks: arrayOfLoadingObjects withCurrentObject: currentNetworkType andResult: result];
             [[MUSProgressBar sharedProgressBar] setProgressViewSize:totalProgress / numberOfSocialNetworks];
            weakMultySharingManager.copyProgressLoading(totalProgress / numberOfSocialNetworks);
            if (totalProgress / numberOfSocialNetworks == 1) {
                [[MUSProgressBarEndLoading sharedProgressBarEndLoading] endProgressViewWithCountConnect:resultDictionary andImagesArray:newPost.imagesArray];
                weakMultySharingManager.copyComplition ([NSNumber numberWithInt:countConnectPosts], nil);
            }
        }];
        
        //});
    }
    
}

- (void) updatePost : (Post*) post toSocialNetworks : (NSArray*) arrayWithNetworks {
    __block NSMutableArray *arrayOfLoadingObjects = [self arrayOfLoadingObjectsFromNetworks: arrayWithNetworks];

    self.isPostLoading = YES;

    __block Post *postCopy = post;
    __block NSUInteger numberOfSocialNetworks = arrayWithNetworks.count;
    __block int counterOfSocialNetwork = 0;
    __block NSString *blockResultString = @"Result updating: \n";
    __weak MultySharingManager *weakMultySharingManager = self;
    __block int countConnectPosts = 0;
    __block NSDictionary *resultDictionary;
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        [socialNetwork sharePost: post withComplition:^(id result, NSError *error) {
            
            //networkpost create
            counterOfSocialNetwork++;
            NetworkPost *networkPost;
            
            if ([result isKindOfClass: [NetworkPost class]]) {
                networkPost = (NetworkPost*) result;
                [weakMultySharingManager updateCurrentNetworkPost: networkPost andArrayOfOldNetworkPosts: postCopy.networkPostsArray];
                blockResultString = [blockResultString stringByAppendingString: [NSString stringWithFormat: @"%@ - post status is %@ \n", [NSString socialNetworkNameOfPost: networkPost.networkType], [NSString reasonNameOfPost: networkPost.reason]]];
                if(networkPost.reason == MUSConnect){
                    countConnectPosts++;
                }
            }
            if (counterOfSocialNetwork == numberOfSocialNetworks) {
                
                resultDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:counterOfSocialNetwork], @"numberOfSocialNetworks", [NSNumber numberWithInt:countConnectPosts], @"countConnectPosts", nil];
               [[MUSProgressBarEndLoading sharedProgressBarEndLoading] endProgressViewWithCountConnect:resultDictionary andImagesArray:post.imagesArray];
                //weakMultySharingManager.copyComplition (blockResultString, error);
                [weakMultySharingManager checkArrayWithQueueOfPosts];
            }

        } progressLoadingBlock:^(id currentNetworkType, float result) {
            float totalProgress = [weakMultySharingManager totalResultOfLoadingToSocialNetworks: arrayOfLoadingObjects withCurrentObject: currentNetworkType andResult: result];
            [[MUSProgressBar sharedProgressBar] setProgressViewSize:totalProgress / numberOfSocialNetworks];
            weakMultySharingManager.copyProgressLoading(totalProgress / numberOfSocialNetworks);
            if (totalProgress / numberOfSocialNetworks == 1) {
                [[MUSProgressBarEndLoading sharedProgressBarEndLoading] endProgressViewWithCountConnect:resultDictionary andImagesArray:post.imagesArray];
                weakMultySharingManager.copyComplition ([NSNumber numberWithInt:countConnectPosts], nil);
            }
        }];
    }
}

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

- (void) checkArrayWithQueueOfPosts {
    [self.arrayWithQueueOfPosts removeObjectAtIndex: 0];
    if (self.arrayWithQueueOfPosts.count > 0) {
        NSDictionary *postDictionary = [self.arrayWithQueueOfPosts firstObject];
        [self sharePost: [postDictionary objectForKey: @"post"] toSocialNetworks: [postDictionary objectForKey: @"arrayWithNetworks"]];
    } else {
        self.isPostLoading = NO;
    }
}


//- (NSMutableArray *) arrayWithNetworks : (NSArray*) arrayOfNetworksType {
//    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray: arrayOfNetworksType];
//    NSArray *arrayWithNetworkWithoutDuplicates = [orderedSet array];
//    
//    NSMutableArray *arrayWithNetworks = [NSMutableArray new];
//    [arrayWithNetworkWithoutDuplicates enumerateObjectsUsingBlock:^(id obj, NSUInteger currentIndex, BOOL *stop) {
//        // If we repost post to another SN - we don't add SN with success reason to arrayWithNetworks
//        [arrayWithNetworks addObject:[SocialNetwork sharedManagerWithType: [arrayOfNetworksType[currentIndex] integerValue]]];
//    }];
//    return arrayWithNetworks;
//}

- (void) savePostImagesToDocument: (Post*) post {
    if (!post.imageUrlsArray) {
        post.imageUrlsArray = [NSMutableArray new];
    } else {
        [post.imageUrlsArray removeAllObjects];
    }
    post.imageUrlsArray = [[PostImagesManager manager] saveImagesToDocumentsFolderAndGetArrayWithImagesUrls: post.imagesArray];
}

- (void) updatePostInfoNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSInfoPostsDidUpDateNotification object:nil];
}

//- (void) startSharePostNotification {
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"StartSharePost" object:nil];
//}
//
//- (void) endSharePostNotificationWithObject : (NSDictionary*) resultDictionary {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndSharePost" object: resultDictionary];
//}



- (BOOL) queueOfPosts:(NSInteger)primaryKeyOfPost {
    for (NSDictionary *dictionary in self.arrayWithQueueOfPosts) {
        Post *currentPost = [dictionary objectForKey: @"post"];
        if (currentPost.primaryKey == primaryKeyOfPost) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray*) arrayOfLoadingObjectsFromNetworks : (NSArray*) arrayWithNetworks {
    NSMutableArray *arrayOfLoadingObjects = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrayWithNetworks count]; i++) {
        SocialNetwork *socialNetwork = [arrayWithNetworks objectAtIndex: i];
        //        NSNumber *totalLoading = [[NSNumber alloc] init];
        NSNumber *totalLoading = [NSNumber numberWithFloat: 0.000001];
        NSNumber *networkType = [NSNumber numberWithInt: socialNetwork.networkType];
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: networkType, @"networkType", totalLoading, @"totalLoading",nil];
        [arrayOfLoadingObjects addObject: mutableDictionary];
    }
    return arrayOfLoadingObjects;
}

- (float) totalResultOfLoadingToSocialNetworks : (NSMutableArray*) arrayOfLoadingObjects withCurrentObject : (id) currentNetworkType andResult : (float) result {
    for (int i = 0; i < arrayOfLoadingObjects.count; i++) {
        NSMutableDictionary *currentDictionary = [arrayOfLoadingObjects objectAtIndex: i];
        if ([currentDictionary objectForKey: @"networkType"] == currentNetworkType) {
            [currentDictionary setObject: [NSNumber numberWithFloat: result] forKey: @"totalLoading"];
            [arrayOfLoadingObjects replaceObjectAtIndex: i withObject: currentDictionary];
        }
        
    }
    float totalProgress = 0;
    for (int i = 0; i < [arrayOfLoadingObjects count]; i ++) {
        NSMutableDictionary *currentDictionary = [arrayOfLoadingObjects objectAtIndex: i];
        NSNumber *currentObject = [currentDictionary objectForKey: @"totalLoading"];
        //NSNumber *currentObject = [arrayOfLoadingObjects objectAtIndex: i];
        totalProgress += [currentObject floatValue];
    }
    return totalProgress;
}


@end
