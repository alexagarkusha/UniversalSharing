//
//  LoginManager.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSSocialManager.h"
#import "MUSSocialNetworkLibraryConstants.h"
#import "MUSDataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"

@interface MUSSocialManager()

@property (strong, nonatomic)   NSArray           *accountsArray;
@property (strong, nonatomic)   NSDictionary      *networksDictinary;

@end

static MUSSocialManager *model = nil;

@implementation MUSSocialManager

+ (MUSSocialManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSSocialManager alloc] init];
    });
    return  model;
}

- (NSArray *) accountsArray
{
    if (!_accountsArray) {
        [self p_configureAccounts];
    }
    return _accountsArray;
}

- (void) configurateWithNetworkClasses: (NSDictionary*) networksWithKeys
{
    self.networksDictinary = [networksWithKeys copy];
}

- (void) p_configureAccounts {
    
    NSAssert(self.networksDictinary.count == 0, @"Setup networks first");

    NSMutableArray *networksArray = [NSMutableArray array];
    
    NSArray *keys = [[self.networksDictinary allKeys]sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber *key in keys) {
        Class networkClass = [self.networksDictinary objectForKey:key];
        [networksArray addObject:[networkClass sharedManager]];
    }
    
    self.accountsArray = networksArray;
}


- (NSMutableArray *) allNetworks
{
    return [NSMutableArray arrayWithArray:self.accountsArray];
}


- (NSMutableArray *) networksForKeys: (NSArray *) keysArray
{
    NSMutableArray *networksArray = [NSMutableArray array];
    
    for (NSNumber *key in keysArray) {
        Class networkClass = [self.networksDictinary objectForKey:key];
        [networksArray addObject:[networkClass sharedManager]];
    }
    return networksArray;
}

//- (SocialNetwork*) networkForKey: (NSNumber*) key {
//    
//    Class networkClass = [self.networksDictinary objectForKey:key];
//    
//    return (SocialNetwork*) [networkClass sharedManager];
//}


@end
