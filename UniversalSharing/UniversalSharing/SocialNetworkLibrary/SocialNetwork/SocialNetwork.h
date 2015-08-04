//
//  SocialNetwork.h
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Post.h"
#import "Location.h"
#import "MUSSocialNetworkLibraryConstants.h"

@interface SocialNetwork : NSObject

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL isVisible;

@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) NetworkType networkType;

+ (SocialNetwork*) sharedManagerWithType :(NetworkType) networkType;

#warning "What this method do?"
+ (SocialNetwork*) currentSocialNetwork;

- (void) loginWithComplition :(Complition) block;
- (void) obtainInfoFromNetworkWithComplition :(Complition) block;
- (void) loginOut;
- (void) setNetworkType:(NetworkType)networkType;
- (void) obtainArrayOfPlaces : (Location*) location withComplition : (ComplitionPlaces) block;

- (void) sharePost : (Post*) post withComplition : (Complition) block;



@end
