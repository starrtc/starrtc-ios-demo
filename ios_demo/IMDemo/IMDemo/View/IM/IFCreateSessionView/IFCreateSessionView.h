//
//  IFCreateSessionView.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseView.h"

@protocol IFCreateSessionViewDelegate <NSObject>
- (void)sessionViewCreateBtnDidClicked:(NSString *)name;
@optional
- (void)sessionViewCoverDidSelected:(UIImage *)image;
@end

@interface IFCreateSessionView : IFBaseView
@property (nonatomic, weak) id <IFCreateSessionViewDelegate> delegate;

@property (nonatomic, assign) BOOL isHasCover; //是否可以设置封面, 默认可以设置
@property (nonatomic, assign) BOOL isHasControl;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *funcBtnTitle;
@property (nonatomic, copy) NSString *textFieldPlaceholder;

@end
