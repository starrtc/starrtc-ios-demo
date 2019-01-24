//
//  ChatRoomViewController.h
//  IMDemo
//
//  Created by  Admin on 2017/12/25.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import "IFBaseVC.h"

typedef NS_ENUM(int, IFChatroomVCType) {
    IFChatroomVCTypeFromList, //从聊天室列表而来
    IFChatroomVCTypeFromCreate, //从创建聊天室而来
    IFChatroomVCTypeFromC2C //从创建一对一聊天而来
};

@interface ChatRoomViewController : IFBaseVC<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>

@property NSString *mRoomId;
@property NSString *mRoomName;
@property NSString *mCreaterId;

@property (nonatomic, copy) NSString *targetID; //C2C接收消息者的uid

@property NSString *USER_TYPE;
@property (nonatomic, assign) IFChatroomVCType fromType;
@end
