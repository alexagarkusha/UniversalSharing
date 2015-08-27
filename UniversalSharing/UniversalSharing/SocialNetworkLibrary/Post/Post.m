//
//  Post.m
//  UniversalSharing
//
//  Created by U 2 on 29.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "Post.h"

@implementation Post

- (NSString*) convertArrayImagesUrlToString {
    NSString *url = @"";
    for (int i = 0; i < self.arrayImagesUrl.count; i++) {
        url = [url stringByAppendingString:self.arrayImagesUrl[i]];
        if(self.arrayImagesUrl.count - 1 != i)
            url = [url stringByAppendingString:@", "];
    }
    return url;    
}
@end
