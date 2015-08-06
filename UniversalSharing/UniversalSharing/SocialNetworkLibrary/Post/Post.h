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
@property (nonatomic, strong) NSString *likesCount;
/*!
 @abstract number of coments received after sending post
 */
@property (nonatomic, assign) CGFloat comentsCount;
/*!
 @abstract unique identifier of the user position location
 */
@property (nonatomic, assign) NSString *placeID;
/*!
 @abstract type of Social network. (like Facebook, Twitters, Vkontakte)
 */
@property (nonatomic, assign) NetworkType networkType;



@end
