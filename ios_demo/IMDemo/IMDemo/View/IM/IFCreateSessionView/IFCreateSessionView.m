//
//  IFCreateSessionView.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFCreateSessionView.h"

#import "ILGImagePicker.h"

@interface IFCreateSessionView () <ILGImagePickerDelegate> {
    UILabel *_titleL;
    UIButton *_button;
    UIImageView *_corverIV;
    UITextField *_textField;
}
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *controlView; //开放性View
@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation IFCreateSessionView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isHasControl = YES;
        
        [self createUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setMulColor:_button colors:@[(id)[UIColor colorWithHexString:@"FF6000"].CGColor, (id)[UIColor colorWithHexString:@"FFA414"].CGColor] startPoint:@[@0.0, @0.75]];
    [self addLineToButton:self.coverView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter

- (void)setAlertTitle:(NSString *)alertTitle {
    _titleL.text = alertTitle;
}

- (void)setFuncBtnTitle:(NSString *)funcBtnTitle {
    [_button setTitle:funcBtnTitle forState:UIControlStateNormal];
}

- (void)setIsHasControl:(BOOL)isHasControl {
    _isHasControl = isHasControl;
    if (isHasControl) {
        [self.controlView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
    } else {
        [self.controlView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)setIsHasCover:(BOOL)isHasCover {
    _isHasCover = isHasCover;
    
    if (isHasCover) {
        [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_controlView.mas_bottom).offset(10);
            make.leading.equalTo(_lineImageView);
            make.trailing.equalTo(_lineImageView);
            make.height.mas_equalTo(_coverView.mas_width).multipliedBy(164.0/290);
        }];
//        self.coverView.hidden = NO;
//        [_button mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_coverView.mas_bottom).offset(20);
//            make.width.equalTo(_textField);
//            make.centerX.equalTo(_textField);
//            make.height.mas_equalTo(49);
//        }];
        
    } else {
//        self.coverView.hidden = YES;
//        [_button mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_lineImageView.mas_bottom).offset(20);
//            make.width.equalTo(_textField);
//            make.centerX.equalTo(_textField);
//            make.height.mas_equalTo(49);
//        }];
        [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_controlView.mas_bottom).offset(10);
            make.leading.equalTo(_lineImageView);
            make.trailing.equalTo(_lineImageView);
            make.height.mas_equalTo(0);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)setTextFieldPlaceholder:(NSString *)textFieldPlaceholder {
    _textField.placeholder = textFieldPlaceholder;
}

#pragma mark - UI
- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"131313"];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"专属名称";
    _titleL = label;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"填写名称...";
    _textField = textField;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [self addSubview:imageView];
    _lineImageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 24;
    [button setTitle:@"创建" forState:UIControlStateNormal];
    _button = button;
    
    [self addSubview:self.controlView];
    [self addSubview:self.coverView];
    [self addSubview:label];
    [self addSubview:textField];
    [self addSubview:button];
    
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(32);
        make.centerX.equalTo(weakSelf);
        make.height.mas_equalTo(20);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(45);
        make.leading.equalTo(weakSelf).offset(36);
        make.trailing.equalTo(weakSelf).offset(-36);
        make.height.mas_equalTo(20);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(textField);
        make.trailing.equalTo(textField);
        make.top.equalTo(textField.mas_bottom).offset(6);
        make.height.mas_equalTo(1);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.trailing.equalTo(imageView).offset(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_controlView.mas_bottom).offset(10);
        make.leading.equalTo(imageView);
        make.trailing.equalTo(imageView);
//        make.height.mas_equalTo(_coverView.mas_width).multipliedBy(164.0/290);
        make.height.mas_equalTo(0);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverView.mas_bottom).offset(20);
        make.width.equalTo(textField);
        make.centerX.equalTo(textField);
        make.height.mas_equalTo(49);
    }];
}

- (UIView *)controlView {
    if (!_controlView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.masksToBounds = YES;
        _controlView = contentView;
        
        UISwitch *switchBtn = [[UISwitch alloc] init];
        switchBtn.onTintColor = [UIColor colorWithHexString:@"ff6c00"];
        [switchBtn addTarget:self action:@selector(switchBtnChanged:) forControlEvents:UIControlEventValueChanged];
        [contentView addSubview:switchBtn];
        [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(contentView).offset(-3);
            make.centerY.equalTo(contentView);
        }];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"公开";
        [contentView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(switchBtn.mas_leading).offset(-12);
            make.centerY.equalTo(switchBtn);
        }];
    }
    return _controlView;
}

- (UIView *)coverView {
    if (!_coverView) {
        UIView *contentView = [[UIView alloc] init];
        _coverView = contentView;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewClicked:)];
        [contentView addGestureRecognizer:tapGes];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"im_create_corver"];
        [contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"000000"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"添加房间封面";
        [contentView addSubview:label];
        
        UIImageView *corverIV = [[UIImageView alloc] init];
        [contentView addSubview:corverIV];
        corverIV.contentMode = UIViewContentModeScaleAspectFill;
        _corverIV = corverIV;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView).offset(-17);
            make.centerX.equalTo(contentView);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(22);
            make.centerX.equalTo(contentView);
        }];
        
        [corverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(contentView);
            make.height.equalTo(contentView);
            make.centerX.equalTo(contentView);
            make.centerY.equalTo(contentView);
        }];
    }
    
    return _coverView;
}
- (void)addLineToButton:(UIView *)view {
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = [UIColor redColor].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:5];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = view.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@1, @1];
    
    view.layer.cornerRadius = 5.f;
    view.layer.masksToBounds = YES;
    
    [view.layer addSublayer:border];
}

- (void)setMulColor:(UIView *)view colors:(NSArray <UIColor *>*)colors startPoint:(NSArray <NSNumber *>*)points {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;  // 设置显示的frame
    gradientLayer.colors = colors;  // 设置渐变颜色
    gradientLayer.locations = points;    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [view.layer insertSublayer:gradientLayer atIndex:0];
    
//    CALayer *layer = [CALayer layer];
//    CGRect frame = view.frame;
//    layer.frame = frame;
//    layer.shadowOffset = CGSizeMake(1, 2);
//    layer.shadowOpacity = 0.7;
//    layer.backgroundColor = [UIColor whiteColor].CGColor;
//    layer.shadowColor = [UIColor colorWithHexString:@"FF6702"].CGColor;
//    layer.cornerRadius = 24;
//    [self.layer insertSublayer:layer atIndex:0];
}

#pragma mark - Event

- (void)buttonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(sessionViewCreateBtnDidClicked:)]) {
        [_delegate sessionViewCreateBtnDidClicked:_textField.text];
    }
}

static const int kNickNameLimitLength = 10;
- (void)textFieldTextDidChanged:(NSNotification *)notif {
    UITextField *textField = (UITextField *)notif.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > kNickNameLimitLength)
            {
                textField.text = [toBeString substringToIndex:kNickNameLimitLength];
                [UIView ilg_makeToast:@"超过字数上限"];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > kNickNameLimitLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kNickNameLimitLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:kNickNameLimitLength];
                [UIView ilg_makeToast:@"超过字数上限"];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kNickNameLimitLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
                [UIView ilg_makeToast:@"超过字数上限"];
            }
        }
    }
}

- (void)coverViewClicked:(UIGestureRecognizer *)ges {
    [[ILGImagePicker sharedInstance] selectImageInViewController:nil delegate:self];
}

- (void)switchBtnChanged:(UISwitch *)switchBtn {
    self.isPublic = switchBtn.isOn;
}

#pragma mark - Delegate

- (void)imagePicker:(ILGImagePicker *)imagePicker didFinishedWithEditedImage:(UIImage *)image {
    _corverIV.image = image;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sessionViewCoverDidSelected:)]) {
        [_delegate sessionViewCoverDidSelected:image];
    }
}

@end
