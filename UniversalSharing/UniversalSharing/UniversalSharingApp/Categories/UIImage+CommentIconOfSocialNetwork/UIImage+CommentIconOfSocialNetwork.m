//
//  UIImage+CommentIconOfSocialNetwork.m
//  UniversalSharing
//
//  Created by U 2 on 29.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIImage+CommentIconOfSocialNetwork.h"
#import "ConstantsApp.h"

@implementation UIImage (CommentIconOfSocialNetwork)

+ (UIImage*) commentIconOfSocialNetwork : (NetworkType) networkType {
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
