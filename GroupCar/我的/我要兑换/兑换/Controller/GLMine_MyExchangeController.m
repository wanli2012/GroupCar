//
//  GLMine_MyExchangeController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyExchangeController.h"
#import "GLMine_Exchange_MoneyController.h"
#import "GLMine_Exchange_jifenController.h"
#import "GLMine_ExchangeRecordController.h"

@interface GLMine_MyExchangeController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *jifenBtn;

@property (nonatomic, strong)UIView *signView;

@property (nonatomic, strong)GLMine_Exchange_MoneyController *moneyVC;
@property (nonatomic, strong)GLMine_Exchange_jifenController *jifenVC;

@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIButton *currentButton;

@end

@implementation GLMine_MyExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];//设置导航栏
    
    [self.topView addSubview:self.signView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _moneyVC = [[GLMine_Exchange_MoneyController alloc]init];
    _jifenVC = [[GLMine_Exchange_jifenController alloc]init];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kSCREEN_WIDTH, kSCREEN_HEIGHT-114)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_moneyVC];
    [self addChildViewController:_jifenVC];

    self.currentViewController = _moneyVC;
    [self fitFrameForChildViewController:_moneyVC];
    [self.contentView addSubview:_moneyVC.view];
    [self swithKind:self.moneyBtn];

}
//设置导航栏
- (void)setNav{
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [right setTitle:@"明细" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [right.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [right addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    [right setTitleEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    right.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}
- (void)detail{

    self.hidesBottomBarWhenPushed = YES;
    GLMine_ExchangeRecordController *detailRecord = [[GLMine_ExchangeRecordController alloc] init];
    detailRecord.navigationItem.title = @"兑换记录";
    [self.navigationController pushViewController:detailRecord animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)swithKind:(UIButton *)sender {
    [self.moneyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.jifenBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:kMain_Color forState:UIControlStateNormal];
    
    if (sender == self.moneyBtn) {
        
        [self transitionFromVC:self.currentViewController toviewController:_moneyVC];
        [self fitFrameForChildViewController:_moneyVC];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.signView.frame = CGRectMake(0, 48, kSCREEN_WIDTH/2, 2);
        }];
    }else if (sender == self.jifenBtn){
        
        [self transitionFromVC:self.currentViewController toviewController:_jifenVC];
        [self fitFrameForChildViewController:_jifenVC];
        [UIView animateWithDuration:0.2 animations:^{
            self.signView.frame = CGRectMake(kSCREEN_WIDTH / 2, 48, kSCREEN_WIDTH/2, 2);
        }];
    }
}
- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}
- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
}
- (UIView *)signView{
    if (!_signView) {
        _signView = [[UIView alloc] init];
        _signView.frame = CGRectMake(0, 50 - 2, kSCREEN_WIDTH / 2, 2);
        _signView.backgroundColor = kMain_Color;
    }
    return _signView;
}

@end

