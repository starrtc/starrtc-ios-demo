//
//  QGSendboxViewerCell.h
//  QGSandboxViewer
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGSendboxViewerModel.h"

@class QGSendboxViewerCell;

@interface QGSendboxViewerCell : UITableViewCell

+ (UINib*)instanceForNib;

- (void)setupCellData:(QGSendboxViewerModel*)cellData indexPath:(NSIndexPath*)indexPath;

@end
