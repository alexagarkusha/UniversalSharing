//
//  UIButton+MUSSocialNetwork.m
//  UniversalSharing
//
//  Created by Roman on 8/6/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "UIButton+MUSSocialNetwork.h"
#import "SocialManager.h"
#import "ConstantsApp.h"
#import "UIButton+LoadBackgroundImageFromNetwork.h"
#import "UIButton+CornerRadiusButton.h"

@implementation UIButton (MUSSocialNetwork)

- (id) init {
    self = [super init];
    if (self) {
        //self.buttonType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.frame = CGRectMake(13.0, 13.0, 75.0, 75.0);//while so
        self.backgroundColor = [UIColor lightGrayColor];
        [NSTimer scheduledTimerWithTimeInterval : 9.0f
                                         target : self
                                       selector : @selector(buttonAnimationStart)
                                       userInfo : nil
                                        repeats : YES];
        
        [self cornerRadius:10];
        [self initiationSocialNetworkButtonForSocialNetwork:nil];
    }
    return self;
}

- (void) initiationSocialNetworkButtonForSocialNetwork :(SocialNetwork*) socialNetwork {
    
    SocialNetwork *currentSocialNetwork = socialNetwork;
    if (!currentSocialNetwork) {
        currentSocialNetwork = [SocialManager currentSocialNetwork];
    }
    
    if (!currentSocialNetwork) {
        [self setImage: [UIImage imageNamed: musAppButton_ImageName_UnknownUser] forState:UIControlStateNormal];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        return;
    } else {
//        __weak UIButton *socialNetworkButton = self;
//        [currentSocialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
//            SocialNetwork *currentSocialNetwork = (SocialNetwork*) result;
//            User *currentUser = currentSocialNetwork.currentUser;
//            [socialNetworkButton loadBackroundImageFromNetworkWithURL:[NSURL URLWithString: currentUser.photoURL]];
//        }];
        NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder:currentSocialNetwork.icon]];
        UIImage *image = [UIImage imageWithData:data];
        [self setImage:image forState:UIControlStateNormal];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
}

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}


- (void) buttonAnimationStart {
   [NSTimer scheduledTimerWithTimeInterval : 1.0f
                                    target : self
                                  selector : @selector(changeScaleButton)
                                  userInfo : nil
                                   repeats : NO];
   [NSTimer scheduledTimerWithTimeInterval : 1.5f
                                    target : self
                                  selector : @selector(undoChangeScaleButton)
                                  userInfo : nil
                                   repeats : NO];
}

- (void) changeScaleButton {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.4f];
    self.transform = CGAffineTransformMakeScale(1.12,1.12);
    [UIView commitAnimations];
}


- (void) undoChangeScaleButton {
    [UIView beginAnimations:@"UndoScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.4f];
    self.transform = CGAffineTransformMakeScale(1,1);
    [UIView commitAnimations];

}
@end
