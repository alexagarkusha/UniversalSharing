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

@interface MUSLocationViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MUSCustomMapViewDelegate>
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

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) NSIndexPath* chosenPlaceIndexPath;

@end

@implementation MUSLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiationNavigationBar];
    [self initiationPanGestureRecognizer];
    self.leftConstraintTableView.constant =  self.view.frame.size.width;
    self.rightConstraintTavbleView.constant = - self.view.frame.size.width;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector(tapOnMapView:)];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    self.stringDistance = distanceEqual1000;
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
    UIBarButtonItem *choosePlaceButton = [[UIBarButtonItem alloc] initWithTitle: @"Choose place" style: 1 target:self action: @selector(showCloseTable)];
    self.navigationItem.rightBarButtonItem = choosePlaceButton;
}

- (void) initiationPanGestureRecognizer {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTableView:)];
    self.panGesture.maximumNumberOfTouches = 1;
    self.panGesture.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGesture];
    [self.view bringSubviewToFront: self.navigationController.navigationBar];
}

- (void) showCloseTable {
    if (!self.isOpenTableView) {
        [self showTableViewWithPlaces];
    } else {
        [self closeTableViewWithPlaces];
    }
}

- (void) showTableViewWithPlaces {
    self.leftConstraintTableView.constant =  self.view.frame.size.width / 3;
    self.rightConstraintTavbleView.constant = 0;
    self.leftConstraintCustomMapView.constant = - (self.view.frame.size.width / 3) * 2;
    self.rightConstraintCustomMapView.constant = (self.view.frame.size.width / 3) * 2;
    
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
    self.rightConstraintTavbleView.constant = - (self.view.frame.size.width / 3) * 2;
    
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
                    weakSelf.arrayLocations = places;
                    [weakSelf.customMapView initiationMapView: places withDistance: [weakSelf.stringDistance integerValue] andNetworkType: weakSelf.currentSocialNetwork.networkType];
                    [weakSelf.tableView reloadData];
                    weakSelf.customMapView.delegate = weakSelf.self;
                } else {
                    [self showErrorAlertWithError: error];
                }
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

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
    Place *currentPlace = self.arrayLocations[indexPath.row];
    
    if ([self.place.placeID isEqualToString: currentPlace.placeID]) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        self.chosenPlaceIndexPath = indexPath;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = currentPlace.fullName;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize: 16.0];
  
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     get chosen object Place and send to shareViewController via block, leave this controller
     */
    
    if (self.chosenPlaceIndexPath.row != indexPath.row) {
        [self obtainPlaceForPost: indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.arrayLocations firstObject]) {
        Place *currentPlace = [self.arrayLocations objectAtIndex: indexPath.row];
        
        CGFloat height = [self findHeightForText: currentPlace.fullName havingWidth: (self.view.frame.size.width / 3) * 2 - 24 andFont: [UIFont systemFontOfSize: 16.0]];
        return height;
    }
    return 38;
}

- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize;
    if (text)
    {
        CGSize size;
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, 999)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height);
        result = MAX(size.height, result); //At least one row
    }
    return result + 20;
}


- (void) obtainPlaceForPost : (NSInteger) currentIndex {
    Place *chosenPlace = [self.arrayLocations objectAtIndex: currentIndex];
    self.placeComplition(chosenPlace, nil);
    [self.navigationController popViewControllerAnimated : YES];
    self.navigationController.navigationBar.translucent = YES;

    
    
    NSLog(@"Place name = %@ index = %d", chosenPlace.fullName, currentIndex);

    
    //self.placeComplition(place, nil);
    //[self.navigationController popViewControllerAnimated : YES];
    //self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - MUSCustomMapViewDelegate

- (void) selectedPlaceForPostByIndex:(NSInteger)index {
    [self obtainPlaceForPost: index];
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
