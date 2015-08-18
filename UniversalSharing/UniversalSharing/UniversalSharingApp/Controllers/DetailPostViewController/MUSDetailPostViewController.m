//
//  MUSDetailPostViewController.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSDetailPostViewController.h"
#import "MUSGalleryOfPhotosCell.h"
#import "MUSCommentsAndLikesCell.h"
#import "MUSPostDescriptionCell.h"
#import "MUSPostLocationCell.h"

@interface MUSDetailPostViewController () <UITableViewDataSource, UITableViewDelegate, MUSPostDescriptionCellDelegate, MUSGalleryOfPhotosCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat heightOfPostDescriptionRow;
@property (nonatomic, assign) CGFloat heightOfGalleryOfPhotosRow;

@end


@implementation MUSDetailPostViewController

- (void)viewDidLoad {
    [self initiationTableView];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear : YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initiation UITableView

- (void) initiationTableView {
    self.tableView = ({
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, screenSize.width, screenSize.height - self.tabBarController.tabBar.frame.size.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*!
     XIB
     */
    
    if (indexPath.row ==  0) {
        MUSGalleryOfPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSGalleryOfPhotosCell cellID]];
        if(!cell) {
            cell = [MUSGalleryOfPhotosCell galleryOfPhotosCell];
        }
        cell.delegate = self;
        cell.currentPost = self.currentPost;
        [cell configurationGalleryOfPhotosCellByPost: self.currentPost andUser: self.currentUser];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        MUSCommentsAndLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSCommentsAndLikesCell cellID]];
        if(!cell) {
            cell = [MUSCommentsAndLikesCell commentsAndLikesCell];
        }
        [cell configurationCommentsAndLikesCellByPost: self.currentPost];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 2) {
        MUSPostDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostDescriptionCell cellID]];
        if(!cell) {
            cell = [MUSPostDescriptionCell postDescriptionCell];
        }
        cell.delegate = self;
        [cell configurationPostDescriptionCellByPost: self.currentPost];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        MUSPostLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSPostLocationCell cellID]];
        if(!cell) {
            cell = [MUSPostLocationCell postLocationCell];
        }
        [cell configurationPostLocationCellByPost: self.currentPost];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.heightOfGalleryOfPhotosRow;
    } else if (indexPath.row == 1) {
        return 40;
    } else if (indexPath.row == 2) {
        return self.heightOfPostDescriptionRow;
    } else if (indexPath.row == 3) {
        return 150;
    }
    
    return 150;
}

#pragma mark - MUSPostDescriptionCellDelegate

- (void) heightOfPostDescriptionRow : (CGFloat) heightRow {
    self.heightOfPostDescriptionRow = heightRow;
}

#pragma mark - MUSGalleryOfPhotosCellDelegate

- (void) heightOfGalleryOfPhotosRow:(CGFloat)heightRow {
    NSLog(@"Gallery = %f", heightRow);
    self.heightOfGalleryOfPhotosRow = heightRow;
}


@end
