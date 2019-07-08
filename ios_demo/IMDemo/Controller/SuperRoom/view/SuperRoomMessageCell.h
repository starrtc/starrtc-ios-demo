//
//  SuperRoomMessageCell.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperRoomMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SuperRoomMessageCell : UITableViewCell
- (void)setupCellData:(SuperRoomMessageModel* _Nullable)data;
@end

NS_ASSUME_NONNULL_END
