//
//  NSError+MUSError.m
//  UniversalSharing
//
//  Created by U 2 on 05.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSError+MUSError.h"

@implementation NSError (MUSError)

+ (NSError*) errorWithMessage : (NSString*) message andCodeError : (NSInteger) code {
    return [NSError errorWithDomain: MUSErrorWithDomainUniversalSharing code: code userInfo: @{ NSLocalizedFailureReasonErrorKey: message} ];
}


@end
