//
//  MUSDitailPostCollectionViewController.m
//  UniversalSharing
//
//  Created by Roman on 9/4/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostCollectionViewController.h"

@interface MUSDetailPostCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *arrayOfPics;
@property (strong, nonatomic) SocialNetwork *currentSocialNetwork;

@end

@implementation MUSDetailPostCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}



- (void) setObjectsWithArray :(NSArray*) arrayOfPics andCurrentSocialNetwork :(id)currentSocialNetwork {
    self.arrayOfPics = arrayOfPics;
    self.currentSocialNetwork = currentSocialNetwork;    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrayOfPics count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
     UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
    cell.backgroundView = [[UIImageView alloc] initWithImage:self.arrayOfPics[indexPath.row]];
    //[cell addSubView:self.arrayOfPics[indexPath.row]];
    
    return cell;
}



@end
