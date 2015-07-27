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
        self.networkType = Twitter;
        if (![self obtainUserName]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
            [self obtainArrayUsersTwitter];
        }
    }
    return self;
}

- (ACAccountType*) accountType{
    ACAccountStore *accountStore = [ACAccountStore new];
    return [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
}

- (void) loginWithComplition :(Complition) block {
    self.copyComplition = block;
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    __weak TwitterNetwork *weakSell = self;
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(error)
            NSLog(@"error%@",error);
        
        if(granted) {
            [weakSell obtainArrayUsersTwitter];
        }
    }];
}

- (void) obtainArrayUsersTwitter {
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    self.accountsArray = [accountStore accountsWithAccountType:accountType];
    [[NSUserDefaults standardUserDefaults] setInteger:[self.accountsArray count] forKey:kTwitterUserCount];
    if ([self.accountsArray count] == 1)
    {
        self.twitterAccount = [self.accountsArray firstObject];
        if (![self obtainUserName])
            [self createUserName];
        [self obtainDataFromTwitter];
        
    } else
    {
        if (![self obtainUserName]) {
            [self actionSheet];
        }else {
            [self returnAccount];
            [self obtainDataFromTwitter];
        }
    }
}

- (void) actionSheet {
    
    UIActionSheet* sheet = [UIActionSheet new];
    sheet.title = @"Select TwitterAccount";
    sheet.delegate = self;
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
    for (int i = 0; i < [self.accountsArray count]; i++) {
        self.twitterAccount = self.accountsArray[i];
        [sheet addButtonWithTitle:self.twitterAccount.username];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    });
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != 0) {
        self.twitterAccount = self.accountsArray[buttonIndex - 1];
        [self createUserName];
        [self obtainDataFromTwitter];
    }
}

- (void) returnAccount {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", [self obtainUserName]];
    NSArray *arrayPredicate = [self.accountsArray filteredArrayUsingPredicate:predicate];
    if (arrayPredicate.count > 0) {
        self.twitterAccount = [arrayPredicate firstObject];
    }
}

- (void) obtainDataFromTwitter {
    __weak TwitterNetwork *weakSell = self;
    NSMutableDictionary *parametrs = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self obtainUserName], @"screen_name", nil];
    SLRequest *followRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:kRequestUrlTwitter] parameters:parametrs];
    
    [followRequest setAccount:self.twitterAccount];
    [followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];
        
        weakSell.currentUser = [User createFromDictionary:dict andNetworkType : weakSell.networkType];
        weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
        weakSell.icon = weakSell.currentUser.photoURL;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSell.copyComplition)
                weakSell.copyComplition(weakSell, error);
            //[[NSNotificationCenter defaultCenter] postNotificationName:notificationReloadTableView object:nil];
        });
    }];
}

- (void) initiationPropertiesWithoutSession {
    self.title = @"Login Twitter";
    self.icon = @"TWimage.jpeg";
    self.isLogin = NO;
}

- (NSString*) obtainUserName {
    return [[NSUserDefaults standardUserDefaults]valueForKey:kTwitterUserName];
}

- (void) createUserName {
    [[NSUserDefaults standardUserDefaults] setObject:self.twitterAccount.username forKey:kTwitterUserName];
}

- (void) removeObjectFromUserDefault {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTwitterUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTwitterUserCount];
}

- (void) loginOut {
    [self removeObjectFromUserDefault];
    self.currentUser = nil;
    [self initiationPropertiesWithoutSession];
}

@end
