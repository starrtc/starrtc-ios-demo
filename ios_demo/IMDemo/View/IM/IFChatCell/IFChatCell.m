//
//  IFChatCell.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/10.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFChatCell.h"

const int leadingSpace = 8;
const int trailingSpace = 8;
const int bottomSpace = 8;
const CGFloat iconHeight = 40;

const CGFloat textTopSpace = 13;
const CGFloat textBottomSpace = bottomSpace + 13;
const CGFloat textLeadingSpace = 13 + trailingSpace;
const CGFloat textTrailingSpace = 13 + leadingSpace*2 + iconHeight;

const static int subTitleFontNum = 16;


@interface IFChatCell () {
    UIImageView *_textBGIV;
    IFChatCellStyle _layoutType;
}
@end

@implementation IFChatCell

- (instancetype)initWithStyle:(IFChatCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    
    if (_layoutType == IFChatCellStyleLeft || _layoutType == IFChatCellStyleRight) {
        UIRectCorner rectCorners = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        if (_layoutType == IFChatCellStyleRight || _layoutType == IFChatCellStyleRightAndNoBG) {
            rectCorners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_textBGIV.bounds byRoundingCorners:rectCorners cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = path.CGPath;
        _textBGIV.layer.mask = shapeLayer;
    }
}


#pragma mark - UI

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconIV = imageView;
    
    UIImageView *textBGIV = [[UIImageView alloc] init];
    _textBGIV = textBGIV;
    if (_layoutType == IFChatCellStyleRight || _layoutType == IFChatCellStyleLeft) {
        textBGIV.backgroundColor = [UIColor colorWithHexString:@"FF9A50"];
    }

    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:18];
    _titleLabel = label;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:subTitleFontNum];
    label2.numberOfLines = 0;
    _subTitleLabel = label2;
    
    [self addSubview:imageView];
    [self addSubview:textBGIV];
    [self addSubview:label];
    [self addSubview:label2];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView).offset(0);
        make.leading.equalTo(imageView.mas_trailing).offset(leadingSpace);
        make.trailing.equalTo(self).offset(-leadingSpace);
        make.height.mas_equalTo(20);
    }];
    
    if (_layoutType == IFChatCellStyleLeft || _layoutType == IFChatCellStyleLeftAndNoBG) {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(leadingSpace);
            make.top.equalTo(label).offset(20);
            make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(2*textTopSpace);
            make.leading.equalTo(imageView.mas_trailing).offset(textLeadingSpace);
            make.trailing.lessThanOrEqualTo(self).offset(-textTrailingSpace);
            make.bottom.equalTo(self).offset(-10);
        }];
        
        [textBGIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2).offset(-5); // -textTopSpace
            make.leading.equalTo(label2).offset(-13);
            make.trailing.equalTo(label2).offset(13);
            make.bottom.equalTo(label2).offset(textTopSpace);
        }];
    } else {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-leadingSpace);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(textTopSpace);
            make.trailing.equalTo(imageView.mas_leading).offset(-textLeadingSpace);
            make.leading.greaterThanOrEqualTo(self).offset(textTrailingSpace);
            make.bottom.equalTo(self).offset(-textBottomSpace);
        }];
        
        [textBGIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2).offset(-textTopSpace);
            make.leading.equalTo(label2).offset(-13);
            make.trailing.equalTo(label2).offset(13);
            make.bottom.equalTo(label2).offset(textTopSpace);
        }];
    }
}

+ (CGFloat)reserveWithForCell {
    return 3*leadingSpace + iconHeight + textLeadingSpace + textTrailingSpace;
}

+ (CGFloat)caculateTextHeightWithMaxWidth:(CGFloat)maxWidth text:(NSString *)text {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:subTitleFontNum] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat height = ceilf(size.height);
    if (height < iconHeight - textTopSpace*2) {
        height = iconHeight - textTopSpace*2;
    }
    return  height + textTopSpace + 2*textBottomSpace;
}
@end
