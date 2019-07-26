//
//  SuperRoomMessagesView.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SuperRoomMessagesView.h"
@interface SuperRoomMessagesView () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation SuperRoomMessagesView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.messagesDataSource = [NSMutableArray arrayWithCapacity:1];
    //[self.messagesDataSource addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;

//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib * nibCell = [UINib nibWithNibName:@"SuperRoomMessageCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:@"SuperRoomMessageCell"];

    
    SuperRoomMessageModel *model = [[SuperRoomMessageModel alloc] initWithNickname:UserId content:@"hahahhahahah"];
    [self addMessage:model];
}
- (void)addMessage:(SuperRoomMessageModel*)message{
    if (message == nil) {
        return;
    }
    if (self.messagesDataSource.count > 100) {
        [self.messagesDataSource removeObjectAtIndex:0];
    }
    [self.messagesDataSource addObject:message];
    [self.tableView reloadData];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesDataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}



//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    SuperRoomMessageCell *cell = (SuperRoomMessageCell*)[tableView dequeueReusableCellWithIdentifier:@"SuperRoomMessageCell"];
//    if (indexPath.row < self.messagesDataSource.count) {
//        [cell setupCellData:self.messagesDataSource[indexPath.row]];
//    } else {
//        [cell setupCellData:nil];
//    }
//    return cell;
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.messagesDataSource.count;
//}
//
//
//
//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"选中了第%li个cell", (long)indexPath.row);
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SuperRoomMessageModel *message = _messagesDataSource[indexPath.row];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseItem:)]) {
//        [self.delegate chooseItem:message.nickname];
//    }
//
//
//}


@end
