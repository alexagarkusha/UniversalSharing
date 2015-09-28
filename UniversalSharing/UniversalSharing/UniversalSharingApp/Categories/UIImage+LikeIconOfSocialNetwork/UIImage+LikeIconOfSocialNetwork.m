//
//  UIImage+LikeIconOfSocialNetwork.m
//  UniversalSharing
//
//  Created by U 2 on 28.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImage+LikeIconOfSocialNetwork.h"
#import "ConstantsApp.h"

@implementation UIImage (LikeIconOfSocialNetwork)

+ (UIImage*) likeIconOfSocialNetwork : (NetworkType) networkType {
    switch (networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_FBLikeImage];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKLikeImage];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterLikeImage];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}


@end
