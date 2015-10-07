//
//  LoginManager.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialManager.h"
#import "MUSSocialNetworkLibraryConstants.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"
@interface SocialManager()

@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) NSMutableArray *arrayLogin;
@property (strong, nonatomic) NSMutableArray *arrayHidden;
@property (strong, nonatomic) NSMutableArray *arrayUnactive;

@property (strong, nonatomic) NSDictionary *networksDictinary;
@end

static SocialManager *model = nil;

@implementation SocialManager
+ (SocialManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SocialManager alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSArray *)accountsArray
{
    if (!_accountsArray) {
        [self p_configureAccounts];
    }
    return _accountsArray;
}

- (void)setupNetworksClass:(NSDictionary *)networksWithKeys
{
    self.networksDictinary = [networksWithKeys copy];
}

- (void) p_configureAccounts {
    
    if (self.networksDictinary.count == 0) {
        NSAssert(NO, @"Setup networks first");
    }
    
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


@end
