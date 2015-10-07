//
//  MEExpandableHeaderView.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEExpandableHeaderView.h"
//#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "ConstantsApp.h"

@interface MEExpandableHeaderView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, assign) CGPoint previousContentOffset;
@property(nonatomic, assign) CGFloat originalHeight;
@property(nonatomic, strong, readwrite) UIScrollView *pagesScrollView;
@property(nonatomic, strong, readwrite) UIPageControl *pageControl;

@end

@implementation MEExpandableHeaderView

#pragma mark - NSObject Lifecycle

- (id)initWithSize:(CGSize)size
   backgroundImage:(UIImage*)image
      contentPages:(NSArray*)pages
{
    assert(pages == nil || [pages isKindOfClass:[NSArray class]]);
    
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self)
    {
        _originalHeight = size.height;
        _originalImage = image;
        _previousContentOffset = CGPointZero;
        
        [self setupPages:pages];
        [self setupPageControl:[pages count]];
    }
    return self;
}

#pragma mark - Setup

- (void)setupPages:(NSArray*)pages
{
    assert(!self.pagesScrollView);
    
    UIScrollView *pagesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  
    [pagesScrollView setDelegate:self];
    [pagesScrollView setPagingEnabled:YES];
    [pagesScrollView setShowsHorizontalScrollIndicator:NO];
    [pagesScrollView setShowsVerticalScrollIndicator:NO];
    
    CGFloat posX = 0.0;
    
    for (UIView *page in pages)
    {
        assert([page isKindOfClass:[UIView class]]);
        
        page.center = CGPointMake(posX + self.bounds.size.width/2.0,
                                  self.bounds.size.height/2.0);
        
        [pagesScrollView addSubview:page];
        
        posX += self.bounds.size.width;
    }
    
    [pagesScrollView setContentSize:CGSizeMake(posX, self.bounds.size.height)];
    
    [self addSubview:pagesScrollView];
    self.pagesScrollView = pagesScrollView;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleTap:)];
    singleTap.cancelsTouchesInView = NO;
    [self.pagesScrollView addGestureRecognizer:singleTap];

}

- (void)setupPageControl:(NSUInteger)pagesCount
{
    assert(!self.pageControl);
    
    if (pagesCount > 1)
    {
        static CGFloat const kPageControlPadding = 7.0;
        static CGRect const kPageControlDefaultFrame = {0, 0, 20, 20};
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:kPageControlDefaultFrame];
        
        [pageControl addTarget:self
                        action:@selector(pageControlChanged)
              forControlEvents:UIControlEventValueChanged];
        
        [pageControl setNumberOfPages:pagesCount];
        [pageControl setCurrentPage:0];
   
        UIColor *backgroundColor = BROWN_COLOR_LightMID;
        [pageControl setBackgroundColor:backgroundColor];
        
        CGSize pageControlSize = [pageControl sizeForNumberOfPages:pagesCount];
                
        pageControl.frame = CGRectMake(
                                       
        self.bounds.size.width,
                                       
        self.bounds.size.height-(pageControl.frame.size.height+kPageControlPadding),
                                       
        pageControlSize.width + kPageControlPadding * 2,
                                       
        pageControl.frame.size.height);
        

        pageControl.layer.cornerRadius = pageControl.frame.size.height/2.0;
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        self.pageControl.frame = CGRectMake(self.bounds.size.width - self.pageControl.frame.size.width - 8, self.bounds.size.height-(pageControl.frame.size.height+kPageControlPadding), self.pageControl.frame.size.width ,self.pageControl.frame.size.height);
        
        
    }
}

#pragma mark - Actions

- (void)pageControlChanged
{
    assert([self.pagesScrollView isKindOfClass:[UIScrollView class]]);
    
    CGPoint newOffset = CGPointMake(self.bounds.size.width * self.pageControl.currentPage, 0);
	[self.pagesScrollView setContentOffset:newOffset
                                  animated:YES];
	
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidEndScrolling:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrolling:scrollView];
}

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView
{
    if (scrollView == self.pagesScrollView)
    {
        assert([self.pageControl isKindOfClass:[UIPageControl class]]);

        NSUInteger currentPage = scrollView.contentOffset.x / self.bounds.size.width;
        [self.pageControl setCurrentPage:currentPage];
    }
}

#pragma mark - Public

- (void)offsetDidUpdate:(CGPoint)newOffset
{
    if (newOffset.y <= 0)
    {
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, newOffset.y/2.0);
        
        CGFloat scaleFactor = (self.originalHeight - newOffset.y) / self.originalHeight;
        
        CGAffineTransform translateAndZoom = CGAffineTransformScale(translate, scaleFactor, scaleFactor);
        
        self.pagesScrollView.transform = translateAndZoom;
    }
    
    self.previousContentOffset = newOffset;
}

#pragma mark - Tap Gesture Recognizer 

- (void)handleTap:(UIGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate currentPageIndex: self.pageControl.currentPage];
}

@end
