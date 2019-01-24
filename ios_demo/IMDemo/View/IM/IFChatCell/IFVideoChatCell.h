//
//  IFChatCell.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/10.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IFVideoChatCellStyle) {
    IFChatCellStyleLeft,
    IFChatCellStyleRight
};

extern const int leadingSpace; //文本两端空白

@interface IFVideoChatCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subTitleLabel;
@property (nonatomic, strong, readonly) UIImageView *iconIV;
@property (nonatomic, assign) BOOL isNotNeedBackground;

- (instancetype)initWithStyle:(IFVideoChatCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)caculateTextHeightWithMaxWidth:(CGFloat)maxWidth text:(NSString *)text;

+ (CGFloat)reserveWithForCell;
@end
