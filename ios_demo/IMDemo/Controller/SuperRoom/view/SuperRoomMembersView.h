//
//  SuperRoomMembersView.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperRoomMemberCell.h"
#import "SuperRoomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SuperRoomMembersView : UIView
@property (nonatomic, strong) SuperRoomModel *roomInfo;
- (void)addMember:(NSString*)uid;
- (void)removeMember:(NSString*)uid;
@end

NS_ASSUME_NONNULL_END
