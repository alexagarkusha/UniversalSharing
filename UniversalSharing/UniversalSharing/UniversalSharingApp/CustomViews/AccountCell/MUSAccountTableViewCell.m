//
//  LoginTableViewCell.m
//  UniversalSharing
//
//  Created by U 2 on 20.07.15.
//  Copyright (c) 2015 LML. All rights reserved.
//

#import "MUSAccountTableViewCell.h"
#import "UIImageView+RoundImage.h"
#import "UIImageView+LoadImageFromNetwork.h"
#import "DataBaseManager.h"
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MUSAccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *networkIconImageView;
@property (weak, nonatomic) IBOutlet UIView *viewAccountTableCell;
@end


@implementation MUSAccountTableViewCell


+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) accountTableViewCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

- (void)awakeFromNib {
    //self.multipleTouchEnabled = YES;

    [self.networkIconImageView roundImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)reuseIdentifier{
    return [MUSAccountTableViewCell cellID];
}
- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
}
- (void) configurateCellForNetwork:(SocialNetwork *)socialNetwork {
    
    if (socialNetwork.isLogin && socialNetwork.isVisible) {
        
       // __weak MUSAccountTableViewCell *weakSelf = self;
        
        //[socialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
        NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder:socialNetwork.icon]];
        self.networkIconImageView.image = [UIImage imageWithData:data];
            //[weakSelf.networkIconImageView loadImageFromUrl:[NSURL URLWithString:socialNetwork.icon]];
            self.loginLabel.text = socialNetwork.title;
            self.loginLabel.textColor = [UIColor blackColor];
       // }];
    } else if(socialNetwork.isLogin && !socialNetwork.isVisible){
        
        NSData *data = [NSData dataWithContentsOfFile:[self obtainPathToDocumentsFolder:socialNetwork.icon]];
        self.networkIconImageView.image = [UIImage imageWithData:data];
        self.networkIconImageView.image = [self translucentImageFromImage:self.networkIconImageView.image withAlpha:0.3f];
        self.loginLabel.text = socialNetwork.title;
        self.loginLabel.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3f];
        
//        __weak MUSAccountTableViewCell *weakSelf = self;
//        [socialNetwork obtainInfoFromNetworkWithComplition:^(id result, NSError *error) {
//            
//            [weakSelf.networkIconImageView  loadImageFromUrl:[NSURL URLWithString:socialNetwork.icon]];
//            weakSelf.networkIconImageView.image = [self translucentImageFromImage:self.networkIconImageView.image withAlpha:0.3f];
//            weakSelf.loginLabel.text = socialNetwork.title;
//            weakSelf.loginLabel.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3f];
//        }];
    }
    else {
        self.networkIconImageView.image = [UIImage imageNamed:socialNetwork.icon];
        self.loginLabel.text = socialNetwork.title;
        self.loginLabel.textColor = [UIColor blackColor];
    }
}

- (void) changeColorOfCell :(SocialNetwork *)socialNetwork {
    if (!socialNetwork.isVisible) {
        socialNetwork.isVisible = YES;
        socialNetwork.currentUser.isVisible = YES;
    } else {
        socialNetwork.isVisible = NO;
        socialNetwork.currentUser.isVisible = NO;
    }
    [[DataBaseManager sharedManager] updateUserIsVisible:socialNetwork.currentUser];
}

- (UIImage *)translucentImageFromImage:(UIImage *)image withAlpha:(CGFloat)alpha {
    CGRect rect = CGRectZero;
    rect.size = image.size;
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:rect blendMode:kCGBlendModeScreen alpha:alpha];
    UIImage * translucentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return translucentImage;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    for (UITouch* touch in touches) {
//        if (touch.tapCount == 2)
//        {
//           // self.multipleTouchEnabled = NO;
////                        CGPoint where = [touch locationInView:self];
////                        NSIndexPath* ip = [self indexPathForRowAtPoint:where];
////                        NSLog(@"double clicked index path: %@", ip);
//            
//            // do something useful with index path 'ip'
//        }
//    }
//    
//    [super touchesEnded:touches withEvent:event];
//}
@end

