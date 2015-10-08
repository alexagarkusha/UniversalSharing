//
//  NetworkPost.h
//  UniversalSharing
//
//  Created by Roman on 9/25/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface NetworkPost : NSObject
/*!
 @abstract unique post id is assigned after sending post to the social network.
 */
@property (nonatomic, strong) NSString *postID;
/*!
 @abstract number of likes received after sending post
 */
@property (nonatomic, assign) NSInteger  likesCount;
/*!
 @abstract number of coments received after sending post
 */
@property (nonatomic, assign) NSInteger commentsCount;
/*!
 @abstract type of Social network. (like Facebook, Twitters, Vkontakte)
 */
@property (nonatomic, assign) NetworkType networkType;

@property (nonatomic, assign) ReasonType reason;

@property (nonatomic, strong) NSString *dateCreate;

@property (nonatomic, assign) NSInteger primaryKey;

@property (nonatomic, strong) NSString *stringReasonType;

+ (instancetype)create;

@end
