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
            return musAppReasonType_Published;
            break;
        case ErrorConnection:
            return musAppReasonType_Error;
            break;
        case Offline:
            return musAppReasonType_Offline;
            break;
        default:
            break;
    }
    return nil;
}

@end
