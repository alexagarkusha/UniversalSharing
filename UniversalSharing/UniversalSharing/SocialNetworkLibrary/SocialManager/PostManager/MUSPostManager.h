//
//  MUSPostManager.h
//  UniversalSharing
//
//  Created by U 2 on 30.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface MUSPostManager : NSObject

+ (MUSPostManager*) manager;

- (void) updateArrayOfPost;

- (void) deleteNetworkPostForNetworkType : (NetworkType) networkType;

@property (assign, nonatomic) BOOL needToRefreshPosts;

@property (strong, nonatomic, readonly) NSMutableArray *arrayOfPosts;

@end
