//
//  NSString+MUSSocialNetworkNameOfPost.m
//  UniversalSharing
//
//  Created by U 2 on 27.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+MUSSocialNetworkNameOfPost.h"

@implementation NSString (MUSSocialNetworkNameOfPost)

+ (NSString*) socialNetworkNameOfPost : (NetworkType) networkType {
    switch (networkType) {
        case MUSFacebook:
            return MUSFacebookName;
            break;
        case MUSVKontakt:
            return MUSVKName;
        default:
            return MUSTwitterName;
            break;
    }
}


@end
