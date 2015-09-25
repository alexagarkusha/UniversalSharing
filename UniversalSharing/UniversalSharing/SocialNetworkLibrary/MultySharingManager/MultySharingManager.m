//
//  MultySharingManager.m
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MultySharingManager.h"
#import "SocialNetwork.h"


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
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (SocialNetwork *socialNetwork in arrayWithNetworks) {
        dispatch_group_async(group, queue, ^{
            [socialNetwork sharePost: post withComplition:^(id result, NSError *error) {
                //networkpost create
                if (!error) {
                    //set status
                    NSLog(@"Success");
                } else {
                    //set status
                    NSLog(@"Error");
                }
            }];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        //Save Post to DataBase;
        block (nil, nil);
        [self stopUpdatingPostWithObject: [NSNumber numberWithInteger: post.primaryKey]];
        NSLog(@"ALL Tasks complete");
    });
}

- (void) stopUpdatingPostWithObject : (id) object {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationStopUpdatingPost object: object];
}


@end
