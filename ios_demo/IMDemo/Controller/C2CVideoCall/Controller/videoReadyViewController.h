//
//  videoReadyView.h
//  sdk_UI_work
//
//  Created by  Admin on 2017/9/21.
//  Copyright © 2017年 ndp_001_Tommy. All rights reserved.
//

#ifndef videoReadyView_h
#define videoReadyView_h


#import <UIKit/UIKit.h>


@protocol videoReadyViewControllerdelegate <NSObject>





@end



@interface videoReadyViewController : UIViewController

@property NSString *m_user_ID;

@property (nonatomic, weak) id<videoReadyViewControllerdelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *my_user_ID;

@property (weak, nonatomic) IBOutlet UITextField *target_user_ID;

@property (weak, nonatomic) IBOutlet UIButton *send_calling_button;

@end



#endif /* videoReadyView_h */
