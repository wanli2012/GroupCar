//
//  GLMine_ExchangeRecordController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ExchangeRecordController.h"
#import "GLMine_DetailRecordController.h"

@interface GLMine_ExchangeRecordController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (nonatomic, strong)UIView *signView;

@property (nonatomic, strong)GLMine_DetailRecordController *firstVC;
@property (nonatomic, strong)GLMine_DetailRecordController *secondVC;
@property (nonatomic, strong)GLMine_DetailRecordController *thirdVC;

@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIButton *currentButton;

@end

@implementation GLMine_ExchangeRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:self.signView];
    
    _firstVC = [[GLMine_DetailRecordController alloc]init];
    _firstVC.type = 1;
    _secondVC = [[GLMine_DetailRecordController alloc]init];
    _secondVC.type = 2;
    _thirdVC = [[GLMine_DetailRecordController alloc]init];
    _thirdVC.type = 3;
  
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, kSCREEN_WIDTH, kSCREEN_HEIGHT-114)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_firstVC];
    [self addChildViewController:_secondVC];
    [self addChildViewController:_thirdVC];

    self.currentViewController = _firstVC;
    [self fitFrameForChildViewController:_firstVC];
    [self.contentView addSubview:_firstVC.view];
    
    [self swithController:_firstBtn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)swithController:(UIButton *)sender {
    
    [self.firstBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:kMain_Color forState:UIControlStateNormal];
    
    if (sender == self.firstBtn) {
        
        [self transitionFromVC:self.currentViewController toviewController:_firstVC];
        [self fitFrameForChildViewController:_firstVC];
        [UIView animateWithDuration:0.2 animations:^{
            self.signView.frame = CGRectMake(0, 48, kSCREEN_WIDTH/3, 2);
        }];
        
    }else if (sender == self.secondBtn){
        
        [self transitionFromVC:self.currentViewController toviewController:_secondVC];
        [self fitFrameForChildViewController:_secondVC];
        [UIView animateWithDuration:0.2 animations:^{
            self.signView.frame = CGRectMake(kSCREEN_WIDTH / 3 * 2, 48, kSCREEN_WIDTH/3, 2);
        }];
    }else if (sender == self.thirdBtn){
        
        [self transitionFromVC:self.currentViewController toviewController:_thirdVC];
        [self fitFrameForChildViewController:_thirdVC];
        [UIView animateWithDuration:0.2 animations:^{
            self.signView.frame = CGRectMake(kSCREEN_WIDTH / 3, 48, kSCREEN_WIDTH/3, 2);
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

#pragma mark - 懒加载
- (UIView *)signView{
    if (!_signView) {
        _signView = [[UIView alloc] init];
        _signView.frame = CGRectMake(0, 50 - 2, kSCREEN_WIDTH / 2, 2);
        _signView.backgroundColor = kMain_Color;
    }
    return _signView;
}

@end
