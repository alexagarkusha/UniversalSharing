//
//  MUSLocationViewController.m
//  UniversalSharing
//
//  Created by U 2 on 07.09.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSLocationViewController.h"
#import "Place.h"
#import "ConstantsApp.h"
#import "MUSLocationManager.h"
#import "MUSCustomMapView.h"

@interface MUSLocationViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
/*!
 @property
 @abstract initialization by Place objects via block from socialnetwork(facebook or twitter or VK)
 */
@property (strong, nonatomic) NSArray *arrayLocations;
/*!
 @property
 @abstract initialization by socialnetwork(facebook or twitter or VK) getting from ShareViewController
 */
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;
/*!
 @property
 @abstract user distance location - count of meteres, default = 1000 metres
 */
@property (strong, nonatomic) NSString *stringDistance;

/////////////////////////////////////////////////
@property (strong, nonatomic) Location *currentLocation;




@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) MUSCustomMapView *musCustomMapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintTableView;
#warning RENAME PROPERTY
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintTavbleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintCustomMapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintCustomMapView;
@property (weak, nonatomic) IBOutlet MUSCustomMapView *customMapView;

@property (assign, nonatomic) BOOL isOpenTableView;

@end

@implementation MUSLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiationNavigationBar];
    self.leftConstraintTableView.constant =  self.view.frame.size.width;
    self.rightConstraintTavbleView.constant = - self.view.frame.size.width;
    
    
    //self.customMapView.hidden = YES;
    
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    self.stringDistance = distanceEqual100;
    [self userCurrentLocation];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self closeTableViewWithPlaces];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) currentUser:(SocialNetwork*)socialNetwork {
    self.currentSocialNetwork = socialNetwork;
}

- (void) initiationNavigationBar {
    UIBarButtonItem *choosePlaceButton = [[UIBarButtonItem alloc] initWithTitle: @"Choose place" style:2 target:self action: @selector(showCloseTable)];
    self.navigationItem.rightBarButtonItem = choosePlaceButton;
}

- (void) showCloseTable {
    if (!self.isOpenTableView) {
        [self showTableViewWithPlaces];
        self.isOpenTableView = YES;
    } else {
        [self closeTableViewWithPlaces];
        self.isOpenTableView = NO;
    }
}

- (void) showTableViewWithPlaces {
    self.leftConstraintTableView.constant =  self.view.frame.size.width / 3;
    self.rightConstraintTavbleView.constant = - (self.view.frame.size.width / 3) * 2;
    NSLog(@"Table left = %f, right = %f", self.leftConstraintTableView.constant, self.rightConstraintTavbleView.constant);
    self.leftConstraintCustomMapView.constant = - (self.view.frame.size.width / 3);
    self.rightConstraintCustomMapView.constant = (self.view.frame.size.width / 3) * 2;
    NSLog(@"MAP left = %f, right = %f", self.leftConstraintTableView.constant, self.rightConstraintTavbleView.constant);

    [UIView animateWithDuration: 0.4  animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
}

- (void) closeTableViewWithPlaces {
    self.leftConstraintTableView.constant =  self.view.frame.size.width;
    self.rightConstraintTavbleView.constant = - self.view.frame.size.width;
    
    self.leftConstraintCustomMapView.constant = 0;
    self.rightConstraintCustomMapView.constant = 0;
    
    [UIView animateWithDuration: 0.4  animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
}




#pragma mark - userCurrentLocation

/*!
 @method
 @abstract set current user location, initialize arrayLocations by Place objects via block from socialnetwork(facebook or twitter or VK) according to chosen distance
 @param without
 */
- (void) userCurrentLocation {
    
    [[MUSLocationManager sharedManager] startTrackLocationWithComplition:^(id result, NSError *error) {
        if ([result isKindOfClass:[CLLocation class]]) {
            CLLocation* location = result;
            self.currentLocation = [[Location alloc] init];
            self.currentLocation.longitude = [NSString stringWithFormat: @"%f",location.coordinate.longitude];
            self.currentLocation.latitude = [NSString stringWithFormat: @"%f",location.coordinate.latitude];
            self.currentLocation.type = @"place";
            self.currentLocation.q = @"";
            self.currentLocation.distance = self.stringDistance;
            __weak MUSLocationViewController *weakSelf = self;
            
            [_currentSocialNetwork obtainArrayOfPlaces:self.currentLocation withComplition:^(NSMutableArray *places, NSError *error) {
                
                weakSelf.arrayLocations = places;
                [weakSelf.tableView reloadData];
                [weakSelf.customMapView initiationMapView: places withDistance: [weakSelf.stringDistance integerValue]];
            }];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"LocationCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"LocationCell"];
    }
    
    /*!
     get object Place and show name of that on tableviewcell
     */
    
    Place *place = self.arrayLocations[indexPath.row];
    cell.textLabel.text = place.fullName;
    
    /*
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
     if (cell) {
     Place *place = self.arrayLocations[indexPath.row];
     cell.textLabel.text = place.fullName;
     }
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     get chosen object Place and send to shareViewController via block, leave this controller
     */
    Place *place = self.arrayLocations[indexPath.row];
    self.placeComplition(place, nil);
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - actionSheet

/*!
 @method
 @abstract when button distance is tapped calling actionSheet with offering distance for choice(100,1000,25000)
 @param sender
 */
- (IBAction)chooseDistance:(id)sender {
    //[self alertChooseDistanceShow];
    
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
            break;
        case 1:
            self.stringDistance = distanceEqual1000;
            break;
        case 2:
            self.stringDistance = distanceEqual25000;
            break;
        default:
            return;
    }
    /*!
     call this method if we have changed the distance
     */
    [self userCurrentLocation];
}











@end
