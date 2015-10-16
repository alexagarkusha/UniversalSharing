//
//  NSError+MUSError.h
//  UniversalSharing
//
//  Created by U 2 on 05.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSSocialNetworkLibraryConstants.h"

@interface NSError (MUSError)

/*!
 @abstract return an instance of the Error.
 @param message - error description.
 @param code - error code.
 */

+ (NSError*) errorWithMessage : (NSString*) message andCodeError : (NSInteger) code;


@end
