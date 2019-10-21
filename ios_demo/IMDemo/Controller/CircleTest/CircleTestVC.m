//
//  CircleTestVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/4.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "CircleTestVC.h"
#import "LoopTest.h"
#import "XHClient.h"

@interface CircleTestVC ()
{
    LoopTest *_loopTest;
}
@property (weak, nonatomic) IBOutlet UIView *smallVideoPreview1;
@property (weak, nonatomic) IBOutlet UIView *bigVideoPreview1;
@property (weak, nonatomic) IBOutlet UIView *bigVideoPreview2;
@property (weak, nonatomic) IBOutlet UIView *smallVideoPreview2;

@end

@implementation CircleTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XHClient sharedClient].beautyManager addDelegate:self];
    _loopTest = [[LoopTest alloc] init];
    [_loopTest setupView:self.bigVideoPreview1 self_small_view:self.smallVideoPreview1 target_big_view:self.bigVideoPreview2 target_small_view:self.smallVideoPreview2];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarColor:[UIColor clearColor]];
    [_loopTest startLoopTest];
}

/**

 @param animated
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setNavigationBarColor:nil];
    [_loopTest stopLoopTest];
}
#pragma mark 点击事件

//父类方法
- (void)leftButtonClicked:(UIButton *)button
{

   
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - XHBeautyManagerDelegate

/**
 暴露每帧视频数据(同步返回处理后的数据)
 @param videoData 数据
 */
-(StarVideoData *) onVideoFrame:(StarVideoData *) videoData
{
    return videoData;
}

/**
 暴露每帧音频数据(同步返回处理后的数据)
 @param audioData 数据
 */
-(StarAudioData *) onAudioFrame:(StarAudioData *) audioData
{
    return audioData;
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
