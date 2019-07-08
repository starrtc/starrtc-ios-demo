//
//  SuperRoomMemberCell.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperRoomMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SuperRoomMemberCell : UICollectionViewCell
- (void)setupCellData:(SuperRoomMemberModel* _Nullable)data;
@end

NS_ASSUME_NONNULL_END
