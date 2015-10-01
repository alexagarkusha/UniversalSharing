//
//  MUSPostManager.m
//  UniversalSharing
//
//  Created by U 2 on 30.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostManager.h"
#import "DataBaseManager.h"
#import "MUSDatabaseRequestStringsHelper.h"

@interface MUSPostManager ()

@property (strong, nonatomic) NSArray *arrayOfPosts;

@end


static MUSPostManager *model = nil;

@implementation MUSPostManager

+ (MUSPostManager*) manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MUSPostManager alloc] init];
    });
    return  model;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.arrayOfPosts = [[NSArray alloc] initWithArray: [[[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForAllPosts]] mutableCopy]];
    }
    return self;
}

- (NSArray*) arrayOfAllPosts {
    return self.arrayOfPosts;
}

- (NSArray*) updateArrayOfPost {
    self.arrayOfPosts = [[NSArray alloc] initWithArray: [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString : [MUSDatabaseRequestStringsHelper createStringForAllPosts]]];
    return self.arrayOfPosts;
}

- (void) updateNetworkPosts {
    
}


@end
