//
//  SpeechChatListCell.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/14.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperRoomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SuperRoomListCell : UITableViewCell

- (void)setupCellData:(SuperRoomModel* _Nullable)data;

@end

NS_ASSUME_NONNULL_END
