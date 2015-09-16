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
#import "ReachabilityManager.h"
#import "NSError+MUSError.h"
#import "MUSDatabaseRequestStringsHelper.h"

@implementation SocialNetwork

+ (SocialNetwork*) sharedManagerWithType :(NetworkType) networkType {
    SocialNetwork *socialNetwork = nil;
    switch (networkType) {
        case Facebook:{
            socialNetwork = [FacebookNetwork sharedManager];
            break;
        }
        case Twitters:{
            socialNetwork = [TwitterNetwork sharedManager];
            break;
        }
        case VKontakt:{
            socialNetwork = [VKNetwork sharedManager];
            break;
        }
        default:
            break;
    }
    return socialNetwork;
}


- (void)setNetworkType:(NetworkType)networkType {
    _networkType = networkType;
}

- (void) loginWithComplition :(Complition) block {
}

- (void) loginOut {
}

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
}

- (void) obtainArrayOfPlaces : (Location*) location withComplition : (Complition) block {
}

- (void) sharePost : (Post*) post withComplition : (Complition) block {
}

- (void) updatePost {
    
}

- (void) setIsVisible:(BOOL)isVisible {
    
    _isVisible = isVisible;
    if (self.currentUser.isVisible != isVisible && self.currentUser) {
        
        self.currentUser.isVisible = isVisible;
        [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringUsersForUpdateWithObjectUser:self.currentUser]];
    }    
}

- (void) saveImageToDocumentsFolderAndFillArrayWithUrl :(Post*) post {
    if (!post.arrayImagesUrl) {
        post.arrayImagesUrl = [NSMutableArray new];
    } else {
        [post.arrayImagesUrl removeAllObjects];
    }
    
    [post.arrayImages enumerateObjectsUsingBlock:^(ImageToPost *image, NSUInteger index, BOOL *stop) {
        NSData *data = UIImagePNGRepresentation(image.image);
        //Get the docs directory
        NSString *filePath = @"image";
        filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]];
        filePath = [filePath stringByAppendingString:@".png"];
        [post.arrayImagesUrl addObject:filePath];
        
        [data writeToFile:[filePath obtainPathToDocumentsFolder:filePath] atomically:YES]; //Write the file
    }];
    [[DataBaseManager sharedManager] insertIntoTable:post];
}

- (void) removeUserFromDataBaseAndImageFromDocumentsFolder :(User*) user {
    [self removeImagesOfPostFromDocumentsFolder:user.clientID];
    [[DataBaseManager sharedManager] deleteUserByClientId:user.clientID];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath: [user.photoURL obtainPathToDocumentsFolder: user.photoURL] error: &error];
}

- (void) removeImagesOfPostFromDocumentsFolder :(NSString*) userId {
    __block NSError *error;
    NSArray *arrayWithPostsOfUser = [[DataBaseManager sharedManager] obtainPostsFromDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringForPostWithUserId:userId]];
    [arrayWithPostsOfUser enumerateObjectsUsingBlock:^(Post *post, NSUInteger idx, BOOL *stop) {
        
        if (![[post.arrayImagesUrl firstObject] isEqualToString: @""] && post.arrayImagesUrl.count > 0) {
                [post.arrayImagesUrl enumerateObjectsUsingBlock:^(NSString *urlImage, NSUInteger idx, BOOL *stop) {
                    [[NSFileManager defaultManager] removeItemAtPath: [urlImage obtainPathToDocumentsFolder: urlImage] error: &error];
            
            }];
        }
    }];
    
    
}

- (BOOL) obtainCurrentConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    
    if (!isReachableViaWiFi && !isReachable){
        return NO;
    }
    return YES;
}
- (void) savePostDataBaseWithReason :(ReasonType) reason andPost :(Post*) post {
    post.reason = reason;
    [self saveImageToDocumentsFolderAndFillArrayWithUrl:post];
}

- (void) updatePostDataBaseWithReason :(ReasonType) reason andPost :(Post*) post {
    post.reason = reason;
    //[[DataBaseManager sharedManager] editPost: post];
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringPostsForUpdateWithObjectPost:post]];
    [[DataBaseManager sharedManager] editObjectAtDataBaseWithRequestString:[MUSDatabaseRequestStringsHelper createStringLocationsForUpdateWithObjectPost:post]];
}

- (void) saveOrUpdatePost : (Post*) post withReason : (ReasonType) reason {
    if (!post.primaryKey) {
        [self savePostDataBaseWithReason: reason andPost: post];
    } else {
        [self updatePostDataBaseWithReason: reason andPost: post];
    }
}

- (NSError*) errorConnection {
    return [NSError errorWithMessage: musErrorConnection andCodeError: musErrorConnectionCode];
}


- (void) stopUpdatingPostWithObject : (id) object {
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSNotificationStopUpdatingPost object: object];
}

@end
