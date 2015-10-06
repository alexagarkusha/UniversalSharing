//
//  MultySharingManager.h
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import "Post.h"

@interface MultySharingManager : NSObject

+ (MultySharingManager*) sharedManager;

- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) arrayOfNetworksType withComplition : (Complition) block andComplitionProgressLoading :(ComplitionProgressLoading) blockLoading;
- (void) updateNetworkPostsWithComplition : (Complition) block;
- (BOOL) isPostInQueueOfPosts : (NSInteger) primaryKeyOfPost;

@end
