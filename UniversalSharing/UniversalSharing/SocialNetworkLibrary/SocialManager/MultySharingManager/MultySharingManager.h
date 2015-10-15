//
//  MultySharingManager.h
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import "MUSPost.h"

typedef void (^StartLoadingBlock)(MUSPost *post);
typedef void (^MultySharingResultBlock)(NSDictionary *multyResultDictionary, MUSPost *post);


@interface MultySharingManager : NSObject

+ (MultySharingManager*) sharedManager;

- (void) sharePost : (MUSPost*) post toSocialNetworks : (NSArray*) networksTypesArray withMultySharingResultBlock : (MultySharingResultBlock) multySharingResultBlock startLoadingBlock : (StartLoadingBlock) startLoadingBlock progressLoadingBlock :(ProgressLoadingBlock) progressLoadingBlock;

- (BOOL) isQueueContainsPost : (NSInteger) primaryKeyOfPost;


@end
