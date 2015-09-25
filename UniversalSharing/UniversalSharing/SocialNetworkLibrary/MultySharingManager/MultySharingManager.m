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
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray: arrayOfNetworksType];
    NSArray *arrayWithNetworkWithoutDuplicates = [orderedSet array];
    
    NSMutableArray *arrayWithNetworks = [NSMutableArray new];
    [arrayWithNetworkWithoutDuplicates enumerateObjectsUsingBlock:^(id obj, NSUInteger currentIndex, BOOL *stop) {
        // If we repost post to another SN - we don't add SN with success reason to arrayWithNetworks
        [arrayWithNetworks addObject:[SocialNetwork sharedManagerWithType: [arrayOfNetworksType[currentIndex] integerValue]]];
    }];
    
    __block Post *postCopy = post;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        //dispatch_group_async(group, queue, ^{
            [socialNetwork sharePost: post withComplition:^(id result, NSError *error) {
                //networkpost create
                NetworkPost *networkPost;
                
                if ([result isKindOfClass: [NetworkPost class]]) {
                    networkPost = (NetworkPost*) result;
                }
                
                [[DataBaseManager sharedManager] saveNetworkPostToTableWithObject: networkPost];
                
//                NetworkPost *networkPost = [NetworkPost create];
//                if ([result isKindOfClass: [NetworkPost class]]) {
//                    networkPost = (NetworkPost*) result;
//                }
//                if (!error) {
//                    //set status
//                    NSLog(@"Social Network Name of Network = %@", socialNetwork.name);
//                    NSLog(@"TYPE of Network = %d", networkPost.networkType);
//                    NSLog(@"REASON of Network = %d", networkPost.reason);
//                    NSLog(@"Success ids = %@", networkPost.postID);
//                } else {
//                    NSLog(@"Social Network Name of Network = %@", socialNetwork.name);
//                    //set status
//                    NSLog(@"ERROR TYPE of Network = %d", networkPost.networkType);
//                    NSLog(@"ERROR REASON of Network = %d", networkPost.reason);
//                    NSLog(@"Error error = %@ result = %@", error, result);
//                }
            }];
        //});
    }
    
    dispatch_group_notify(group, queue, ^{
        //Save Post to DataBase After Send POST TO SN;
        block (nil, nil);
        [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
        NSLog(@"ALL Tasks complete");
    });
}

- (void) stopUpdatingPostWithObject : (id) object {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationStopUpdatingPost object: object];
}


@end
