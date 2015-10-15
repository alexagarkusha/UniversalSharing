//
//  SocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSSocialNetwork.h"
#import "MUSSocialManager.h"
#import "MUSDataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "NSError+MUSError.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "MUSPostImagesManager.h"
#import "MUSInternetConnectionManager.h"

@implementation MUSSocialNetwork

- (void)setNetworkType:(NetworkType)networkType {
    _networkType = networkType;
}

- (MUSUser *)currentUser {
    
    if (!_currentUser)
    {
        _currentUser = [[[MUSDataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUserWithNetworkType: _networkType]] firstObject];
    }
    
    return _currentUser;
    
}

- (void) loginWithComplition :(Complition) block {
    NSLog(@"This method must be overreaded in you class");
}

- (void) logout {
    NSLog(@"This method must be overreaded in you class");
}

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
    NSLog(@"This method must be overreaded in you class");
}

- (void) sharePost : (MUSPost*) post withComplition:(Complition)block loadingBlock:(LoadingBlock)loadingBlock {
    NSLog(@"This method must be overreaded in you class");
}

- (void) obtainPlacesArrayForLocation : (MUSLocation*) location withComplition : (Complition) block {
    NSLog(@"This method must be overreaded in you class");
}

- (void) updateNetworkPostWithComplition : (UpdateNetworkPostsBlock) updateNetworkPostsBlock {
    NSLog(@"This method must be overreaded in you class");
    
}

- (void) updateUserInSocialNetwork {
    if ([[MUSInternetConnectionManager connectionManager] isInternetConnection]){
        NSString *deleteImageFromFolder = _currentUser.photoURL;
        
        [self obtainUserInfoFromNetworkWithComplition:^(MUSSocialNetwork* result, NSError *error) {
            
            [[MUSPostImagesManager manager] removeImageFromFileManagerByImagePath: deleteImageFromFolder];
            [[MUSDataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUpdateUser: result.currentUser]];
            
        }];
    }
}


- (NSError*) errorConnection {
    return [NSError errorWithMessage: MUSConnectionError andCodeError: MUSConnectionErrorCode];
}




@end
