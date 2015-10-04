//
//  InternetConnectionManager.h
//  UniversalSharing
//
//  Created by U 2 on 25.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetConnectionManager : NSObject

+ (InternetConnectionManager*) manager;

- (BOOL) isInternetConnection;

@end
