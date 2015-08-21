//
//  MUSPostsViewController.m
//  UniversalSharing
//
//  Created by U 2 on 17.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSPostsViewController.h"
#import "MUSDetailPostViewController.h"
#import "DOPDropDownMenu.h"
#import "MUSPostCell.h"
#import "ConstantsApp.h"
#import "SocialManager.h"
#import "DataBaseManager.h"
#import "MUSDetailPostViewController.h"
@interface MUSPostsViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *arrayPosts;
@property (nonatomic, strong) NSArray *arrayOfShareReason;
@property (nonatomic, strong) NSMutableArray *arrayOfActiveSocialNetwork;
@property (nonatomic, strong) DOPDropDownMenu *menu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) FilterInColumnType columnType;

@property (nonatomic, strong) NSString *predicateNetworkType;
@property (nonatomic, strong) NSString *predicateReason;


@end

@implementation MUSPostsViewController

- (void)viewDidLoad {
    [self POSTS]; // DELETE THIS AFTER Connect SQLite
    //self.arrayPosts = [NSArray arrayWithArray: [[DataBaseManager sharedManager] obtainAllRowsFromTableNamedPosts]];
    
    [self initiationArrayOfShareReason];
    [self initiationArrayOfActiveSocialNetwork];
    [self initiationDropDownMenu];
    [self initiationTableView];

    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
    [self initiationArrayOfShareReason];
    [self initiationArrayOfActiveSocialNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initiation DOPDropDownMenu 

- (void) initiationDropDownMenu {
    [super viewDidLoad];
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height) andHeight: 40];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    [self.view addSubview : self.menu];
}

#pragma mark initiation UITableView

- (void) initiationTableView {
    self.tableView = ({
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,  [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height + self.menu.frame.size.height, screenSize.width, screenSize.height - self.menu.frame.origin.y - self.menu.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark initiation ArrayOfShareReason

- (void) initiationArrayOfShareReason {
    self.arrayOfShareReason = [[NSArray alloc] initWithObjects: @"All share reasons", musAppFilter_Title_Shared, musAppFilter_Title_Offline, musAppFilter_Title_Error,  nil];
}

#pragma mark initiation ArrayOfPostsType

//- (NSString*) obtainPathToDocumentsFolder :(NSString*) pathFromDataBase {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    return [documentsPath stringByAppendingPathComponent:pathFromDataBase];
//}

- (void) initiationArrayOfActiveSocialNetwork {
    //////////////////////////////////////////////////////////////////////////////////////////
//    NSArray *temp = [[DataBaseManager sharedManager] obtainAllRowsFromTableNamedUsers];
//    [temp enumerateObjectsUsingBlock:^(User *user, NSUInteger index, BOOL *stop) {
//        [[NSFileManager defaultManager] removeItemAtPath: [self obtainPathToDocumentsFolder:user.photoURL] error: nil];
//        
//    }];
    
    
    ///////////////////////////////////////////////////////
    self.arrayOfActiveSocialNetwork = [[NSMutableArray alloc] init];
    [self.arrayOfActiveSocialNetwork addObject: @"All social networks"];
    NSArray *arrayWithNetworks = @[@(Twitters), @(VKontakt), @(Facebook)];
    __weak MUSPostsViewController *weakSelf = self;
    [[[SocialManager sharedManager] networks: arrayWithNetworks] enumerateObjectsUsingBlock:^(SocialNetwork *socialNetwork, NSUInteger index, BOOL *stop) {
        if (socialNetwork.isLogin) {
            [weakSelf.arrayOfActiveSocialNetwork addObject : socialNetwork.name];
        }
        
    }];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayPosts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    MUSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostCell cellID]];
    if(!cell) {
        cell = [MUSPostCell postCell];
    }
    [cell configurationPostCell: [self.arrayPosts objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier: goToDetailPostViewControllerSegueIdentifier sender:[self.arrayPosts objectAtIndex: indexPath.row]];
    /*
    MUSDetailPostViewController *detailPostViewController = [[MUSDetailPostViewController alloc] init];
    detailPostViewController.currentPost = [self.arrayPosts objectAtIndex: indexPath.row];
    [self.navigationController pushViewController:detailPostViewController animated:YES];
    self.navigationController.navigationBar.translucent = YES;
     */
}
     

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MUSDetailPostViewController *detailPostViewController = [[MUSDetailPostViewController alloc] init];
    if ([[segue identifier] isEqualToString:goToDetailPostViewControllerSegueIdentifier]) {
        detailPostViewController = [segue destinationViewController];
        [detailPostViewController setCurrentPost: sender];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98;
}



#pragma mark - DOPDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn : (NSInteger)column {
    self.columnType = column;
    NSInteger numberOfRowsInColumn;
    switch (self.columnType) {
        case ByNetworkType:
            numberOfRowsInColumn = self.arrayOfActiveSocialNetwork.count;
            break;
        case ByShareReason:
             numberOfRowsInColumn = self.arrayOfShareReason.count;
            break;
        default:
            break;
    }
    return numberOfRowsInColumn;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    self.columnType = indexPath.column;
    switch (self.columnType) {
        case ByNetworkType:
            return self.arrayOfActiveSocialNetwork [indexPath.row];
            break;
        case ByShareReason:
            return self.arrayOfShareReason [indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - DOPDropDownMenuDelegate

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    
    NSString *title = [menu titleForRowAtIndexPath:indexPath];

    self.columnType = indexPath.column;

    switch (self.columnType) {
        case ByNetworkType:{
            if (indexPath.row == 0) {
                self.predicateNetworkType = @"";
            } else {
                self.predicateNetworkType = [NSString stringWithFormat: @" WHERE networkType=\"%d\"", [self networkTypeFromTitle: title]];
            }
        }
            break;
        case ByShareReason:{
            if (indexPath.row == 0) {
                self.predicateReason = @"";
            } else {
                self.predicateReason = [NSString stringWithFormat:@" reason=\"%d\"", [self reasonFromTitle:title]];
            }
        }
            break;
        default:
            break;
    }
    
    
    NSString *query = [[NSString alloc] init];
    if (self.predicateNetworkType.length > 0) {
        query = self.predicateNetworkType;
        if (self.predicateReason.length > 0) {
            query = [query stringByAppendingString: @" AND"];
            query = [query stringByAppendingString: [NSString stringWithFormat: @"%@", self.predicateReason]];
        }
    } else {
        query = self.predicateReason;
    }
    NSLog(@"query = %@", query);
}

#pragma mark - NetworkTypeFromMenuTitle

- (NSInteger) networkTypeFromTitle : (NSString*) title {
    if ([title isEqual: musAppFilter_Title_Error]) {
        return ErrorConnection;
    } else if ([title isEqual: musAppFilter_Title_Offline]) {
        return Offline;
    } else {
        return Connect;
    }
}

#pragma mark - ReasonFromMenuTitle

- (NSInteger) reasonFromTitle : (NSString*) title {
    if ([title isEqual: musVKName]) {
        return VKontakt;
    } else if ([title isEqual: musFacebookName]) {
        return Facebook;
    } else {
        return Twitters;
    }
}


///////////////////// DELETE THIS AFTER Connect SQLite /////////////////////////

- (void) POSTS {

    Post *post1 = [[Post alloc] init];
    post1.postDescription = @"POST #1 - lskfdjnskdsflsdfksj  sdkjnksjfkjsdkj jsdkjnskjfnsk jsdnkjfskjd jsdkfjnskfjn jsdkjfk jsdkjnskd jsvcvxcvbfj jsdkjnksjnkjn kjndfkjnkdjf kjdfnkdkfngkd jkjfkjndkfnk jkjdfnknvkdfj knnksnfk jsk fnsknfksdn fkns kfnks dnfkj ndskfndsk nfkdsn fkn dskfn kdsn k nk nknsfk nfk dsnk fs kdfn ksdn fkd nskfn dskf nkdsn fdkfn k nkfdnfkdn kfnkffkjfkknknk j k k jkfd kfkdnfd kjnfkdndkndkjnf kfnkjfdnkdjn kfdjnkfdnfkdf kdnkdj nkkdnfk jfnk";
    post1.commentsCount = 2;
    post1.likesCount = 100;
    ImageToPost *image1 = [[ImageToPost alloc] init];
    image1.image = [UIImage imageNamed: @"Comment.png"];
    image1.imageType = JPEG;
    
    ImageToPost *image3 = [[ImageToPost alloc] init];
    image3.image = [UIImage imageNamed: @"UnknownUser.jpg"];
    image3.imageType = JPEG;
    
    post1.arrayImages = [[NSArray alloc] initWithObjects: image1, image3, nil];
    
    //post1.reasonType = Connect;
    post1.networkType = Facebook;
    
    Post *post2 = [[Post alloc] init];
    post2.postDescription = @"POST #2 - lskfdjnskdsflsdfksj";
    post2.commentsCount = 23;
    post2.likesCount = 200;
    //post2.reasonType = ErrorConnection;
    post2.networkType = Twitters;

    Post *post3 = [[Post alloc] init];
    post3.postDescription = @"POST #3 - lskfdjnskdsflsdfksj  sdkjnksjfkjsdkj jsdkjnskjfnsk jsdnkjfskjd jsdkfjnskfjn jsdkjfk jsdkjnskd jsvcvxcvbfj";
    post3.commentsCount = 23333;
    post3.likesCount = 200;
    //post3.reasonType = Offline;
    post3.networkType = VKontakt;
    
    
    Post *post4 = [[Post alloc] init];
    post4.postDescription = @"";
    post4.arrayImages = [[NSArray alloc] initWithObjects: image3, nil];
    post4.commentsCount = 23333;
    post4.likesCount = 200;
    //post3.reasonType = Offline;
    post4.networkType = VKontakt;

    
    self.arrayPosts = [[NSArray alloc] initWithObjects: post1, post2, post3, post4, nil];
     
//    Post *post1 = [[Post alloc] init];
//    post1.postDescription = @"POST #1 - lskfdjnskdsflsdfksj  sdkjnksjfkjsdkj jsdkjnskjfnsk jsdnkjfskjd jsdkfjnskfjn jsdkjfk jsdkjnskd jsvcvxcvbfj";
//    post1.comentsCount = 2;
//    post1.likesCount = 100;
//    post1.reasonType = Connect;
//    post1.networkType = Facebook;
//    
//    Post *post2 = [[Post alloc] init];
//    post2.postDescription = @"POST #2 - lskfdjnskdsflsdfksj  sdkjnksjfkjsdkj jsdkjnskjfnsk jsdnkjfskjd jsdkfjnskfjn jsdkjfk jsdkjnskd jsvcvxcvbfj";
//    post2.comentsCount = 23;
//    post2.likesCount = 200;
//    post2.reasonType = ErrorConnection;
//    post2.networkType = Twitters;
//
//    Post *post3 = [[Post alloc] init];
//    post3.postDescription = @"POST #3 - lskfdjnskdsflsdfksj  sdkjnksjfkjsdkj jsdkjnskjfnsk jsdnkjfskjd jsdkfjnskfjn jsdkjfk jsdkjnskd jsvcvxcvbfj";
//    post3.comentsCount = 23333;
//    post3.likesCount = 200;
//    post3.reasonType = Offline;
//    post3.networkType = VKontakt;
//    
//    self.arrayPosts = [[NSArray alloc] initWithObjects: post1, post2, post3, nil];
}




@end
