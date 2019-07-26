//
//  SuperRoomMessagesView.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperRoomMessageCell.h"
NS_ASSUME_NONNULL_BEGIN


@protocol SuperRoomMessagesViewDelegate <NSObject>

-(void)chooseItem:(NSString *)userID;

@end


@interface SuperRoomMessagesView : UIView

@property (nonatomic, weak) id<SuperRoomMessagesViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messagesDataSource;

- (void)addMessage:(SuperRoomMessageModel*)message;

@end

NS_ASSUME_NONNULL_END
