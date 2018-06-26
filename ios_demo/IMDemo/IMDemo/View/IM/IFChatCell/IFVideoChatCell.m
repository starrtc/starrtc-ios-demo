//
//  IFChatCell.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/10.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFVideoChatCell.h"

const int kLeadingSpace = 8;
const int kTrailingSpace = 8;
const int kBottomSpace = 8;

const static int kSubTitleFontNum = 16;


@interface IFVideoChatCell () {
    UIImageView *_textBGIV;
    IFVideoChatCellStyle _layoutType;
}
@end

@implementation IFVideoChatCell

- (instancetype)initWithStyle:(IFVideoChatCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _layoutType = style;
        
        [self createUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    if (_layoutType == IFChatCellStyleLeft || _layoutType == IFChatCellStyleRight) {
//        UIRectCorner rectCorners = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
//        if (_layoutType == IFChatCellStyleRight) {
//            rectCorners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
//        }
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_textBGIV.bounds byRoundingCorners:rectCorners cornerRadii:CGSizeMake(8, 8)];
//        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
//        shapeLayer.path = path.CGPath;
//        _textBGIV.layer.mask = shapeLayer;
//    }
}


#pragma mark - UI

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *textBGIV = [[UIImageView alloc] init];
    _textBGIV = textBGIV;
    if (_layoutType == IFChatCellStyleRight || _layoutType == IFChatCellStyleLeft) {
//        textBGIV.backgroundColor = [UIColor colorWithHexString:@"FF9A50"];
    }

    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:kSubTitleFontNum];
    label.numberOfLines = 0;
    _titleLabel = label;
    
//    [self addSubview:textBGIV];
    [self addSubview:label];
    
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(kLeadingSpace);
        make.trailing.lessThanOrEqualTo(weakSelf).offset(-kTrailingSpace);
        make.bottom.equalTo(weakSelf).offset(-kBottomSpace);
    }];
    
    if (_layoutType == IFChatCellStyleLeft) {
        
    } else {
        
    }
}

+ (CGFloat)reserveWithForCell {
    return kLeadingSpace + kTrailingSpace;
}

+ (CGFloat)caculateTextHeightWithMaxWidth:(CGFloat)maxWidth text:(NSString *)text {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:kSubTitleFontNum] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat height = ceilf(size.height);
    
    return  height + kBottomSpace;
}
@end
