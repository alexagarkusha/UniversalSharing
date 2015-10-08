//
//  UIImage+SocialNetworkIcons.m
//  UniversalSharing
//
//  Created by U 2 on 08.10.15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

#import "UIImage+SocialNetworkIcons.h"
#import "ConstantsApp.h"

@implementation UIImage (SocialNetworkIcons)

+ (UIImage*) likesIconByTypeOfSocialNetwork : (NetworkType) networkType {
    switch (networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_FBLikeImage_grey];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKLikeImage_grey];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterLikeImage_grey];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}

+ (UIImage*) commentsIconByTypeOfSocialNetwork : (NetworkType) networkType {
    switch (networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_CommentsImage_grey];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_CommentsImage_grey];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterCommentsImage_grey];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}

@end

