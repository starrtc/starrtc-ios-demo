//
//  AboutUsVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/6/4.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于";
    NSString *vesion = [ILGLocalData preferencePlistObject:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"StarRTC v%@",vesion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
