//
//  IFVideoListView.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFVideoListView.h"

const static CGFloat kColloctionViewLineSpace = 6;

@interface IFVideoListView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UIButton *_createBtn;
    
    UIView *_view;
}
@end

@implementation IFVideoListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_createBtn setMulColor:@[(id)[UIColor colorWithHexString:@"FF6000"].CGColor, (id)[UIColor colorWithHexString:@"FFA414"].CGColor] startPoint:@[@(0.0), @(0.75)]];
}

#pragma mark - setter

- (void)setCreateBtnTitle:(NSString *)createBtnTitle {
    [_createBtn setTitle:createBtnTitle forState:UIControlStateNormal];
}

#pragma mark - UI

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kColloctionViewLineSpace;
    layout.minimumInteritemSpacing = kColloctionViewLineSpace;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[IFVideoListCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.backgroundColor = [UIColor clearColor];
    _collectionView = collectionView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"创建" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 22;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchDragOutside];

    _createBtn = button;
    
    [self addSubview:collectionView];
    [self addSubview:button];
    
    __weak typeof(self) weakSelf = self;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.leading.equalTo(weakSelf);
        make.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(114, 44));
        make.bottom.equalTo(weakSelf).offset(-22);
    }];
}


#pragma mark - Delegate
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - kColloctionViewLineSpace * 3) / 2.0;
    CGFloat height = width/178*206;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(kColloctionViewLineSpace, kColloctionViewLineSpace, kColloctionViewLineSpace, kColloctionViewLineSpace);
    return edgeInsets;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoCollectionView:numberOfItemsInSection:)]) {
        number = [_delegate videoCollectionView:collectionView numberOfItemsInSection:section];
    }
    
    return number;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IFVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoCollectionView:dataForIndexPath:)]) {
        [_delegate videoCollectionView:cell dataForIndexPath:indexPath];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(videoCollectionView:didSelectItemAtIndexPath:)]) {
        [_delegate videoCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}


#pragma mark - Event

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)buttonClick:(UIButton *)button {
    [_view removeFromSuperview];

    if (_delegate && [_delegate respondsToSelector:@selector(createBtnDidClicked)]) {
        [_delegate createBtnDidClicked];
    }
}

- (void)touchDown:(UIButton *)button {
    UIView *view = [[UIView alloc] initWithFrame:button.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    [button addSubview:view];
    _view = view;
}

- (void)touchCancel:(UIButton *)button {
    [_view removeFromSuperview];
}
@end
