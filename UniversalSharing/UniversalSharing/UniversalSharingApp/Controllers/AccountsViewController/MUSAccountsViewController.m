//
//  ViewController.m
//  UniversalSharing
//
//  Created by Roman on 7/20/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "MUSAccountsViewController.h"
#import "MUSUserDetailViewController.h"
#import "MUSSocialNetworkLibraryHeader.h"
#import "ConstantsApp.h"
#import "ReachabilityManager.h"
#import "UIButton+CornerRadiusButton.h"
#import <AFMSlidingCell.h>
#import "MUSDatabaseRequestStringsHelper.h"


@interface MUSAccountsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate, AFMSlidingCellDelegate>

@property (weak, nonatomic) IBOutlet    UITableView *tableView;
//@property (weak, nonatomic) IBOutlet    UIBarButtonItem *btnEditOutlet;
/*!
 @property error view - shows error Internet connection
 */
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIButton *updateNetworkConnectionOutlet;
@property (weak, nonatomic) IBOutlet UIButton *buttonUseAnywayOutlet;

/*!
 @property
 @abstract initialization by socialnetwork objects from socialmanager(facebook or twitter or VK)
 */
@property (strong, nonatomic) NSMutableArray *arrayWithNetworksObj;
/*!
 @property
 @abstract initialization by NSIndexPath in method didSelectRowAtIndexPath and buttonsDidShowForCell in order to get current socialnetwork in method prepareForSegue from arrayWithNetworksObj and disappear button when editing
 */
@property (strong, nonatomic) NSIndexPath * selectedIndexPath;
/*!
 @property
 @abstract array with buttons
 */
@property (strong, nonatomic) NSMutableArray *arrayButtons;
/*!
 @property
 @abstract using in order to forbid to swipe second cell when one is swiped
 */
@property (assign, nonatomic) BOOL flag;
@property (assign, nonatomic) BOOL flagTouches;
/*!
 @method check access to the Internet connection
 */
- (IBAction)updateNetworkConnection:(id)sender;

@end

@implementation MUSAccountsViewController

- (void)viewDidLoad {
    //////////////////////////////////////////////////////////////////////////
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];

    ///////////////////////////////////////////////////////////////////////////////
    [super viewDidLoad];
    [self obtanObjectsOfSocialNetworks];
    self.arrayButtons = [NSMutableArray new];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkInternetConnection];
    //[self.tableView setUserInteractionEnabled:YES];
    
}

/*!
 @method
 @abstract checking internet connection
 @param without
 */
- (void) checkInternetConnection {
    BOOL isReachable = [ReachabilityManager isReachable];
    BOOL isReachableViaWiFi = [ReachabilityManager isReachableViaWiFi];
    
    if (!isReachableViaWiFi && !isReachable) {
        self.errorView.hidden = NO;
        //self.btnEditOutlet.enabled = NO;
        [self.updateNetworkConnectionOutlet cornerRadius:CGRectGetHeight(self.updateNetworkConnectionOutlet.frame) / 2];
        [self.buttonUseAnywayOutlet cornerRadius: CGRectGetHeight(self.buttonUseAnywayOutlet.frame) / 2];
    } else {
        self.errorView.hidden = YES;
        //self.btnEditOutlet.enabled = YES;
        [self.tableView reloadData];
        [self.arrayButtons removeAllObjects];
    }
}
- (IBAction) buttonUseAnyWayTapped :(id)sender {
    self.errorView.hidden = YES;
    //self.btnEditOutlet.enabled = YES;
    [self obtanObjectsOfSocialNetworks];
    [self.arrayButtons removeAllObjects];
    [self.tableView reloadData];
    
    
}

//- (IBAction)btnEditTapped:(id)sender {
//    [[self obtainCurrentCell:self.selectedIndexPath] hideButtonViewAnimated:YES];
//    
//    if(self.editing) {
//        [super setEditing:NO animated:NO];
//        [self.tableView setEditing:NO animated:NO];
//        [self.navigationItem.leftBarButtonItem setTitle:editButtonTitle];
////        [self.arrayButtons removeAllObjects];
////        [self.tableView reloadData];
//
//    } else {
//        [super setEditing:YES animated:YES];
//        [self.tableView setEditing:YES animated:YES];
//        [self.navigationItem.leftBarButtonItem setTitle:doneButtonTitle];
//    }
//}

/*!
 @method
 @abstract get objects of social network from socialManager, we pass array with NetworkType
 @param without
 */
- (void) obtanObjectsOfSocialNetworks {
    NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
    self.arrayWithNetworksObj = [[SocialManager sharedManager] networks : arrayWithNetworks];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWithNetworksObj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSAccountTableViewCell cellID]];
    SocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    
    if(!cell) {
        cell = [MUSAccountTableViewCell accountTableViewCell];
    }
    //if(!self.editing){
    __weak MUSAccountsViewController *weakSelf = self;
    [cell setDelegate:self];
    [cell addFirstButton:[self createButtonHideShow :indexPath :socialNetwork] withWidth:80.0 withTappedBlock:^(AFMSlidingCell *cell) {
        [cell hideButtonViewAnimated:YES];
        [weakSelf changeTitleButton:[weakSelf obtainIndexPath:cell]];
    }];
   // }
    [cell configurateCellForNetwork:socialNetwork];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    SocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    if(!socialNetwork.isVisible){
        return;
    }
    /*!
     when cell is tapped we check this social network is login and existed a currentuser object  if YES we go to ditailviewcontroller, else to do login than go to ditailviewcontroller
     */
    if (socialNetwork.isLogin && socialNetwork.currentUser) {
        [self performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
        
    } else {
        __weak MUSAccountsViewController *weakSelf = self;
        [socialNetwork loginWithComplition:^(SocialNetwork* result, NSError *error) {
            if (result) {
               
                [weakSelf performSegueWithIdentifier: goToUserDetailViewControllerSegueIdentifier sender:nil];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self changeTitleButton:indexPath];
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
//    /*
//     change socialnetwork objects and position buttons when cells are changed
//     */
//    SocialNetwork *socialNetwork = [self.arrayWithNetworksObj objectAtIndex:fromIndexPath.row];
//    [self.arrayWithNetworksObj removeObjectAtIndex:fromIndexPath.row];
//    [self.arrayWithNetworksObj insertObject:socialNetwork atIndex:toIndexPath.row];
//    
//    UIButton *currentButton = [self.arrayButtons objectAtIndex:fromIndexPath.row];
//    [self.arrayButtons removeObjectAtIndex:fromIndexPath.row];
//    [self.arrayButtons insertObject:currentButton atIndex:toIndexPath.row];
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine if it's in editing mode
    if (self.tableView.editing) {
        if ([self.arrayButtons[indexPath.row] isEqual:[NSNull null]]) {
            return UITableViewCellEditingStyleNone;
        }
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self obtainCurrentSocialNetwork:indexPath].isVisible ?  showButtonTitle : hideButtonTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeCell = 50.0f;
    return sizeCell;
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSUserDetailViewController *vc = [MUSUserDetailViewController new];
    if ([[segue identifier] isEqualToString:goToUserDetailViewControllerSegueIdentifier]) {
        vc = [segue destinationViewController];
        [vc setNetwork:self.arrayWithNetworksObj[self.selectedIndexPath.row]];
    }
}

- (IBAction)updateNetworkConnection:(id)sender {
    [self checkInternetConnection];
}

#pragma mark AFMSlidingCell Delegate

- (void)buttonsDidShowForCell:(AFMSlidingCell *)cell {
    _flag = YES;
    
    self.selectedIndexPath = [self obtainIndexPath:cell];
}
- (void)buttonsDidHideForCell:(AFMSlidingCell *)cell {
    _flag = NO;
}
- (BOOL)shouldAllowShowingButtonsForCell:(AFMSlidingCell *)cell {
    if (self.tableView.editing || _flag || [self.arrayButtons[[self obtainIndexPath:cell].row] isEqual:[NSNull null]]) {
        return NO;
    }
    return YES;
}

- (NSIndexPath*) obtainIndexPath :(AFMSlidingCell *)cell {
    CGPoint location = cell.layer.position;
    return [self.tableView indexPathForRowAtPoint:location];
}

-(void) changeTitleButton :(NSIndexPath *)indexPath {
    SocialNetwork *socialNetwork = [self obtainCurrentSocialNetwork:indexPath];
    /*!
     in order to set bool property isVisible for configurating color of cell
     */
    [[self obtainCurrentCell:indexPath] changeColorOfCell:socialNetwork];
    [self.arrayButtons[indexPath.row] setTitle: !socialNetwork.isVisible ?  showButtonTitle : hideButtonTitle forState:UIControlStateNormal];
    //////////////
    if (!socialNetwork.isVisible) {
        if (indexPath.row != 2) {
            [self.arrayWithNetworksObj removeObjectAtIndex:indexPath.row];
            [self.arrayWithNetworksObj insertObject:socialNetwork atIndex:2];
        }
        
    } else {
        if (indexPath.row != 0) {
        [self.arrayWithNetworksObj removeObjectAtIndex:indexPath.row];
        [self.arrayWithNetworksObj insertObject:socialNetwork atIndex:0];
        }
    }
   // if(!self.editing)
    [self.arrayButtons removeAllObjects];
    [self.tableView reloadData];
    
}

- (MUSAccountTableViewCell*) obtainCurrentCell :(NSIndexPath*) indexPath {
    return  (MUSAccountTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
}

- (SocialNetwork*) obtainCurrentSocialNetwork : (NSIndexPath*) indexPath {
    return self.arrayWithNetworksObj[indexPath.row];
}

- (UIButton *)createButtonHideShow:(NSIndexPath *)indexPath :(SocialNetwork*)socialNetwork {
    if (!socialNetwork.isLogin) {
        [self.arrayButtons addObject:[NSNull null]];
        return nil;
    } else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:!socialNetwork.isVisible ?  showButtonTitle : hideButtonTitle forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [self.arrayButtons addObject:button];
    }
    return self.arrayButtons[indexPath.row];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.arrayWithNetworksObj exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.arrayButtons exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


@end
