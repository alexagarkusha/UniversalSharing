//
//  MUSPhotoManager.h
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantsApp.h"
#import <UIKit/UIKit.h>

@interface MUSPhotoManager : NSObject

+ (MUSPhotoManager*) sharedManager;
//===
- (void) photoShowFromViewController : (UIViewController*) viewController withComplition: (Complition) block;

@end
