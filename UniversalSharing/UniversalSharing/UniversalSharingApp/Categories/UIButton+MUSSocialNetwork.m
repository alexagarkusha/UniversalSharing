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
#import <objc/runtime.h>
#import "MUSShareViewController.h"

static void * delegatePropertyKey = &delegatePropertyKey;

@interface UIButton() 

@property (strong, nonatomic) NSMutableArray *socialNetworkAccountsArray;
@property (strong, nonatomic) NSArray *arrayWithNetworks;

//@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@end

@implementation UIButton (MUSSocialNetwork)
//@dynamic actionDelegate;
- (id) init {
    self = [super init];
    if (self) {
        //self.buttonType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.frame = CGRectMake(6.0, 15.0, 75.0, 70.0);
        self.backgroundColor=[UIColor blueColor];
        [self cornerRadius:10];
        [self initiationSocialNetworkButtonForSocialNetwork:nil];
        
//         self.arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
//        self.socialNetworkAccountsArray = [NSMutableArray new];
    }
        return self;
}

- (id) actionDelegate {
    return objc_getAssociatedObject(self, delegatePropertyKey);
}

- (void)setActionDelegate:(id)actionDelegate {
    objc_setAssociatedObject(self, delegatePropertyKey, actionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



//- (void)changeSocialNetworkAccount:(id)sender{
//    MUSShareViewController *vc = [MUSShareViewController new];
//    [vc showUserAccountsInActionSheet];
//}

//- (void) showUserAccountsInActionSheet {
//   //[self.socialNetworkAccountsArray removeAllObjects];
//    UIActionSheet* sheet = [UIActionSheet new];
//    sheet.title = @"Select account";
//    sheet.delegate = self.actionDelegate;
//    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
//[sheet addButtonWithTitle: @"lalalal"];
////    for (int i = 0; i < [[[SocialManager sharedManager] networks: self.arrayWithNetworks] count]; i++) {
////        SocialNetwork *socialNetwork = [[[SocialManager sharedManager] networks: self.arrayWithNetworks] objectAtIndex:i];
////        if (socialNetwork.isLogin && !socialNetwork.isVisible) {
////            NSString *buttonTitle = [NSString stringWithFormat:@"%@", NSStringFromClass([socialNetwork class])];
////            [sheet addButtonWithTitle: buttonTitle];
////            [self.socialNetworkAccountsArray addObject:socialNetwork];
////        }
////    }
//    
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
//}
//
//- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
////    if ( buttonIndex != 0 ) {
////        _currentSocialNetwork = [self.socialNetworkAccountsArray objectAtIndex: buttonIndex - 1];
////        [self initiationSocialNetworkButtonForSocialNetwork];
////    }
//    
//}

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
