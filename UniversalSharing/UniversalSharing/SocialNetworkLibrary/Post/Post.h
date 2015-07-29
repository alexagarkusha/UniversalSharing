//
//  Post.h
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface Post : NSObject

@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, assign) NetworkType networkType;
@property (nonatomic, strong) NSData *photoData;
@property (nonatomic, strong) NSString *likesCount;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat comentsCount;

@end
