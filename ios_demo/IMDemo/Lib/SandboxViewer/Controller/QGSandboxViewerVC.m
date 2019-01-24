//
//  QGSandboxViewerVC.m
//  QGSandboxViewer
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGSandboxViewerVC.h"
#import "QGSendboxViewerCell.h"

@interface QGSandboxViewerVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_sandboxPath;    //当前所在目录
    NSIndexPath *_handlingIndexPath;  //正在操作的文件索引
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) UIAlertController * alertController;

@end

@implementation QGSandboxViewerVC
- (instancetype)initWithHomeDirectory{
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        _sandboxPath = NSHomeDirectory();
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithDirectory:(NSString*)directory{
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        _sandboxPath = directory;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupDataSource];
    [self setupUI];
    [self.tableView reloadData];
    NSLog(@"当前路径：%@",_sandboxPath);
}

- (void)setupUI{
    
    self.navigationItem.title = [_sandboxPath lastPathComponent];
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerNib:[QGSendboxViewerCell instanceForNib] forCellReuseIdentifier:@"QGSendboxViewerCell"];
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
}

- (void)setupDataSource{
    self.tableViewDataSource = [NSMutableArray arrayWithCapacity:1];
    
    if(!_sandboxPath){
        _sandboxPath = NSHomeDirectory();
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray<NSString *> *contents = [fileManager contentsOfDirectoryAtPath:_sandboxPath error:&error];
    if (error == nil) {
        
        [self.tableViewDataSource removeAllObjects];
        
        __weak typeof(_sandboxPath) weakSandboxPath = _sandboxPath;
        [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            QGSendboxViewerModel *model = [[QGSendboxViewerModel alloc] initWithFileName:[NSString stringWithFormat:@"%@",obj] filePath:weakSandboxPath];
            [self.tableViewDataSource addObject:model];
        }];
        
    }
}

- (UIAlertController*)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:@"文件操作" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
//        UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [self lookFile];
//
//        }];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self sendFile];
           
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteFile];
            
        }];
        [_alertController addAction:alertAction];
//        [_alertController addAction:alertAction0];
        [_alertController addAction:alertAction1];
        [_alertController addAction:alertAction2];
    }
    return _alertController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGSendboxViewerCell * cell ;
    cell = (QGSendboxViewerCell*)[tableView dequeueReusableCellWithIdentifier:@"QGSendboxViewerCell"];
    if (self.tableViewDataSource.count > indexPath.row) {
        [cell setupCellData:self.tableViewDataSource[indexPath.row] indexPath:indexPath];
    } else {
        [cell setupCellData:nil indexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.tableViewDataSource.count) {
    
        QGSendboxViewerModel *model = self.tableViewDataSource[indexPath.row];
        if ([model.fileType isEqualToString:@"NSFileTypeDirectory"]) {
            QGSandboxViewerVC *vc = [[QGSandboxViewerVC alloc] initWithDirectory:[model.filePath stringByAppendingFormat:@"/%@",model.fileName]];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"这是一个文件夹");
        } else {
            [self presentViewController:self.alertController animated:YES completion:nil];
            _handlingIndexPath = indexPath;
            NSLog(@"这是一个文件");
        }
    }
}

- (void)sendFile{
    
    QGSendboxViewerModel *model = self.tableViewDataSource[_handlingIndexPath.row];
    //分享的url
    NSURL *urlToShare = [NSURL fileURLWithPath:[model.filePath stringByAppendingFormat:@"/%@",model.fileName]];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

- (void)deleteFile{
    QGSendboxViewerModel *model = self.tableViewDataSource[_handlingIndexPath.row];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[model.filePath stringByAppendingFormat:@"/%@",model.fileName] error:&error];
    if (!error) {
        [self.tableViewDataSource removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[_handlingIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        NSLog(@"error = %@",error);
    }
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
