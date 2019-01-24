//
//  SpeechMessageCell.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpeechMessageCell : UITableViewCell
- (void)setupCellData:(SpeechMessageModel* _Nullable)data;
@end

NS_ASSUME_NONNULL_END
