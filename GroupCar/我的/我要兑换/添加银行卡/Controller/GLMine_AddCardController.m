//
//  GLMine_AddCardController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AddCardController.h"
//单选picker 和动画
#import "GLSimpleSelectionPickerController.h"
#import "editorMaskPresentationController.h"

@interface GLMine_AddCardController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
     BOOL _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UIView *ownerView;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *ownerTF;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, copy)NSString *bank_id;//银行名id
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_AddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 5.f;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 400;
    
    self.ownerView.layer.cornerRadius = 5.f;
    self.ownerView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.ownerView.layer.borderWidth = 1.f;
    
    self.bankView.layer.cornerRadius = 5.f;
    self.bankView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.bankView.layer.borderWidth = 1.f;
    
    self.numberView.layer.cornerRadius = 5.f;
    self.numberView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.numberView.layer.borderWidth = 1.f;
    
    self.addressView.layer.cornerRadius = 5.f;
    self.addressView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.addressView.layer.borderWidth = 1.f;

}
#pragma mark - 添加银行卡
- (IBAction)submit:(id)sender {
    if(self){
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";
    dict[@"bank"] = self.bank_id;
    dict[@"cardnumber"] = self.numberTF.text;
    dict[@"address"] = self.addressTF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_BankCard_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
           
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 银行选择
- (IBAction)bankChoose:(id)sender {
    [self.view endEditing:YES];
//    if (self.careerArr.count != 0) {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"中国银行",@"中国建设银行",@"中国工商银行"]];
        [self popChooser:arr Title:@"请选择银行"];
//        return;
//    }
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
//    [NetworkManager requestPOSTWithURLStr:kCV_CAREER_LIST_URL paramDic:@{} finish:^(id responseObject) {
//        [_loadV removeloadview];
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
//            if([responseObject[@"data"] count] != 0){
//
//                [self.careerModels removeAllObjects];
//                for (NSDictionary *dic in responseObject[@"data"]) {
//                    GLMine_CV_CareerModel *model = [GLMine_CV_CareerModel mj_objectWithKeyValues:dic];
//                    [self.careerModels addObject:model];
//                }
//                [self.careerArr removeAllObjects];
//                for (GLMine_CV_CareerModel *model in self.careerModels) {
//                    [self.careerArr addObject:model.name];
//                }
//                [self popChooser:self.careerArr Title:@"请选择职业" andIsCareer:YES];
//            }
//        }else{
//
//            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//        }
//
//    } enError:^(NSError *error) {
//        [_loadV removeloadview];
//    }];
}
#pragma mark - 弹出单项选择器
- (void)popChooser:(NSMutableArray *)dataArr Title:(NSString *)title{
    
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    vc.dataSourceArr = dataArr;
    vc.titlestr = title;
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){

        weakSelf.bankLabel.text = dataArr[index];
    };

    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 动画的代理
//动画
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}
//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    
    [self chooseindustry:transitionContext];
    
    
}
-(void)chooseindustry:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
        }];
    }
}



@end
