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

//
//+ (SocialNetwork*) currentSocialNetwork {
//    SocialNetwork *currentSocialNetwork = nil;    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogin == %d AND isVisible == %d", YES, YES];
//    NSArray *filteredArray = [self.accountsArray filteredArrayUsingPredicate:predicate];
//    if (filteredArray.count > 0) {
//        currentSocialNetwork = (SocialNetwork*) [filteredArray firstObject];
//    }
//    return currentSocialNetwork;
//}

- (void)setupNetworksClass:(NSDictionary *)networksWithKeys
{
    self.networksDictinary = [networksWithKeys copy];
}

- (void)p_configureAccounts {
    
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



//- (NSMutableArray*) networks :(NSArray*) arrayWithNetwork {
//    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayWithNetwork];
//    NSArray *arrayWithNetworkWithoutDuplicates = [orderedSet array];
//    
//    NSMutableArray *arrayWithNetworks = [NSMutableArray new];
//    [arrayWithNetworkWithoutDuplicates enumerateObjectsUsingBlock:^(id obj, NSUInteger currentIndex, BOOL *stop) {
//        
//        [arrayWithNetworks addObject:[SocialNetwork sharedManagerWithType: [arrayWithNetwork[currentIndex] integerValue]]];
//        
//    }];
//    
//    return arrayWithNetworks;
//}

- (NSMutableArray *)networks
{
    return [NSMutableArray arrayWithArray:self.accountsArray];
}

- (NSMutableArray *)networksForKeys:(NSArray *)keysArray
{
    NSMutableArray *networksArray = [NSMutableArray array];
    
    for (NSNumber *key in keysArray) {
        Class networkClass = [self.networksDictinary objectForKey:key];
        [networksArray addObject:[networkClass sharedManager]];
    }
    return networksArray;
}

- (NSMutableArray*) activeSocialNetworks {
    NSMutableArray *activeSocialNetworksArray = [[NSMutableArray alloc] init];
    
    for (SocialNetwork *currentSocialNetwork in self.accountsArray) {
        if (currentSocialNetwork.isLogin) {
            [activeSocialNetworksArray addObject: currentSocialNetwork];
        }
    }
    return activeSocialNetworksArray;
}

//- (void) obtainNetworksWithComplition :(ComplitionWithArrays) block {
//    NSMutableArray *arrayWithNetworks = [self networks:@[@(Facebook), @(Twitters), @(VKontakt)]];
//     self.arrayLogin = [NSMutableArray new];
//     self.arrayHidden = [NSMutableArray new];
//     self.arrayUnactive = [NSMutableArray new];
//    [arrayWithNetworks enumerateObjectsUsingBlock:^(SocialNetwork *network, NSUInteger idx, BOOL *stop) {
//        if (network.isLogin && network.isVisible){
//            [self.arrayLogin addObject:network];
//            
//        } else if (network.isLogin && !network.isVisible){
//            [self.arrayHidden addObject:network];
//
//        } else{
//            [self.arrayUnactive addObject:network];
//        }
//            }];
//    
//    //sort
//    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"currentUser.indexPosition" ascending:YES];
//    //[self.arrayLogin sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
//    self.arrayLogin = [NSMutableArray arrayWithArray:[self.arrayLogin sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]]];
//    self.arrayHidden = [NSMutableArray arrayWithArray:[self.arrayHidden sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]]];
//    block(self.arrayLogin,self.arrayHidden,self.arrayUnactive,nil);
//}
//
//- (void) editNetworks {
//    [self.arrayLogin enumerateObjectsUsingBlock:^(SocialNetwork *network, NSUInteger index, BOOL *stop) {
//        if (network.currentUser.indexPosition != index) {
//        network.currentUser.indexPosition = index;
//            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringUsersForUpdateWithObjectUser:network.currentUser]];
//        }
//    }];
//    
//    [self.arrayHidden enumerateObjectsUsingBlock:^(SocialNetwork *network, NSUInteger index, BOOL *stop) {
//        if (network.currentUser.indexPosition != index) {
//            network.currentUser.indexPosition = index;
//            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringUsersForUpdateWithObjectUser:network.currentUser]];
//        }
//    }];
//    
//}


@end
