//
//  SocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSSocialNetwork.h"
#import "SocialManager.h"
#import "FacebookNetwork.h"
#import "VKNetwork.h"
#import "TwitterNetwork.h"
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "NSError+MUSError.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "PostImagesManager.h"
#import "MUSInternetConnectionManager.h"

@implementation MUSSocialNetwork

- (void)setNetworkType:(NetworkType)networkType {
    _networkType = networkType;
}

//- (User*) currentUser {
//    if (!_isLogin) {
//        return nil;
//    } else {
//        return [[[DataBaseManager sharedManager] obtainUsersFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUserWithNetworkType: _networkType]] firstObject];
//    }
//}

- (void) loginWithComplition :(Complition) block {
}

- (void) logout {
}

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
}

- (void) sharePost : (MUSPost*) post withComplition : (Complition) block progressLoadingBlock :(ProgressLoading) blockLoading{
}

- (void) obtainPlacesArrayForLocation : (MUSLocation*) location withComplition : (Complition) block {
}

- (void) updateNetworkPostWithComplition : (UpdateNetworkPostsComplition) block {
    
}

- (void) updateUserInSocialNetwork {
    if ([[MUSInternetConnectionManager connectionManager] isInternetConnection]){
        NSString *deleteImageFromFolder = _currentUser.photoURL;
        
        [self obtainUserInfoFromNetworkWithComplition:^(MUSSocialNetwork* result, NSError *error) {
            
            [[PostImagesManager manager] removeImageFromFileManagerByImagePath: deleteImageFromFolder];
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUpdateUser: result.currentUser]];
            
        }];
    }
}


- (NSError*) errorConnection {
    return [NSError errorWithMessage: MUSConnectionError andCodeError: MUSConnectionErrorCode];
}




@end
