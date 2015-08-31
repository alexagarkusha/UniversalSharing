//
//  NSString+DateStringFromUNIXTimestamp.m
//  UniversalSharing
//
//  Created by U 2 on 25.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+DateStringFromUNIXTimestamp.h"

@implementation NSString (DateStringFromUNIXTimestamp)

+ (NSString*) dateStringFromUNIXTimestamp: (double) dateInDouble {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInDouble];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"MMMM dd, yyyy"];
    return [formatDate stringFromDate:date];
}



@end
