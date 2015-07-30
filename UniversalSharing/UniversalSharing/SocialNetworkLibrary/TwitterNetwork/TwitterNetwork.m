//
//  TwitterNetwork.m
//  UniversalSharing
//
//  Created by Roman on 7/23/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "TwitterNetwork.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>

@interface TwitterNetwork () //<TWTRCoreOAuthSigning>

@property (copy, nonatomic) Complition copyComplition;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;
@property (copy, nonatomic) Complition copyPostComplition;

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
    [TwitterKit startWithConsumerKey:kConsumerKey consumerSecret:kConsumerSecret];
    //[Fabric with:@[[Twitter sharedInstance]]];
    [Fabric with:@[TwitterKit]];
    if (self) {
        self.networkType = Twitters;
        if (![[Twitter sharedInstance ]session]) {
            [self initiationPropertiesWithoutSession];
        }
        else {
            self.isLogin = YES;
        }
    }
    return self;
}

- (void) obtainInfoFromNetworkWithComplition :(Complition) block {
    __weak TwitterNetwork *weakSell = self;

    [[TwitterKit APIClient] loadUserWithID:[[[Twitter sharedInstance ]session] userID]
                                              completion:^(TWTRUser *user,
                                                           NSError *error)
     {
         weakSell.currentUser = [User createFromDictionary:user andNetworkType : weakSell.networkType];
         weakSell.title = [NSString stringWithFormat:@"%@  %@", weakSell.currentUser.firstName, weakSell.currentUser.lastName];
         weakSell.icon = weakSell.currentUser.photoURL;
         dispatch_async(dispatch_get_main_queue(), ^{
             block(weakSell, error);
             
         });
         
     }];
    
}

- (void) loginWithComplition :(Complition) block {
    self.isLogin = YES;
    __weak TwitterNetwork *weakSell = self;

   [TwitterKit logInWithCompletion:^(TWTRSession* session, NSError* error) {
        if (session) {
            [weakSell obtainInfoFromNetworkWithComplition:block];
        }
    }];
}

#warning "Need to add complition"
#warning "Check to share in background https://twittercommunity.com/t/post-a-tweet-programatically-custom-twtrcomposer-ios/34332"



- (void) sharePost:(Post *)post withComplition:(Complition)block {
    self.copyPostComplition = block;
    if (!post.imageToPost.image) {
        [self postMessageToTwitter:post];
    } else {
        [self postImageToTwitter:post];
    }
}

- (void) postMessageToTwitter : (Post*) post {
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject: post.postDescription forKey:@"status"];
    //[parameters setObject: post.imageToPost.image forKey:@"image"];
    
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod: @"POST" URL: @"https://api.twitter.com/1.1/statuses/update.json" parameters: parameters error: nil];
    [client sendTwitterRequest:preparedRequest completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"response = %@", response);
        NSLog(@"data = %@", data);
        NSLog(@"ERROR = %@", connectionError);
        
    }];
}

- (void) postImageToTwitter : (Post*) post {
    NSString *endpoint = @"https://upload.twitter.com/1.1/media/upload.json";
    UIImage *image = post.imageToPost.image;
    NSData* imageData = UIImagePNGRepresentation(image);
    NSDictionary *parameters = @{@"media":[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]};
    NSError *error = nil;
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSURLRequest *request = [client URLRequestWithMethod:@"POST"
                                                 URL:endpoint
                                          parameters:parameters
                                               error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
[   client sendTwitterRequest:request
                completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (connectionError) {
                        NSLog(@"Error: %@", error);
                        return;
                    }
                    NSError *jsonError = nil;
                    id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&jsonError];
                    if (jsonError) {
                        NSLog(@"Error: %@", jsonError);
                        return;
                    }
                    NSLog(@"Result : %@", jsonData);
                    NSString *mediaId = jsonData[@"media_id_string"];
                    [self composeTweetREST:mediaId];
            }];
}


- (void)composeTweetREST:(NSString *)mediaId
{
    NSString *endpoint = @"https://api.twitter.com/1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status":@"OK",
                                 @"media_ids":mediaId};
    NSError *error = nil;
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSURLRequest *request = [client URLRequestWithMethod:@"POST"
                                                     URL:endpoint
                                              parameters:parameters
                                                   error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    [client sendTwitterRequest:request
                    completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        if (connectionError) {
                            NSLog(@"Error: %@", error);
                            return;
                        }
                        NSError *jsonError = nil;
                        id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
                        if (jsonError) {
                            NSLog(@"Error: %@", jsonError);
                            return;
                        }
                        NSLog(@"Result : %@", jsonData);
                    }];
}













- (void) sharePostToNetwork : (id) sharePost {
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:@"I tweeted from my App, LALALLALALA)"];
    [composer setImage:[UIImage imageNamed:@"TWimage.jpeg"]];
    
    // Called from a UIViewController
    [composer showFromViewController:[self vcForComposeTweet] completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

- (UIViewController*) vcForComposeTweet {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *vc=[window rootViewController];
    if(vc.presentedViewController)
        return vc.presentedViewController;
    else
        return vc;
}
- (void) initiationPropertiesWithoutSession {
    self.title = @"Login Twitter";
    self.icon = @"TWimage.jpeg";
    self.isLogin = NO;
    self.currentUser = nil;
}

- (void) loginOut {
    [[Twitter sharedInstance] logOut];
    [self initiationPropertiesWithoutSession];
}

@end
