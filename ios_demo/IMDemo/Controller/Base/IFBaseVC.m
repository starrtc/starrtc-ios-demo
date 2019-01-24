//
//  IFBaseVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/3/29.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

@interface IFBaseVC ()
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation IFBaseVC

+ (instancetype)instanceFromNib{
    IFBaseVC *vc = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    return vc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self setupDefaultUI];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setupDefaultUI {
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setLeftButtonImage:@"btn_back" edgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [self setNavigationBarColor:[UIColor colorWithHexString:@"ff6c00"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView *bgIM = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [self.view insertSubview:bgIM atIndex:0];
//    bgIM.image = [UIImage imageNamed:@"app_bg"];
}

- (CGFloat)areaHeight {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    CGFloat navBarHeight = 0;
    if (self.navigationController) {
        navBarHeight = 44;
    }
    return statusHeight + navBarHeight;
}

#pragma mark - event

- (void)leftButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClicked:(UIButton *)button {
    
}

#pragma mark - other

- (void)setNavigationBarColor:(UIColor *)color
{
    if([color isEqual:[UIColor clearColor]]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } else if(color){
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        self.navigationController.navigationBar.barTintColor = color;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}
- (void) hiddenLeftButton
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setLeftButtonImage:(NSString * )image edgeInsets:(UIEdgeInsets)edgeInsets
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
//    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.imageEdgeInsets = edgeInsets;
    [button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

//设置右按钮
- (void) setRightButtonText:(NSString * ) text
{
    [self setRightButtonText:text textColor:nil];
}

- (void)setRightButtonText:(NSString * )text textColor:(UIColor *)color {
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 44, 44);
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightBtn setTitle:text forState:UIControlStateNormal];
    if (color) {
        [_rightBtn setTitleColor:color forState:UIControlStateNormal];
    }
    [_rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)setRightButtonImage:(NSString * )image
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 44, 44);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, -12);
    [button addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
- (void) hiddenRightButton
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)dealloc {
    
    NSLog(@"%@控制器已经被释放",NSStringFromClass([self class]));
}

@end
