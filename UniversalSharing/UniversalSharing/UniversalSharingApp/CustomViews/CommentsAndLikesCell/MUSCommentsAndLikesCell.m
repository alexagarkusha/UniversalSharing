//
//  MUSCommentsAndLikesCell.m
//  UniversalSharing
//
//  Created by U 2 on 18.08.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "MUSCommentsAndLikesCell.h"
#import "ConstantsApp.h"
#import "MUSReasonCommentsAndLikesCell.h"

@interface MUSCommentsAndLikesCell ()

@property (weak, nonatomic) IBOutlet UITableView *commentsAndLikesPostTableView;

@end

@implementation MUSCommentsAndLikesCell

+ (NSString*) cellID {
    return NSStringFromClass([self class]);
}

+ (instancetype) commentsAndLikesCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[self cellID] owner:nil options:nil];
    return nibArray[0];
}

#pragma mark - height for CommentsAndLikesCell

+ (CGFloat) heightForCommentsAndLikesCell : (NSArray*) networkPostsArray {
    return [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell] * networkPostsArray.count;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier{
    return [MUSCommentsAndLikesCell cellID];
}

#pragma mark - configuration CommentsAndLikesCellByPost

- (void) configurationCommentsAndLikesCell {
    [self.commentsAndLikesPostTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.networkPostsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSReasonCommentsAndLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:[MUSReasonCommentsAndLikesCell cellID]];
    if(!cell) {
        cell = [MUSReasonCommentsAndLikesCell reasonCommentsAndLikesCell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MUSReasonCommentsAndLikesCell *reasonCommentsAndLikesCell = (MUSReasonCommentsAndLikesCell*) cell;
    [reasonCommentsAndLikesCell configurationReasonCommentsAndLikesCell: [self.networkPostsArray objectAtIndex: indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MUSReasonCommentsAndLikesCell heightForReasonCommentsAndLikesCell];
}


@end
