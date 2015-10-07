//
//  UIImage+IconOfSocialNetwork.m
//  UniversalSharing
//
//  Created by U 2 on 03.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImage+IconOfSocialNetwork.h"

@implementation UIImage (IconOfSocialNetwork)

+ (UIImage*) iconOfSocialNetworkForNetworkPost : (NetworkPost*) networkPost {
    switch (networkPost.networkType) {
        case Facebook:
            return [UIImage imageNamed: musAppImage_Name_FBIconImage_grey];
            break;
        case VKontakt:
            return [UIImage imageNamed: musAppImage_Name_VKIconImage_grey];
            break;
        case Twitters:
            return [UIImage imageNamed: musAppImage_Name_TwitterIconImage_grey];
            break;
        case AllNetworks:
            break;
    }
    return nil;
}



@end
