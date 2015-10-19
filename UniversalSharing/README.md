## How To Get Started 
	Download UniversalSharing and try out the included iPhone example apps.

## Requirements
	Minimum iOS Target - iOS 8.

## Architecture

### SocialNetwork
- MUSSocialNetwork 

### Model 
- MUSNetworkPost
- MUSImageToPost
- MUSLocation
- MUSPlace
- MUSPost
- MUSUser

### Managers
- MUSDataBaseManager
- MUSInternetConnectionManager
- MUSMultySharingManager
- MUSPostManager
- MUSPostImagesManager
- MUSSocialManager


## USAGE

### MUSSocialNetwork
	It contains information about SocialNetwork. This class should be the parent of any social network, which you want to add in your application.

### NetworkPost
	It contains information about number of likes and comments from each social network for POST object.

### ImageToPost
	It contains information about post image. It has next property: image, quality and image type (JPEG or PNG).

## Location
	It contains information about post location. It has next property: **latitude**, **longitude**, **distance**, **type** and **q** (string search).

### Place
	It contains information about post place - we get as a result of the request to the social network. It has next property: **fullName**, **placeID**, **country**, **placeType**, **city**, **longitude**, **latitude**.

### Post
	Object POST contains complete information about the post, which includes **a description**, **images array** and **geolocation** of the post. Also, this object contains information about the number of **likes** and **comments** received from the social network. **Note**: the property **Primary Key** given automatically by **database**.

### User
	Object User contains complete information about user of active social network, which includes **an username**, **first name**, **last name**, **client ID**, **photo URL** and **network type**.

### MultySharingManager
	MultiSharingManager allows you to send the post to multiple social networks. Also, this manager creates a queue of posts to be sent to the social network, if your Internet connection does not have a high speed or you want to send several different posts at the same time. It is enough to call the **sharePost** method and pass it an object type **Post** and an array of active social network types.

```objective-c
[[MultySharingManager sharedManager] sharePost: self.post toSocialNetworks: _arrayChosenNetworksForPost withMultySharingResultBlock:^(NSDictionary *multyResultDictionary, Post *post)  {
    
    // Result of loading Post into Social Networks
    NSLog(@"result = %@", multyResultDictionary);
    
    // Loaded Post into Social Networks
    NSLog(@"post = %@", post);
    
} startLoadingBlock:^(Post *post) {
    
    // Current post that started loaded into social networks current post that started loaded into social networks
    NSLog(@"post = %@", post);
    
} progressLoadingBlock:^(float result) {
    
    // Progress of loading = (total progress of loading in all Chosen Social Networks / number of Chosen Social Networks). MAX value = 1.0
    NSLog(@"result = %f", result);
    
}];
```

#### Check post - whether it is in loading queue posts or NOT

```objective-c
[[MultySharingManager sharedManager] isQueueContainsPost: post.primaryKey];
```

### PostManager
	This manager is responsible for all posts made in the application. Manager can returns an array of all posts and updates them. It is also possible to obtain and update all likes and comments count for shared posts.

#### Update Posts array from Data Base

```objective-c
[[MUSPostManager manager] updatePostsArray];
```

#### Returned Network posts array for chosen network type.

```objective-c
[[MUSPostManager manager] networkPostsArrayForNetworkType: MUSTwitters];
```

#### Updating all network Posts in all Active Social Networks.

```objective-c
[[MUSPostManager manager] updateNetworkPostsWithComplition:^(id result, NSError *error) {
    
    // Returned result of updating
    NSLog(@"result = %@", result);
    
}];
```

#### Deleting all Network Post from Data Base for chosen Network Type.

```objective-c
[[MUSPostManager manager] deleteNetworkPostForNetworkType: MUSTwitters];
```

### MUSSocialManager
	This manager is responsible for all social networks in the application. Manager can returns an array of all networks.

#### Example of settings types social networks.

```objective-c
typedef NS_ENUM (NSInteger, NetworkType) {
    MUSAllNetworks,
    MUSFacebook,
    MUSTwitters,
    MUSVKontakt
};
```

#### An example of how to configure social manager.

```objective-c
NSDictionary *networksDictionary = @{@(MUSFacebook) : [FacebookNetwork class],
									 @(MUSTwitters) : [TwitterNetwork class],
                                     @(MUSVKontakt) : [VKNetwork class]};
    
[[MUSSocialManager sharedManager] configurateWithNetworkClasses: networksDictionary];
```

#### Get All Social Networks array.

```objective-c
[[MUSSocialManager sharedManager] allNetworks];
```
