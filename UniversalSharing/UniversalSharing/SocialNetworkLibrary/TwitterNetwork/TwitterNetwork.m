//
//  TwitterNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/23/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "TwitterNetwork.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>

@interface TwitterNetwork () //<TWTRCoreOAuthSigning>

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
    [TwitterKit startWithConsumerKey:kConsumerKey consumerSecret:kConsumerSecret];
    //[Fabric with:@[[Twitter sharedInstance]]];
    [Fabric with:@[TwitterKit]];
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

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSell = self;

    [[TwitterKit APIClient] loadUserWithID:[[[Twitter sharedInstance ]session] userID]
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

   [TwitterKit logInWithCompletion:^(TWTRSession* session, NSError* error) {
        if (session) {
            [weakSell obtainInfoFromNetworkWithComplition:block];
        }
    }];
}

#warning "Need to add complition"
#warning "Check to share in background https://twittercommunity.com/t/post-a-tweet-programatically-custom-twtrcomposer-ios/34332"



- (void) sharePostToNetwork : (id) sharePost {
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:@"I tweeted from my App, LALALLALALA)"];
    [composer setImage:[UIImage imageNamed:@"TWimage.jpeg"]];
    
    // Called from a UIViewController
    [composer showFromViewController:[self vcForComposeTweet] completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

- (UIViewController*) vcForComposeTweet {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *vc=[window rootViewController];
    if(vc.presentedViewController)
        return vc.presentedViewController;
    else
        return vc;
}
- (void) initiationPropertiesWithoutSession {
    self.title = @"Login Twitter";
    self.icon = @"TWimage.jpeg";
    self.isLogin = NO;
    self.currentUser = nil;
}

- (void) loginOut {
    [[Twitter sharedInstance] logOut];
    [self initiationPropertiesWithoutSession];
}

@end
