//
//  SuperRoomMembersView.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SuperRoomMembersView.h"

@interface SuperRoomMembersView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<SuperRoomMemberModel*> *membersDataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@end

@implementation SuperRoomMembersView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.membersDataSource = [NSMutableArray arrayWithCapacity:1];
    UINib *cellNib = [SuperRoomMemberCell nib];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"SuperRoomMemberCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat itemWidth = 60;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 20);
    flowLayout.minimumInteritemSpacing = (self.collectionView.frame.size.width - 60 * 3 )/2.0 - 1;
}

- (void)addMember:(NSString*)uid{
    if ([uid isEqualToString:self.roomInfo.Creator]) {
        [self.headerButton setImage:[UIImage imageWithUserId:uid] forState:UIControlStateNormal];
        self.nickNameLabel.text = [NSString stringWithFormat:@"%@",uid];
    } else {
        SuperRoomMemberModel *model = [SuperRoomMemberModel new];
        model.uid = uid;
        [self.membersDataSource addObject:model];
        [self.collectionView reloadData];
    }
}
- (void)removeMember:(NSString*)uid{
    [self.membersDataSource enumerateObjectsUsingBlock:^(SuperRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:uid]) {
            [self.membersDataSource removeObjectAtIndex:idx];
            *stop = YES;
            [self.collectionView reloadData];
        }
    }];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SuperRoomMemberCell *cell = (SuperRoomMemberCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"SuperRoomMemberCell" forIndexPath:indexPath];
    if (indexPath.row < self.membersDataSource.count) {
        [cell setupCellData:self.membersDataSource[indexPath.row]];
    } else {
        [cell setupCellData:nil];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}




@end
