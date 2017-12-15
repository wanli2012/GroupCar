//
//  GLMine_DelegateController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_DelegateController.h"
#import "GLWebViewController.h"

@interface GLMine_DelegateController ()
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentviewWidth;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, copy)NSString *delegeteContent;
@property (nonatomic, copy)NSString *u_group;

@end

@implementation GLMine_DelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentviewWidth.constant = kSCREEN_WIDTH - 30;

    self.bgView.layer.shadowColor = kMain_Color.CGColor;
    self.bgView.layer.shadowOpacity = 0.6f;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self postRequest];
    
}

#pragma mark - 设置协议内容
- (void)setContent{
    
    if ([self.u_group integerValue] == 2) {//1代表用户还是会员 2是个人代理
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submitBtn.enabled = NO;
        [self.submitBtn setTitle:@"已成为代理商" forState:UIControlStateNormal];
        self.agreeLabel.text = @"我已同意";
        [self.signImageV setImage:[UIImage imageNamed:@"choice"]];
    }else{
        self.submitBtn.backgroundColor = kMain_Color;
        self.submitBtn.enabled = YES;
        [self.submitBtn setTitle:@"立刻成为代理商" forState:UIControlStateNormal];
        self.agreeLabel.text = @"我同意";
        [self.signImageV setImage:[UIImage imageNamed:@"nochoice"]];
    }
    
    self.contentLabel.text = self.delegeteContent;
    
    CGRect rect = [self.contentLabel.text  boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
    
    if (rect.size.height + 75 > kSCREEN_HEIGHT - 280) {
        self.bgViewHeight.constant = kSCREEN_HEIGHT - 280;
    }else{
        self.bgViewHeight.constant = rect.size.height + 75;
    }
}

#pragma mark - 请求数据
- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"1";//1获取代理协议 2验证代理协议
   
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_Delegate_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.delegeteContent = responseObject[@"data"][@"agreement"];
            self.u_group = responseObject[@"data"][@"u_group"];
            
            [self setContent];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 是否同意协议
- (IBAction)isAgreeProtocol:(id)sender {
    
    if ([[UserModel defaultUser].status integerValue] == 2) {//1代表用户还是会员 2是个人代理
        return;
    }
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"choice"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"nochoice"];
    }
}
#pragma mark - 代理商准则
- (IBAction)protocolContent:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_AgencyURL];
    
    webVC.url = [NSString stringWithFormat:@"%@",baseUrl];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 成为代理商
- (IBAction)beDelegate:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_BE_DelegateURL];
    
    webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id];
    
    [self.navigationController pushViewController:webVC animated:YES];

}

@end
