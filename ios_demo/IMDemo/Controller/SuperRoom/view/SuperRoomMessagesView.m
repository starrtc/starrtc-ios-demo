//
//  SuperRoomMessagesView.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SuperRoomMessagesView.h"
@interface SuperRoomMessagesView () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messagesDataSource;
@end

@implementation SuperRoomMessagesView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.messagesDataSource = [NSMutableArray arrayWithCapacity:1];
    [self.messagesDataSource addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *cellNib = [SuperRoomMessageCell nib];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"SuperRoomMessageCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
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
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesDataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SuperRoomMessageCell *cell = (SuperRoomMessageCell*)[tableView dequeueReusableCellWithIdentifier:@"SuperRoomMessageCell"];
    if (indexPath.row < self.messagesDataSource.count) {
        [cell setupCellData:self.messagesDataSource[indexPath.row]];
    } else {
        [cell setupCellData:nil];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesDataSource.count;
}


@end
