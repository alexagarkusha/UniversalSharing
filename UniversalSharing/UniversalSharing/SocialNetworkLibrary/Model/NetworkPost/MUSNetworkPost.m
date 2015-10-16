//
//  NetworkPost.m
//  UniversalSharing
//
//  Created by Roman on 9/25/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSNetworkPost.h"
#import "MUSDataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "NSString+MUSCurrentDate.h"


@implementation MUSNetworkPost

+ (instancetype)create
{
    MUSNetworkPost *networkPost = [[MUSNetworkPost alloc] init];
   
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
    [[MUSDataBaseManager sharedManager] editObjectAtDataBaseWithRequestString: [MUSDatabaseRequestStringsHelper stringForUpdateNetworkPost : self]];
}

- (void) updateByNewNetworkPost: (MUSNetworkPost*) newNetworkPost {
    if (_networkType == newNetworkPost.networkType) {
        if (newNetworkPost.reason != MUSConnect) {
            return;
        } else {
            _reason = newNetworkPost.reason;
            _postID = newNetworkPost.postID;
            _likesCount = newNetworkPost.likesCount;
            _commentsCount = newNetworkPost.commentsCount;
            _dateCreate = [NSString currentDate];
            [self update];
        }
    }
}



@end
