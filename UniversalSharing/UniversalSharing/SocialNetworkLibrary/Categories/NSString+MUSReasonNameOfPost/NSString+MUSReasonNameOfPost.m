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
        case Connect:
            return musReasonName_Shared;
            break;
        case ErrorConnection:
            return musReasonName_Error;
            break;
        case Offline:
            return musReasonName_Offline;
            break;
        default:
            break;
    }
    return nil;
}

@end