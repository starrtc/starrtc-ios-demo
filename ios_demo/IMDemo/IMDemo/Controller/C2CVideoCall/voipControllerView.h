//
//  voipView.h
//  sdk_UI_work
//
//  Created by  Admin on 2017/9/21.
//  Copyright © 2017年 ndp_001_Tommy. All rights reserved.
//

#ifndef voipView_h
#define voipView_h

#import <UIKit/UIKit.h>
#import "StarManagerModel.h"

typedef NS_ENUM(NSInteger, VoIP_Type) {
    VoIP_Type_Calling = 0, // 主叫方
    VoIP_Type_To_Be_Called // 被叫方
};

@interface voipControllerView : UIViewController<StarManagerModelVoipdelegate>

- (id)initWithName:(int)voipType;


@property  int       m_voipType;
@property NSString  *m_targetID;
@property NSString  *m_userID;
@property (weak, nonatomic) IBOutlet UIButton *pickup_button;
@property (weak, nonatomic) IBOutlet UIButton *hanoff_button;
@property (weak, nonatomic) IBOutlet UIButton *called_hangoff_button;

@property (weak, nonatomic) IBOutlet UIView *self_view;
@property (weak, nonatomic) IBOutlet UIView *target_view;


@end
#endif /* voipView_h */
	
