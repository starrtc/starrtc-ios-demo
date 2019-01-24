//
//  VideoTestSpeedVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VideoTestSpeedVC.h"
#import "EchoTest.h"

@interface VideoTestSpeedVC ()<UITableViewDelegate,UITableViewDataSource,EchoTestDelegate>
{
    NSMutableArray *_tableViewDataSource;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  EchoTest *echoTest;
@end

@implementation VideoTestSpeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络测速";
    _tableViewDataSource = [NSMutableArray arrayWithCapacity:1];
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.tableFooterView = [UIView new];
   
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //开始测速
    [self.echoTest initEchoTest];
    
}

- (EchoTest*)echoTest{
    if (!_echoTest) {
        _echoTest = [[EchoTest alloc] init];
        [_echoTest addDelegate:self];
    }
    return _echoTest;
}
#pragma mark UITableViewDelegate



#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewDataSource count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row < [_tableViewDataSource count]) {
        cell.textLabel.text = _tableViewDataSource[indexPath.row];
    }
    return cell;
}

// 代理函数
-(void)echoTestCallback:(int)index
                    len:(int)len
               timeCost:(int)timeCost
{
    
    NSString *inertString  = [[NSString alloc] initWithString:[NSString stringWithFormat:@"index:%d len:%d timecost:%d",index,len,timeCost]];
    [_tableViewDataSource addObject:inertString];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_tableViewDataSource count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}
@end
