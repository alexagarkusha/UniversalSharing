//
//  MUSPopUpForSharing.m
//  UniversalSharing
//
//  Created by Roman on 9/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPopUpForSharing.h"
#import "ConstantsApp.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "SocialManager.h"
#import "MUSPopUpTableViewCell.h"

@interface MUSPopUpForSharing ()<UITableViewDelegate, UITableViewDataSource, MUSPopUpTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (weak, nonatomic) IBOutlet UISwitch *switchVK;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFaebook;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwitter;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVK;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//===
@property (strong, nonatomic) NSArray *arrayWithNetworksObj;
@property (strong, nonatomic) NSMutableDictionary *stateSwitchButons;
@end

@implementation MUSPopUpForSharing

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   // self.switchFacebook.tintColor = [UIColor redColor];
    [self setColorAndRudius];
    [self createArraySwirtchButtons];
    //[self setSwitches];
//    NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
//    self.arrayWithNetworksObj = [[SocialManager sharedManager] networks : arrayWithNetworks];
    //////////////////////////////////////////////////////////////////////////////////////
   
}

- (void)viewWillAppear:(BOOL)animated {
    //[self setSwitches];
    //[self viewDidLoad];
    //[self.view setNeedsDisplay];
    [self createArraySwirtchButtons];
    
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    
}

- (void) createArraySwirtchButtons {
    NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
    self.arrayWithNetworksObj = [[SocialManager sharedManager] networks : arrayWithNetworks];
    __block NSInteger count = 0;
    if (_stateSwitchButons) {
        [_stateSwitchButons removeAllObjects];
    }else {
    _stateSwitchButons = [NSMutableDictionary new];
    }
    
    [self.arrayWithNetworksObj enumerateObjectsUsingBlock:^(SocialNetwork *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.isLogin) {
            [_stateSwitchButons setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%ld",(long)obj.networkType]];
            count++;
            
        }else {
            [_stateSwitchButons setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)obj.networkType]];
        }
    }];
    if (count == 3) {
        _buttonShare.enabled = NO;
        [_buttonShare setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    } else {
        _buttonShare.enabled = YES;
        [_buttonShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];       
    }
    
}

- (void) setChangeSwitchButtonWithValue : (BOOL) value andKey :(NSString*) key {
    //[_stateSwitchButons removeObjectForKey:key];
    [_stateSwitchButons setValue:[NSNumber numberWithBool:value] forKey:key];
    NSArray *arrayWithValues =  [_stateSwitchButons allValues];
    if ([arrayWithValues containsObject:[NSNumber numberWithBool:YES]]) {
        _buttonShare.enabled = YES;
        [_buttonShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _buttonShare.enabled = NO;
         [_buttonShare setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWithNetworksObj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSPopUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPopUpTableViewCell cellID]];
    SocialNetwork *socialNetwork = self.arrayWithNetworksObj[indexPath.row];
    
    if(!cell) {
        cell = [MUSPopUpTableViewCell popUpTableViewCell];
    }
    cell.delegate = self;
   
    [cell configurationProfileUserTableViewCellWith:socialNetwork];
    return cell;
}

- (void) setColorAndRudius {
//    CGRect newFrame = self.secondView.frame;
//    newFrame.size = CGSizeMake(23.0, 500.0);
//    self.secondView.frame = newFrame;
    [self.secondView setFrame:CGRectMake(50, 50, self.secondView.frame.size.width, self.secondView.frame.size.height)];
//    self.secondView.layer.masksToBounds = YES;
    //self.secondView.layer.cornerRadius = 25;
    self.secondView.layer.borderWidth = 2;
    self.secondView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.imageView setBackgroundColor:BROWN_COLOR_Light];
    
}

- (IBAction)ButtonCloseTapped:(id)sender {
     [self.delegate sharePosts:nil];
}

- (IBAction)buttonShareTapped:(id)sender {
    NSMutableArray *arrayWithNetworksForPost = [NSMutableArray new];// = @[@(Twitters), @(VKontakt), @(Facebook)];
    [_stateSwitchButons enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL* stop) {
        if ([value boolValue]) {
            NetworkType currentNetwork = [key integerValue];
            [arrayWithNetworksForPost addObject:@(currentNetwork)];
        }
        
    }];
    //[self.view removeFromSuperview];
    [self.delegate sharePosts:arrayWithNetworksForPost];
    
}
//- (IBAction)switchTapped:(UISwitch*)sender {
//    if (!sender.isOn) {
//        sender.backgroundColor = [UIColor whiteColor];
//        sender.layer.cornerRadius = 16.0;
//    }
//}


//- (void) setSwitches {
//    NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
//    self.arrayWithNetworksObj = [[SocialManager sharedManager] networks : arrayWithNetworks];
//    [self.arrayWithNetworksObj enumerateObjectsUsingBlock:^(SocialNetwork *obj, NSUInteger idx, BOOL *stop) {
//        switch (obj.networkType) {
//            case Facebook:
//                if (!obj.isLogin) {
//                    [self.switchFacebook setOn:NO animated:YES];
//                    self.switchFacebook.enabled = NO;
//                     //[self.switchFacebook setTintColor:[UIColor whiteColor]];
//                    self.switchFacebook.backgroundColor = [UIColor whiteColor];
//                    self.switchFacebook.layer.cornerRadius = 16.0;
//                }
//                
//                break;
//            case Twitters:
//                if (!obj.isLogin) {
//                    [self.switchTwitter setOn:NO animated:YES];
//                    self.switchTwitter.enabled = NO;
//                    self.switchTwitter.backgroundColor = [UIColor whiteColor];
//                    self.switchTwitter.layer.cornerRadius = 16.0;
//                }
//                
//                break;
//                
//            case VKontakt:
//                if (!obj.isLogin) {
//                    [self.switchVK setOn:NO animated:YES];
//                    self.switchVK.enabled = NO;
//                    self.switchVK.backgroundColor = [UIColor whiteColor];
//                    self.switchVK.layer.cornerRadius = 16.0;
//                    
//                }
//                
//                break;
//                
//                
//            default:
//                break;
//        }
//    }];
//    
//}
@end
