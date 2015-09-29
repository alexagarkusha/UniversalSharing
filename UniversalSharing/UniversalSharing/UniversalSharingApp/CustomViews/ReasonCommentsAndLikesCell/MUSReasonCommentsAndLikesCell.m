//
//  MUSReasonCommentsAndLikesCell.m
//  UniversalSharing
//
//  Created by U 2 on 26.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSReasonCommentsAndLikesCell.h"
#import "ConstantsApp.h"
#import "UIImage+IconOfSocialNetwork.h"
#import "NSString+ReasonTypeInString.h"
#import "UIImage+LikeIconOfSocialNetwork.h"
#import <QuartzCore/QuartzCore.h>


#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


@interface MUSReasonCommentsAndLikesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconOfSocialNetworkImageView;

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonOfPostLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundViewOfCell;

@end


@implementation MUSReasonCommentsAndLikesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundViewOfCell.backgroundColor = BROWN_COLOR_Light;
    // Configure the view for the selected state
    
    //[self leftBorder];
    //[self rightBorder];
    //[self bottomBorder];
}

- (NSString *)reuseIdentifier{
    return [MUSReasonCommentsAndLikesCell cellID];
}

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}
+ (instancetype) reasonCommentsAndLikesCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}
+ (CGFloat) heightForReasonCommentsAndLikesCell {
    return musAppCommentsAndLikesCell_HeightOfRow;
}

- (void) configurationReasonCommentsAndLikesCell: (NetworkPost*) networkPost {
    [self configurateCommentsImageAndLabel: networkPost];
    [self configurateLikesImageAndLabel: networkPost];
    [self configurateReasonOfPostLabel: networkPost];
    [self configurateIconOfSocialNetworkImageViewForPost: networkPost];
}

- (void) configurateCommentsImageAndLabel : (NetworkPost*) networkPost {
    self.commentImageView.image = [UIImage imageNamed: musAppImage_Name_CommentsImage];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat: @"%ld", (long) networkPost.commentsCount];
}

- (void) configurateLikesImageAndLabel : (NetworkPost*) networkPost {
    self.likeImageView.image = [UIImage likeIconOfSocialNetwork: networkPost.networkType];
    self.numberOfLikesLabel.text = [NSString stringWithFormat: @"%ld", (long)networkPost.likesCount];
}

- (void) configurateReasonOfPostLabel : (NetworkPost*) networkPost {
    self.reasonOfPostLabel.text = [NSString reasonTypeInString: networkPost.reason];
}

- (void) configurateIconOfSocialNetworkImageViewForPost: (NetworkPost*) networkPost {
    self.iconOfSocialNetworkImageView.image = [UIImage iconOfSocialNetworkForNetworkPost: networkPost];
}

- (void) leftBorder {
    CALayer *leftBorder = [CALayer layer];
    leftBorder.backgroundColor = [BROWN_COLOR_MIDLight CGColor];
    leftBorder.frame = CGRectMake(0, 0, 3.0f, CGRectGetHeight (self.backgroundViewOfCell.frame) + 1);
    [self.backgroundViewOfCell.layer addSublayer: leftBorder];
}

//- (void) rightBorder {
//    CALayer *leftBorder = [CALayer layer];
//    leftBorder.backgroundColor = [BROWN_COLOR_MIDLight CGColor];
//    leftBorder.frame = CGRectMake(CGRectGetWidth (self.backgroundViewOfCell.frame) - 3.0f, 0, 3.0f, CGRectGetHeight (self.backgroundViewOfCell.frame) + 1);
//    [self.backgroundViewOfCell.layer addSublayer: leftBorder];
//}
//
//- (void) bottomBorder {
//    CGRect backgroundRect = CGRectMake(self.backgroundViewOfCell.frame.origin.x, self.backgroundViewOfCell.frame.origin.y, self.backgroundViewOfCell.frame.size.width, self.backgroundViewOfCell.frame.size.height);
//    
//    
////    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
////    [bezier2Path moveToPoint: CGPointMake(0.5, 24.5)];
////    [bezier2Path addCurveToPoint: CGPointMake(5.5, 29.5) controlPoint1: CGPointMake(2.17, 29.5) controlPoint2: CGPointMake(5.5, 29.5)];
////    bezier2Path.lineCapStyle = kCGLineCapSquare;
////    
////    bezier2Path.lineJoinStyle = kCGLineJoinRound;
////    
////    [UIColor.blackColor setStroke];
////    bezier2Path.lineWidth = 2;
////    [bezier2Path stroke];
////  
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    //UIGraphicsBeginImageContext(backgroundRect.size); // задали размеры контекста для рисования
//    CGContextSetLineWidth(context, 3);
//    
//    CGContextMoveToPoint(context, 0, 0);
//    
//    CGContextAddLineToPoint(context, 0, backgroundRect.size.height - 5);
//    
//    CGContextAddArc(context, 5, backgroundRect.size.height - 5, 5, DEGREES_TO_RADIANS(180), DEGREES_TO_RADIANS(90), NO);
//    
//    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor] );
//
//    CGContextStrokePath(context);
//
//    
//   // UIGraphicsEndImageContext();
//
////
////    
////        UIBezierPath *path = [UIBezierPath bezierPath];
////            [path moveToPoint: CGPointMake(0, 0)];
////            [path addLineToPoint: CGPointMake(0, backgroundRect.size.height - 5)];
////            [path addArcWithCenter: CGPointMake(5, backgroundRect.size.height - 5)
////                        radius: 5
////                    startAngle: DEGREES_TO_RADIANS(180)
////                      endAngle: DEGREES_TO_RADIANS(90)
////                     clockwise: NO];
////            [path addLineToPoint: CGPointMake(backgroundRect.size.width, backgroundRect.size.height)];
////
////       // [UIColor.blackColor setStroke];
////        [path closePath];
////
////    
////
////        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
////        maskLayer.frame = backgroundRect;
////        maskLayer.path  = path.CGPath;
////        self.backgroundViewOfCell.layer.mask = maskLayer;
////
////        CAShapeLayer *shape = [CAShapeLayer layer];
////        shape.frame = backgroundRect;
////        shape.path = path.CGPath;
////        shape.lineWidth = 2.0f;
////        shape.strokeColor = [UIColor redColor].CGColor;
////        shape.fillColor = [UIColor clearColor].CGColor;
////        [self.backgroundViewOfCell.layer addSublayer:shape];
//
//    
//   
//    
//    
////
////    UIBezierPath *path = [UIBezierPath bezierPath];
////        [path moveToPoint: CGPointMake(0, backgroundRect.size.height - 5)];
////        [path addArcWithCenter: CGPointMake(5, backgroundRect.size.height - 5)
////                    radius: 5
////                startAngle: DEGREES_TO_RADIANS(180)
////                  endAngle: DEGREES_TO_RADIANS(90)
////                 clockwise: NO];
////   // [UIColor.blackColor setStroke];
////    path.lineWidth = 2;
////    [path stroke];
//
//    //[path closePath];
//
//    
////    [path addLineToPoint: CGPointMake(0, 0)];
////        [path addLineToPoint: CGPointMake(rect.size.width, 0)];
////        [path addLineToPoint: CGPointMake(rect.size.width, rect.size.height - 23)];
////        [path addArcWithCenter: CGPointMake(rect.size.width - 60, 20)
////                        radius: 90
////                    startAngle: DEGREES_TO_RADIANS(40)
////                      endAngle: DEGREES_TO_RADIANS(90)
////                     clockwise: YES];
////        [path addLineToPoint: CGPointMake(60, rect.size.height)];
////        [path addArcWithCenter: CGPointMake(60, 20)
////                        radius: 89
////                    startAngle: DEGREES_TO_RADIANS(90)
////                      endAngle: DEGREES_TO_RADIANS(140)
////                     clockwise: YES];
////        [path closePath];
//
//}
//



@end
