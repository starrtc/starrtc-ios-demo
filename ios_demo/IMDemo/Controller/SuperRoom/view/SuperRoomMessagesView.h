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

@interface SuperRoomMessagesView : UIView

- (void)addMessage:(SuperRoomMessageModel*)message;

@end

NS_ASSUME_NONNULL_END
