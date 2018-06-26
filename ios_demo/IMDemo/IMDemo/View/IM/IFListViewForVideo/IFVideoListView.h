//
//  IFVideoListView.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseView.h"

#import "IFVideoListCell.h"

@protocol IFVideoListViewDelegate <NSObject>
- (NSInteger)videoCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (void)videoCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)videoCollectionView:(IFVideoListCell *)cell dataForIndexPath:(NSIndexPath *)indexPath;
- (void)createBtnDidClicked;
@end

@interface IFVideoListView : IFBaseView
@property (nonatomic, weak) id <IFVideoListViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *createBtnTitle;

- (void)reloadData;
@end
