//
//  MUSPopUpForSharing.m
//  UniversalSharing
//
//  Created by Roman on 9/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPopUpForSharing.h"

@interface MUSPopUpForSharing ()
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (weak, nonatomic) IBOutlet UISwitch *switchVK;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFaebook;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwitter;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVK;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@end

@implementation MUSPopUpForSharing

- (void)viewDidLoad {
    [super viewDidLoad];
        self.secondView.layer.masksToBounds = YES;
       self.secondView.layer.cornerRadius = 25;
        self.secondView.layer.borderWidth = 2;
        self.secondView.layer.borderColor = [UIColor blackColor].CGColor;
        //popVC.view.backgroundColor = [UIColor greenColor];
}
- (IBAction)ButtonCloseTapped:(id)sender {
    [self removeFromParentViewController];
}

- (IBAction)buttonShareTapped:(id)sender {
    
}
- (IBAction)switchTapped:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
