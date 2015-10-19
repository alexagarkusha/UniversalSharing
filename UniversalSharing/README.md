# Universal Social Network Sharing


Main features of this library are :

1. Send the post to multiple social networks at the same time;
2. Create a queue of posts to be sent to the social network, if your Internet connection does not have a high speed or you want to send several different posts at the same time;
3. Save posts were made in the application into database;
4. Update likes and comments count for posts were made in application.

## Requirements
Minimum iOS Target - iOS 8.x

## Architecture

### SocialNetwork
- MUSSocialNetwork 

### Managers
- MUSDataBaseManager
- MUSInternetConnectionManager
- MUSMultiSharingManager
- MUSPostManager
- MUSPostImagesManager
- MUSSocialManager

## Usage

In order to start working with the library:

1. Import SocialNetworkLibrary folder into your project.
2. Add `MUSSocialNetworkLibraryHeader.h` to your `AppDelegate` file.
3. Add your social networks in the project, which will be inheritors of `MUSSocialNetwork` class.
4. Setup your Social Networks types in `MUSConstantsApp.h`. As shown below: 

 ```objective-c
 // Example of settings types social networks.
 typedef NS_ENUM (NSInteger, NetworkType) {
     MUSAllNetworks,
     MUSFacebook,
     MUSTwitters,
     MUSVKontakt
 };
 ```
5. Set up MUSSocialManager, as shown in the example below:

 ```objective-c
 NSDictionary *networksDictionary = @{@(MUSFacebook) : [FacebookNetwork class],
 									   @(MUSTwitters) : [TwitterNetwork class],
 									   @(MUSVKontakt) : [VKNetwork class]};
     
 [[MUSSocialManager sharedManager] configurateWithNetworkClasses: networksDictionary];
 ```

### MUSSocialNetwork
It contains information about SocialNetwork. This class should be the parent of any social network, which you want to add in your application.

### MultiSharingManager
MultiSharingManager allows you to send the post to multiple social networks. Also, this manager creates a queue of posts to be sent to the social network, if your Internet connection does not have a high speed or you want to send several different posts at the same time. It is enough to call the **sharePost** method and pass it an object type **Post** and an array of active social network types.

```objective-c
[[MultiSharingManager sharedManager] sharePost: self.post toSocialNetworks: _arrayChosenNetworksForPost withMultiSharingResultBlock:^(NSDictionary *multiResultDictionary, Post *post)  {
    
    // Result of loading Post into Social Networks
    NSLog(@"result = %@", multiResultDictionary);
    
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
[[MultiSharingManager sharedManager] isQueueContainsPost: post.primaryKey];
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


#### Get All Social Networks array.

```objective-c
[[MUSSocialManager sharedManager] allNetworks];
```
## License

```objective-c
The MIT License (MIT)

Copyright © 2015 Mobindustry

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
