//
//  UIButton+MUSSocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIButton+MUSSocialNetwork.h"
#import "SocialManager.h"
#import "UIButton+LoadBackgroundImageFromNetwork.h"
#import "UIButton+CornerRadiusButton.h"

@implementation UIButton (MUSSocialNetwork)

- (id) init {
    self = [super init];
    if (self) {
        //self.buttonType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.frame = CGRectMake(6.0, 15.0, 75.0, 70.0);//while so
        self.backgroundColor = [UIColor lightGrayColor];
        [self cornerRadius:10];
        [self initiationSocialNetworkButtonForSocialNetwork:nil];
    }
    return self;
}

- (void) initiationSocialNetworkButtonForSocialNetwork :(SocialNetwork*) socialNetwork {
    SocialNetwork *currentSocialNetwork = socialNetwork;
    if (!currentSocialNetwork) {
        currentSocialNetwork = [SocialManager currentSocialNetwork];
    }
    
    __weak UIButton *socialNetworkButton = self;
    [currentSocialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
        SocialNetwork *currentSocialNetwork = (SocialNetwork*) result;
        User *currentUser = currentSocialNetwork.currentUser;
        [socialNetworkButton loadBackroundImageFromNetworkWithURL:[NSURL URLWithString: currentUser.photoURL]];
    }];
}

@end
