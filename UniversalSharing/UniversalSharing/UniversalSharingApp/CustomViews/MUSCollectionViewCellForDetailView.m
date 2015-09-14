//
//  MUSCollectionViewCellForDetailView.m
//  UniversalSharing
//
//  Created by Roman on 9/14/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCollectionViewCellForDetailView.h"
@interface MUSCollectionViewCellForDetailView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MUSCollectionViewCellForDetailView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)prepareForReuse {
    self.scrollView.zoomScale = 0;
}

- (void)setImageContext:(UIImage *)imageContext
{
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = YES;

    
   self.imageView.image = imageContext;
//    self.imageView.frame = CGRectMake (self.center.y, self.center.x, self.frame.size.width, self.frame.size.height);
    //self.scrollView.frame = CGRectMake (self.center.y, self.center.x, self.frame.size.width, self.frame.size.height);
    
    NSLog(@"selfCenter = %f  selfFrame = %f",self.bounds.size.height/2,self.frame);
    //self.imageView.frame.size = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
//    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    self.scrollView.center = self.imageView.center;
    
    //[self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    NSLog(@"width = %f  height = %f",self.imageView.frame.size.width,self.imageView.frame.size.height);
   
}
@end
