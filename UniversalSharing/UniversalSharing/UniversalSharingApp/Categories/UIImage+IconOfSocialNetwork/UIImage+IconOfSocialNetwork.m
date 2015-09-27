//
//  UIImage+IconOfSocialNetwork.m
//  UniversalSharing
//
//  Created by U 2 on 03.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImage+IconOfSocialNetwork.h"

@implementation UIImage (IconOfSocialNetwork)

+ (UIImage*) iconOfSocialNetworkForPost : (Post*) currentPost {
    switch (currentPost.networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_FBIconImage];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKIconImage];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterIconImage];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}

+ (UIImage*) iconOfSocialNetworkForNetworkPost : (NetworkPost*) networkPost {
    switch (networkPost.networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_FBIconImage];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKIconImage];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterIconImage];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}



@end
