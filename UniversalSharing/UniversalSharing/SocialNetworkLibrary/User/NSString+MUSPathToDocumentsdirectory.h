//
//  NSString+MUSPathToDocumentsdirectory.h
//  UniversalSharing
//
//  Created by Roman on 8/20/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MUSPathToDocumentsdirectory)

- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase;
- (NSString*) saveImageOfUserToDocumentsFolder :(NSString*) photoURL;

@end
