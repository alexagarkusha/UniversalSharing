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
        case MUSFacebook:
            return [UIImage imageNamed: musAppImage_Name_FBLikeImage_grey];
            break;
        case MUSVKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKLikeImage_grey];
            break;
        case MUSTwitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterLikeImage_grey];
            break;
        case MUSAllNetworks:
            break;
    }
    return nil;
}


@end
