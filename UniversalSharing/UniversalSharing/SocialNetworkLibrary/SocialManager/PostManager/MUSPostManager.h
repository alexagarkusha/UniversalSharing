//
//  MUSPostManager.h
//  UniversalSharing
//
//  Created by U 2 on 30.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSPostManager : NSObject

+ (MUSPostManager*) manager;


- (NSArray*) arrayOfAllPosts;

- (NSArray*) updateArrayOfPost;

- (void) updateNetworkPosts;

@property (assign, nonatomic) BOOL needToRefreshPosts;


@end
