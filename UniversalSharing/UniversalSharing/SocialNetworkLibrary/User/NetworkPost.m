//
//  NetworkPost.m
//  UniversalSharing
//
//  Created by Roman on 9/25/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NetworkPost.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"

@implementation NetworkPost

+ (instancetype)create
{
    NetworkPost *networkPost = [[NetworkPost alloc] init];
   
    networkPost.postID = @"";
    networkPost.likesCount = 0;
    networkPost.commentsCount = 0;
    networkPost.networkType = MUSAllNetworks;
    networkPost.reason = MUSOffline;
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
        case MUSConnect:
            return @"Published";
            break;
        case MUSErrorConnection:
            return @"Failed";
            break;
        case MUSOffline:
            return @"Offline";
            break;
        default:
            break;
    }
    return @"";
}

- (void) update {
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForUpdateNetworkPost : self]];
}



@end
