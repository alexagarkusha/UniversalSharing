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

typedef void (^StartLoadingBlock)(Post *post);
typedef void (^MultySharingResultBlock)(NSDictionary *multyResultDictionary, Post *post);


@interface MultySharingManager : NSObject

+ (MultySharingManager*) sharedManager;

- (void) sharePost : (Post*) post toSocialNetworks : (NSArray*) networksTypesArray withMultySharingResultBlock : (MultySharingResultBlock) multySharingResultBlock startLoadingBlock : (StartLoadingBlock) startLoadingBlock progressLoadingBlock :(ProgressLoadingBlock) progressLoadingBlock;

- (BOOL) isQueueContainsPost : (NSInteger) primaryKeyOfPost;


@end
