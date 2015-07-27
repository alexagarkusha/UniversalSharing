//
//  TwitterNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/23/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "TwitterNetwork.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <TwitterKit/TwitterKit.h>

@interface TwitterNetwork ()<UIActionSheetDelegate,UIAlertViewDelegate>
@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;
@end
static TwitterNetwork *model = nil;
@implementation TwitterNetwork
+ (TwitterNetwork*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[TwitterNetwork alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkType = Twitters;
        if (![[Twitter sharedInstance ]session]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
        }
    }
    return self;
}

- (void) obtainDataWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSell = self;

    [[[Twitter sharedInstance] APIClient] loadUserWithID:[[[Twitter sharedInstance ]session] userID]
                                              completion:^(TWTRUser *user,
                                                           NSError *error)
     {
         weakSell.currentUser = [User createFromDictionary:user andNetworkType : weakSell.networkType];
         weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
         weakSell.icon = weakSell.currentUser.photoURL;
         dispatch_async(dispatch_get_main_queue(), ^{
             block(weakSell, error);
             
         });
         
     }];
    
}

- (void) loginWithComplition :(Complition) block {
    self.isLogin = YES;
    __weak TwitterNetwork *weakSell = self;

    TWTRLogInButton* logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error) {
        if (session) {
            [weakSell obtainDataWithComplition:block];
        }
    }];
    [logInButton sendActionsForControlEvents:UIControlEventTouchUpInside];

}

- (void) initiationPropertiesWithoutSession {
    self.title = @"Login Twitter";
    self.icon = @"TWimage.jpeg";
    self.isLogin = NO;
}

- (void) loginOut {
    [[Twitter sharedInstance] logOut];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

@end
