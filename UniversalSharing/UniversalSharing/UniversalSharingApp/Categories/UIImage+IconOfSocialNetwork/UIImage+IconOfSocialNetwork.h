//
//  UIImage+IconOfSocialNetwork.h
//  UniversalSharing
//
//  Created by U 2 on 03.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ConstantsApp.h"

@interface UIImage (IconOfSocialNetwork)

+ (UIImage*) iconOfSocialNetworkForPost : (Post*) currentPost;

@end
