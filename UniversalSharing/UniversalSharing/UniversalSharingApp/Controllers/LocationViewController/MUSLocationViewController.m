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
#import "ReachabilityManager.h"
#import "MUSLocationCell.h"

@interface MUSLocationViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MUSCustomMapViewDelegate, MUSLocationCellDelegate>
/*!
 @property
 @abstract initialization by Place objects via block from socialnetwork(facebook or twitter or VK)
 */
@property (strong, nonatomic) NSMutableArray *arrayLocations;
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintTableView;
#warning RENAME PROPERTY
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintTavbleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintCustomMapView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintCustomMapView;

@property (weak, nonatomic) IBOutlet MUSCustomMapView *customMapView;

@property (assign, nonatomic) BOOL isOpenTableView;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) NSIndexPath* chosenPlaceIndexPath;

@property (assign, nonatomic) BOOL isChosenPlace;

@property (assign, nonatomic) CGFloat tableViewWidth;

@end

@implementation MUSLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiationNavigationBar];
    [self initiationPanGestureRecognizer];
    self.tableViewWidth = (self.view.frame.size.width / 3) * 2;
    
    if ((!self.place.longitude.length > 0 && !self.place.latitude.length > 0) || ([self.place.longitude isEqualToString: @"(null)"] && [self.place.longitude isEqualToString: @"(null)"])) {
        self.place = nil;
    }

    self.leftConstraintTableView.constant =  self.view.frame.size.width;
    self.rightConstraintTavbleView.constant = - self.tableViewWidth;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector(tapOnMapView:)];
    self.arrayLocations = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    self.stringDistance = distanceEqual25000;
    if (![self obtainCurrentConnection]) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: musAppError_With_Domain_Universal_Sharing message:musAppError_Internet_Connection_Location delegate:self cancelButtonTitle: musAppButtonTitle_Cancel otherButtonTitles: nil];
        [errorAlert show];
    } else {
        [self userCurrentLocation];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self closeTableViewWithPlaces];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) obtainCurrentConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    if (!isReachableViaWiFi && !isReachable){
        return NO;
    }
    return YES;
}

- (void) currentUser:(SocialNetwork*)socialNetwork {
    self.currentSocialNetwork = socialNetwork;
}

- (void) initiationNavigationBar {
    UIBarButtonItem *choosePlaceButton = [[UIBarButtonItem alloc] initWithTitle: @"Choose place" style: 1 target:self action: @selector(showCloseTable)];
    self.navigationItem.rightBarButtonItem = choosePlaceButton;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: musAppButtonTitle_Back style: 1 target:self action: @selector(bactToShareViewController)];
    self.navigationItem.rightBarButtonItem = choosePlaceButton;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void) initiationPanGestureRecognizer {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTableView:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    [self.view bringSubviewToFront: self.navigationController.navigationBar];
}

- (void) showCloseTable {
    if (!self.isOpenTableView) {
        [self showTableViewWithPlaces];
    } else {
        [self closeTableViewWithPlaces];
    }
}

- (void) bactToShareViewController {
    if (!self.place) {
        self.placeComplition(nil, nil);
    }
        [self.navigationController popViewControllerAnimated : YES];
        self.navigationController.navigationBar.translucent = YES;
}


- (void) showTableViewWithPlaces {
    self.leftConstraintTableView.constant =  self.view.frame.size.width / 3;
    self.rightConstraintTavbleView.constant = 0;
    self.leftConstraintCustomMapView.constant = - self.tableViewWidth;
    self.rightConstraintCustomMapView.constant = self.tableViewWidth;
    
    [self.customMapView addGestureRecognizer : self.tapGestureRecognizer];
    
    [UIView animateWithDuration: 0.4  animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
    self.customMapView.mapView.scrollEnabled = NO;
    self.isOpenTableView = YES;
}

- (void) closeTableViewWithPlaces {
    self.leftConstraintTableView.constant =  self.view.frame.size.width;
    self.rightConstraintTavbleView.constant = - self.tableViewWidth;
    
    self.leftConstraintCustomMapView.constant = 0;
    self.rightConstraintCustomMapView.constant = 0;
    [self.customMapView removeGestureRecognizer: self.tapGestureRecognizer];
    
    [UIView animateWithDuration: 0.4  animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    }];
    [UIView commitAnimations];
    self.customMapView.mapView.scrollEnabled = YES;
    self.isOpenTableView = NO;
}

- (void) tapOnMapView: (UITapGestureRecognizer *)recognizer {
    [self closeTableViewWithPlaces];
}

-(void) moveTableView:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {

        float movingByX = self.leftConstraintTableView.constant + translation.x;
        
        //NSLog(@"MOVING  = %f", movingByX);
        if ( movingByX > [UIScreen mainScreen].bounds.size.width / 3){
            self.leftConstraintTableView.constant = movingByX;
            self.rightConstraintTavbleView.constant = [UIScreen mainScreen].bounds.size.width / 3 - movingByX;
            self.rightConstraintCustomMapView.constant = [UIScreen mainScreen].bounds.size.width  - movingByX;
            self.leftConstraintCustomMapView.constant = - [UIScreen mainScreen].bounds.size.width  + movingByX;
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        if (self.rightConstraintCustomMapView.constant > [UIScreen mainScreen].bounds.size.width / 3){
            [self showTableViewWithPlaces];
        }else if ( self.rightConstraintCustomMapView.constant <= [UIScreen mainScreen].bounds.size.width / 3){
            [self closeTableViewWithPlaces];
        }
    }
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
                if (!error) {
                    if (weakSelf.place) {
                        weakSelf.place.isChosen = YES;
                        [weakSelf.arrayLocations addObject: weakSelf.place];
                        [weakSelf.arrayLocations addObjectsFromArray: places];
                        NSArray *uniqueArrayWithPlaces = [self uniqueArrayWithPlaces:self.arrayLocations];
                        [weakSelf.arrayLocations removeAllObjects];
                        [weakSelf.arrayLocations addObjectsFromArray: uniqueArrayWithPlaces];
                    } else {
                        [weakSelf.arrayLocations addObjectsFromArray: places];
                    }
                    [weakSelf.customMapView initiationMapViewWithPlaces: weakSelf.arrayLocations];
                    [weakSelf.tableView reloadData];
                    weakSelf.customMapView.delegate = weakSelf.self;
                } else {
                    [self showErrorAlertWithError: error];
                }
            }];
        }
    }];
}

- (NSArray*) uniqueArrayWithPlaces : (NSMutableArray*) arrayLocations {
    NSMutableArray *uniqueArray = [NSMutableArray array];
    NSMutableSet *names = [NSMutableSet set];
    for (id obj in arrayLocations) {
        NSString *destinationName = [obj valueForKey: @"fullName"];
        if (![names containsObject:destinationName]) {
            [uniqueArray addObject:obj];
            [names addObject:destinationName];
        }
    }
    return uniqueArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayLocations count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSLocationCell *locationCell = (MUSLocationCell *) cell;
    Place *currentPlace = self.arrayLocations[indexPath.row];
    if (currentPlace.isChosen) {
        self.chosenPlaceIndexPath = indexPath;
    }
    [locationCell configurationLocationCell: currentPlace];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSLocationCell reuseIdentifier]];
    if(!cell) {
        cell = [MUSLocationCell locationCell];
    }
    cell.delegate = self;
    /*
    Place *currentPlace = self.arrayLocations[indexPath.row];
    if (currentPlace.isChosen) {
        self.chosenPlaceIndexPath = indexPath;
    }
    [cell configurationLocationCell: currentPlace];
     */
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     get chosen object Place and send to shareViewController via block, leave this controller
     */
    
    if (self.chosenPlaceIndexPath.row != indexPath.row || !self.chosenPlaceIndexPath) {
        [self obtainPlaceForPost: indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.arrayLocations firstObject]) {
        Place *currentPlace = [self.arrayLocations objectAtIndex: indexPath.row];
        CGFloat height = [MUSLocationCell heightForLocationCell: currentPlace];
        return height;
    }
    return 38;
}

- (void) obtainPlaceForPost : (NSInteger) currentIndex {
    Place *chosenPlace = [self.arrayLocations objectAtIndex: currentIndex];
    self.placeComplition(chosenPlace, nil);
    [self.navigationController popViewControllerAnimated : YES];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - MUSLocationCellDelegate

- (void) deleteChosenPlaceFromTableViewAndMap {
    [self changeStatusForChosenPlace];
    [self.customMapView deleteChosenPlaceFromMap];
}

#pragma mark - MUSCustomMapViewDelegate

- (void) selectedPlaceForPostByIndex:(NSInteger)index {
    [self obtainPlaceForPost: index];
}

- (void) deleteChosenPlaceFromTableView {
    [self changeStatusForChosenPlace];
}

#pragma mark - changeStatusForChosenPlace

- (void) changeStatusForChosenPlace {
    Place *currentPlace;
    for (Place *place in self.arrayLocations) {
        if (place.isChosen) {
            currentPlace = place;
            currentPlace.isChosen = NO;
            self.place = nil;
        }
    }
    [self.arrayLocations replaceObjectAtIndex: self.chosenPlaceIndexPath.row withObject: currentPlace];
    self.chosenPlaceIndexPath = nil;
    [self.tableView reloadData];
}


#pragma mark - UIAlertView

- (void) showErrorAlertWithError : (NSError*) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle : Error
                                                         message : [error localizedFailureReason]
                                                        delegate : nil
                                               cancelButtonTitle : musAppButtonTitle_OK
                                               otherButtonTitles : nil];
    [errorAlert show];
}

@end
