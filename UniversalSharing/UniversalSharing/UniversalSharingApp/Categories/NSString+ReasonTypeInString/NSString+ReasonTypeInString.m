//
//  NSString+ReasonTypeInString.m
//  UniversalSharing
//
//  Created by U 2 on 03.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+ReasonTypeInString.h"
#import "ConstantsApp.h"

@implementation NSString (ReasonTypeInString)


+ (NSString*) reasonTypeInString : (ReasonType) reasonType {
    switch (reasonType) {
        case Connect:
            return musAppFilter_Title_Shared;
            break;
        case ErrorConnection:
            return musAppFilter_Title_Error;
            break;
        case Offline:
            return musAppFilter_Title_Offline;
            break;
        default:
            break;
    }
    return nil;
}


@end
