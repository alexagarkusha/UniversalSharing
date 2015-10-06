//
//  MUSPopUpForSharing.h
//  UniversalSharing
//
//  Created by Roman on 9/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MUSPopUpForSharingDelegate <NSObject>

- (void) sharePosts : (NSMutableArray*) arrayChosenNetworksForPost andFlagTwitter :(BOOL) flagTwitter;

@end


@interface MUSPopUpForSharing : UIViewController
@property (nonatomic, assign) id <MUSPopUpForSharingDelegate> delegate;

@property (nonatomic, strong) NSArray *arrayOfNetworksPost;

//@property (weak, nonatomic) IBOutlet UIView *popUpView;

@end
