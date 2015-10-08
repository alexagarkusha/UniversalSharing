//
//  NSString+MUSReasonNameOfPost.m
//  UniversalSharing
//
//  Created by U 2 on 26.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+MUSReasonNameOfPost.h"

@implementation NSString (MUSReasonNameOfPost)

+ (NSString*) reasonNameOfPost : (ReasonType) reasonType {
    switch (reasonType) {
        case MUSConnect:
            return MUSReasonName_Shared;
            break;
        case MUSErrorConnection:
            return MUSReasonName_Error;
            break;
        case MUSOffline:
            return MUSReasonName_Offline;
            break;
        default:
            break;
    }
    return nil;
}

@end
