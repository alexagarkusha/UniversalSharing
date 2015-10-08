//
//  NetworkPost.m
//  UniversalSharing
//
//  Created by Roman on 9/25/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NetworkPost.h"

@implementation NetworkPost

+ (instancetype)create
{
    NetworkPost *networkPost = [[NetworkPost alloc] init];
   
    networkPost.postID = @"";
    networkPost.likesCount = 0;
    networkPost.commentsCount = 0;
    networkPost.networkType = AllNetworks;
    networkPost.reason = AllReasons;
    networkPost.primaryKey = 0;
    networkPost.dateCreate = @"";
    networkPost.stringReasonType = @"";
    return networkPost;
}

- (NSString *) stringReasonType {
    if (!_reason) {
        return @"";
    }
    switch (_reason) {
        case Connect:
            return @"Published";
            break;
        case ErrorConnection:
            return @"Failed";
            break;
        case Offline:
            return @"Offline";
            break;
        default:
            break;
    }
    return @"";
}




@end
