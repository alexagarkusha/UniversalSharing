//
//  MUSLocationTableViewController.m
//  UniversalSharing
//
//  Created by Roman on 8/3/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSLocationTableViewController.h"
#import "Place.h"
#import "ConstantsApp.h"

@interface MUSLocationTableViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *arrayLocations;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
@property (strong, nonatomic) NSString *stringDistance;

@end

@implementation MUSLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.stringDistance = distanceEqual1000;
    [self userCurrentLocation];
}

- (void) setCurrentUser:(SocialNetwork*)socialNetwork {
    self.currentSocialNetwork = socialNetwork;
}

- (void) userCurrentLocation {
    
    //    [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(id result, NSError *error) {
    //        if ([result isKindOfClass:[CLLocation class]]) {
    //            CLLocation* location = result;
    //            self.currentLocation = location.coordinate;
    //=======
    
    Location *currentLocation = [[Location alloc] init];
    currentLocation.longitude = @"-122.40828";
    currentLocation.latitude = @"37.768641";
    currentLocation.type = @"place";
    currentLocation.q = @"";
    currentLocation.distance = self.stringDistance;
    __weak MUSLocationTableViewController *weakSelf = self;
    
    [_currentSocialNetwork obtainArrayOfPlaces:currentLocation withComplition:^(NSMutableArray *places, NSError *error) {
        weakSelf.arrayLocations = places;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    if (cell) {
        Place *place = self.arrayLocations[indexPath.row];
        cell.textLabel.text = place.fullName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.placeComplition){
        Place *place = self.arrayLocations[indexPath.row];
        self.placeComplition(place, nil);
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.translucent = YES;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.translucent = YES;
        return;
    }
}

- (IBAction)chooseDistance:(id)sender {
    [self alertChooseDistanceShow];
}

- (void) alertChooseDistanceShow {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose distance location :" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                  distanceEqual100,
                                  distanceEqual1000,
                                  distanceEqual25000,
                                  nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.stringDistance = distanceEqual100;
            [self userCurrentLocation];
            break;
        case 1:
            self.stringDistance = distanceEqual1000;
            [self userCurrentLocation];
            break;
        case 2:
            self.stringDistance = distanceEqual25000;
            [self userCurrentLocation];
            break;
            
        default:
            break;
    }
}
@end
