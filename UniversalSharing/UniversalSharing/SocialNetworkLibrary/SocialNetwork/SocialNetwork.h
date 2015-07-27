//
//  SocialNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "MUSSocialNetworkLibraryConstants.h"

@interface SocialNetwork : NSObject

@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) User *currentUser;

@property (assign, nonatomic) NetworkType networkType;

- (void) loginWithComplition :(Complition) block;
- (void) obtainDataWithComplition :(Complition) block;
- (void) loginOut;
- (void)setNetworkType:(NetworkType)networkType;

@end
