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
            return [UIImage imageNamed: MUSApp_Image_Name_FBLikeImage_grey];
            break;
        case MUSVKontakt:
            return [UIImage imageNamed: MUSApp_Image_Name_VKLikeImage_grey];
            break;
        case MUSTwitters:
            return [UIImage imageNamed: MUSApp_Image_Name_TwitterLikeImage_grey];
            break;
        case MUSAllNetworks:
            break;
    }
    return nil;
}

+ (UIImage*) commentsIconByTypeOfSocialNetwork : (NetworkType) networkType {
    switch (networkType) {
        case MUSFacebook:
            return [UIImage imageNamed: MUSApp_Image_Name_CommentsImage_grey];
            break;
        case MUSVKontakt:
            return [UIImage imageNamed: MUSApp_Image_Name_CommentsImage_grey];
            break;
        case MUSTwitters:
            return [UIImage imageNamed: MUSApp_Image_Name_TwitterCommentsImage_grey];
            break;
        case MUSAllNetworks:
            break;
    }
    return nil;
}

+ (UIImage*) greyIconOfSocialNetworkByTypeOfSocialNetwork : (NetworkType) networkType {
    switch (networkType) {
        case MUSFacebook:
            return [UIImage imageNamed: MUSApp_Image_Name_FBIconImage_grey];
            break;
        case MUSVKontakt:
            return [UIImage imageNamed: MUSApp_Image_Name_VKIconImage_grey];
            break;
        case MUSTwitters:
            return [UIImage imageNamed: MUSApp_Image_Name_TwitterIconImage_grey];
            break;
        case MUSAllNetworks:
            break;
    }
    return nil;
}



@end

