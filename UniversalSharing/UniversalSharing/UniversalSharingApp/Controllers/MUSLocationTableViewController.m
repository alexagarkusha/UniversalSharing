//
//  MUSLocationTableViewController.m
//  UniversalSharing
//
//  Created by Roman on 8/3/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSLocationTableViewController.h"
#import "Place.h"
@interface MUSLocationTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *arrayLocations;
@end

@implementation MUSLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setArrayPlaces:(NSArray*)arrayPlaces {
    self.arrayLocations = arrayPlaces;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayLocations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    if (cell) {
        Place *place = self.arrayLocations[indexPath.row];
        cell.textLabel.text = place.fullName;
    }
    
    return cell;
}

#warning "Check logic if no block"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.placeComplition){
        Place *place = self.arrayLocations[indexPath.row];
        self.placeComplition(place, nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


@end
