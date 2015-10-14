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
#import "NetworkPost.h"

@interface Post : NSObject

/*!
 @abstract unique post id is assigned after sending post to the social network.
*/
@property (nonatomic, strong) NSString *postID;
/*!
 @abstract description of post.
 */
@property (nonatomic, strong) NSString *postDescription;
/*!
 @abstract array of Images to post (@class ImageToPost)
 */
@property (nonatomic, strong) NSMutableArray *imagesArray;
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
/*!
 @abstract unique identifier of the post in DataBase
 */
@property (nonatomic, assign) NSInteger primaryKey;
/*!
 @abstract array of urls images for documents folder
 */
@property (nonatomic, strong) NSMutableArray *imageUrlsArray;
/*!
 @abstract date create of post object
 */
@property (nonatomic, strong) NSString *dateCreate;
/*!
 @abstract place
 */
@property (strong, nonatomic) Place *place;

@property (strong, nonatomic) NSMutableArray *networkPostsArray;

@property (strong, nonatomic) NSMutableArray *networkPostIdsArray;

@property (strong, nonatomic) NSString *longitude;

@property (strong, nonatomic) NSString *latitude;

//===
+ (instancetype)create;

- (id)copy;

- (void) updateAllNetworkPostsFromDataBaseForCurrentPost;

- (void) saveIntoDataBase;

- (NSString*) convertArrayImagesUrlToString;

- (NSString *) convertArrayWithNetworkPostsIdsToString;

- (NSMutableArray*) convertArrayOfImagesUrlToArrayImagesWithObjectsImageToPost;

@end
