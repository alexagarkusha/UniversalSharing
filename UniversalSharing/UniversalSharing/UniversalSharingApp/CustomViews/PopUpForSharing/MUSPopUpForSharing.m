//
//  MUSPopUpForSharing.m
//  UniversalSharing
//
//  Created by Roman on 9/28/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPopUpForSharing.h"
#import "MUSConstantsApp.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "MUSSocialManager.h"
#import "MUSPopUpTableViewCell.h"

@interface MUSPopUpForSharing ()<UITableViewDelegate, UITableViewDataSource, MUSPopUpTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//===
@property (strong, nonatomic) NSArray *networksArray;
@property (strong, nonatomic) NSMutableDictionary *stateSwitchButtonsDictionary;

@end

@implementation MUSPopUpForSharing

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setUpColorAndBorder];
    [self createSwitchButtonsArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createSwitchButtonsArray];
    [self.tableView reloadData];    
}

- (void) createSwitchButtonsArray {
    self.networksArray = [[MUSSocialManager sharedManager] allNetworks];
    __block NSInteger count = 0;
    if (_stateSwitchButtonsDictionary) {
        [_stateSwitchButtonsDictionary removeAllObjects];
    }else {
        _stateSwitchButtonsDictionary = [NSMutableDictionary new];
    }
    [self.networksArray enumerateObjectsUsingBlock:^(MUSSocialNetwork *socialNetwork, NSUInteger idx, BOOL *stop) {
        if (!socialNetwork.isLogin || [self currentReasonForSocialNetwork: socialNetwork] == MUSConnect) {
            [_stateSwitchButtonsDictionary setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%ld",(long)socialNetwork.networkType]];
            count++;
        }else {
            [_stateSwitchButtonsDictionary setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)socialNetwork.networkType]];
        }
    }];
    
    if (count == [self.networksArray count]) {
        _shareButton.enabled = NO;
        [_shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    } else {
        _shareButton.enabled = YES;
        [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];       
    }
}

- (void) setChangeSwitchButtonWithValue : (BOOL) value andKey :(NSString*) key {
    [_stateSwitchButtonsDictionary setValue:[NSNumber numberWithBool:value] forKey:key];
    NSArray *arrayWithValues =  [_stateSwitchButtonsDictionary allValues];
    if ([arrayWithValues containsObject:[NSNumber numberWithBool:YES]]) {
        _shareButton.enabled = YES;
        [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _shareButton.enabled = NO;
         [_shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.networksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSPopUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPopUpTableViewCell cellID]];
    if(!cell) {
        cell = [MUSPopUpTableViewCell popUpTableViewCell];
    }
    cell.delegate = self;
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSSocialNetwork *socialNetwork = self.networksArray[indexPath.row];
    MUSPopUpTableViewCell *popUpTableViewCell = (MUSPopUpTableViewCell*) cell;
    [popUpTableViewCell configurationPopUpTableViewCellWith: socialNetwork andReason: [self currentReasonForSocialNetwork: socialNetwork]];
}

- (void) setUpColorAndBorder {
    [self.contentView setFrame:CGRectMake(50, 50, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    self.contentView.layer.borderWidth = 2;
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.imageView setBackgroundColor: BROWN_COLOR_WITH_ALPHA_025];
}

- (IBAction) closeButtonTapped:(id)sender {
     [self.delegate sharePosts:nil andFlagTwitter:NO];
}

- (IBAction) shareButtonTapped:(id)sender {
   __block BOOL flagTwitter = NO;
    NSMutableArray *arrayWithNetworksForPost = [NSMutableArray new];
    [_stateSwitchButtonsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL* stop) {
        if ([value boolValue]) {
            NetworkType currentNetwork = [key integerValue];
            if (currentNetwork == MUSTwitters) {
                flagTwitter = YES;
            }
            [arrayWithNetworksForPost addObject:@(currentNetwork)];
        }
    }];
    [self.delegate sharePosts:arrayWithNetworksForPost andFlagTwitter:flagTwitter];
}

- (ReasonType) currentReasonForSocialNetwork : (MUSSocialNetwork*) socialNetwork {
    ReasonType currentReason = MUSAllReasons;
    for (MUSNetworkPost *currentNetworkPost in self.networksPostArray) {
        if (currentNetworkPost.networkType == socialNetwork.networkType) {
            currentReason = currentNetworkPost.reason;
        }
    }
    return currentReason;
}

@end
