//
//  SuperRoomMenuView.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class SuperRoomMenuView;
@protocol SuperRoomMenuViewDelegate <NSObject>

- (void)SuperRoomMenuView:(SuperRoomMenuView*)chatMenuView sendText:(NSString*)text toId:(NSString *)toId;
- (void)SuperRoomMenuViewStartSpeech:(SuperRoomMenuView*)chatMenuView;
- (void)SuperRoomMenuViewStopSpeech:(SuperRoomMenuView*)chatMenuView;

@end

/**
 使用分类instanceFromNib方法进行初始化
 */
@interface SuperRoomMenuView : UIView

@property (nonatomic, weak) id<SuperRoomMenuViewDelegate> delegate;

@property (nonatomic, strong)NSString *mPrivateMsgTargetId;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

NS_ASSUME_NONNULL_END
