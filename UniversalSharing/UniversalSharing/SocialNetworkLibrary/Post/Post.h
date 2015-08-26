//
//  Post.h
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MUSSocialNetworkLibraryConstants.h"
#import "ImageToPost.h"
#import "Place.h"
@interface Post : NSObject

/*!
 @abstract unique post id is assigned after sending post to the social network.
*/
@property (nonatomic, assign) NSInteger postID;
/*!
 @abstract description of post.
 */
@property (nonatomic, strong) NSString *postDescription;
/*!
 @abstract array of Images to post (@class ImageToPost)
 */
@property (nonatomic, strong) NSArray *arrayImages;
/*!
 @abstract number of likes received after sending post
 */
@property (nonatomic, assign) NSInteger  likesCount;
/*!
 @abstract number of coments received after sending post
 */
@property (nonatomic, assign) NSInteger commentsCount;
/*!
 @abstract unique identifier of the user position location
 */
@property (nonatomic, assign) NSString *placeID;
/*!
 @abstract type of Social network. (like Facebook, Twitters, Vkontakte)
 */
@property (nonatomic, assign) NetworkType networkType;

///////////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, assign) NSInteger primaryKey;
@property (nonatomic, strong) NSMutableArray *arrayImagesUrl;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dateCreate;
@property (nonatomic, assign) ReasonType reason;
@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) Place *place;

@end
