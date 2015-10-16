//
//  AppDelegate.m
//  UniversalSharing
//
//  Created by Alexandra on 26.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "AppDelegate.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "ReachabilityManager.h"
#import "MUSConstantsApp.h"
#import "FacebookNetwork.h"
#import "TwitterNetwork.h"
#import "VKNetwork.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ReachabilityManager sharedManager];
    
    NSDictionary *networksDictionary = @{@(MUSFacebook) : [FacebookNetwork class],
                                         @(MUSTwitters) : [TwitterNetwork class],
                                         @(MUSVKontakt) : [VKNetwork class]};
    
    [[MUSSocialManager sharedManager] configurateWithNetworkClasses: networksDictionary];
    
    [MUSPostManager manager];
    
    [self p_setupTabBarController];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlString = [url absoluteString];
    urlString=[urlString substringToIndex:2];
    
    if ([urlString isEqualToString: MUSApp_AppDelegate_Url_Facebook]) {
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation];
    } else if([urlString isEqualToString:MUSApp_AppDelegate_Url_Vk]){
        [VKSdk processOpenURL:url fromApplication:sourceApplication];
    }
    return YES;
}



#pragma mark - Setup tabbarController

- (void)p_setupTabBarController
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedViewController=[tabBarController.viewControllers objectAtIndex: 1];
    [UITabBar appearance].tintColor = DARK_BROWN_COLOR;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary  dictionaryWithObjectsAndKeys: [UIColor darkGrayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary  dictionaryWithObjectsAndKeys:DARK_BROWN_COLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
}

@end
