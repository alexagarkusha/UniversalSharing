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

- (void) sharePost:(Post *)post withComplition:(Complition)block {
    self.copyPostComplition = block;
    if (!post.imageToPost.image) {
        [self postMessageToTwitter:post];
        //[self postLocation: post];
    } else {
        [self postImageToTwitter:post];
    }
}


- (void) postLocation : (Post*) post {
    //NSString *latitude = [NSString stringWithFormat:@"%f", post.latitude];
    //NSString *longitude = [NSString stringWithFormat:@"%f", post.longitude];
    
    
    NSString *latitude = @"52.52944";
    NSString *longitude = @"13.40332";

    
   // NSString *latitude = @"48.450063";
   // NSString *longitude = @"34.982602";
   // NSString *accuracy = @"40000";
    
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    //NSString *url = @"https://api.twitter.com/1.1/geo/similar_places.json";
    
    NSString *url = @"https://api.twitter.com/1.1/geo/reverse_geocode.json";
    NSMutableDictionary *message = [[NSMutableDictionary alloc] initWithObjectsAndKeys: latitude, @"lat", longitude, @"long", /* accuracy, @"accuracy", */nil];
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod:@"GET" URL:url parameters:message error:&error];
    
    __weak TWTRAPIClient *currentClient = client;
    
    [client sendTwitterRequest:preparedRequest completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
        
        if(!error){
            NSError *jsonError;
            
            NSDictionary *locationJSON = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            NSDictionary *resultSearcLocation = [locationJSON objectForKey: @"result"];
                NSArray *placesArray = [resultSearcLocation objectForKey: @"places"];
                    NSDictionary *firstPlace = [placesArray firstObject];
                        NSString *place_id = [firstPlace objectForKey:@"id"];
                        NSString *name = [firstPlace objectForKey:@"name"];
            
            
            
            
            [self postMessageToTwitter:post withPlaceID:place_id];
            
            
            NSLog(@"PLACE ID = %@", place_id);
            NSLog(@"name = %@", name);

            NSLog(@"Location = %@", locationJSON);
        }else{
            NSLog(@"Error: %@", error);
        }
        
    }];
}

/////////////////// УЗНАТЬ КАК ПРАВИЛЬНО /////////////////////////


- (void) postMessageToTwitter : (Post*) post withPlaceID : (NSString*) placeID {
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    NSString *url = @"https://api.twitter.com/1.1/statuses/update.json";
    NSMutableDictionary *message = [[NSMutableDictionary alloc] initWithObjectsAndKeys: post.postDescription , @"status", placeID, @"place_id", nil];
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod:@"POST" URL:url parameters:message error:&error];
    
    [client sendTwitterRequest:preparedRequest completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
        
        if(!error){
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            NSLog(@"%@", json);
        }else{
            NSLog(@"Error: %@", error);
        }
        
    }];
}

















- (void) postMessageToTwitter : (Post*) post {
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSError *error;
    
    NSString *url = @"https://api.twitter.com/1.1/statuses/update.json";
    NSMutableDictionary *message = [[NSMutableDictionary alloc] initWithObjectsAndKeys: post.postDescription , @"status", nil];
    
    NSURLRequest *preparedRequest = [client URLRequestWithMethod:@"POST" URL:url parameters:message error:&error];
    
    [client sendTwitterRequest:preparedRequest completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error){
        
        if(!error){
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            NSLog(@"%@", json);
        }else{
            NSLog(@"Error: %@", error);
        }
        
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
            NSString *mediaId = jsonData[@"media_id_string"];
            [self composeTweetREST: mediaId andPost: post];
    }];
}


- (void)composeTweetREST: (NSString *) mediaId andPost : (Post*) post
{
    NSString *endpoint = @"https://api.twitter.com/1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": post.postDescription,
                                 @"media_ids": mediaId};
    NSError *error = nil;
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    NSURLRequest *request = [client URLRequestWithMethod: @"POST"
                                                     URL: endpoint
                                              parameters: parameters
                                                   error: &error];
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





/*
>>>>>>> decc3400bc7a1d9fdd139a754c11b4cbb8ced4c5
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
*/
 
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
