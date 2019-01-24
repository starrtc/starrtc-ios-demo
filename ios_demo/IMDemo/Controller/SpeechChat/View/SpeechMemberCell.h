//
//  SpeechMemberCell.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpeechMemberCell : UICollectionViewCell
- (void)setupCellData:(SpeechMemberModel* _Nullable)data;
@end

NS_ASSUME_NONNULL_END
