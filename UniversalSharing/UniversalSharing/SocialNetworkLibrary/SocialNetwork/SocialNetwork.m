//
//  SocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/21/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "SocialNetwork.h"
#import "SocialManager.h"
#import "FacebookNetwork.h"
#import "VKNetwork.h"
#import "TwitterNetwork.h"
#import "DataBaseManager.h"
#import "NSString+MUSPathToDocumentsdirectory.h"
#import "NSError+MUSError.h"
#import "MUSDatabaseRequestStringsHelper.h"
#import "PostImagesManager.h"
#import "InternetConnectionManager.h"

@implementation SocialNetwork

- (void)setNetworkType:(NetworkType)networkType {
    _networkType = networkType;
}

- (void) loginWithComplition :(Complition) block {
}

- (void) logout {
}

- (void) obtainUserInfoFromNetworkWithComplition :(Complition) block {
}

- (void) sharePost : (Post*) post withComplition : (Complition) block progressLoadingBlock :(ProgressLoading) blockLoading{
}

- (void) obtainPlacesArrayForLocation : (Location*) location withComplition : (Complition) block {
}

- (void) updateNetworkPostWithComplition : (UpdateNetworkPostsComplition) block {
    
}

- (NSError*) errorConnection {
    return [NSError errorWithMessage: MUSConnectionError andCodeError: MUSConnectionErrorCode];
}

- (void) updateUserInSocialNetwork {
    if ([[InternetConnectionManager connectionManager] isInternetConnection]){
        NSString *deleteImageFromFolder = _currentUser.photoURL;
        
        [self obtainUserInfoFromNetworkWithComplition:^(SocialNetwork* result, NSError *error) {
            
            [[PostImagesManager manager] removeImageFromFileManagerByImagePath: deleteImageFromFolder];
            [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper stringForUpdateUser: result.currentUser]];
            
        }];
    }
}



@end
