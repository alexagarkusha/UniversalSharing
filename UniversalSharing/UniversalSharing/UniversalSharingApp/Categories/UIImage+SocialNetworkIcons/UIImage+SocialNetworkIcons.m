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

+ (UIImage*) commentsIconByTypeOfSocialNetwork : (NetworkType) networkType {
    switch (networkType) {
        case MUSFacebook:
            return [UIImage imageNamed: musAppImage_Name_CommentsImage_grey];
            break;
        case MUSVKontakt:
            return [UIImage imageNamed: musAppImage_Name_CommentsImage_grey];
            break;
        case MUSTwitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterCommentsImage_grey];
            break;
        case MUSAllNetworks:
            break;
    }
    return nil;
}

@end

