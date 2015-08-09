//
//  UIButton+MUSSocialNetwork.h
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialNetwork.h"

@interface UIButton (MUSSocialNetwork) <UIActionSheetDelegate>

- (void) initiationSocialNetworkButtonForSocialNetwork :(SocialNetwork*) socialNetwork;

@end
