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

- (void) updatePostsArray;

- (NSArray*) networkPostsArrayForNetworkType : (NetworkType) networkType;

- (void) updateNetworkPostsWithComplition : (Complition) block;

- (void) deleteNetworkPostForNetworkType : (NetworkType) networkType;

@property (strong, nonatomic, readonly) NSMutableArray *postsArray;

@end
