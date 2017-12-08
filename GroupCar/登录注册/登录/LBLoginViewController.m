//
//  LBLoginViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBLoginViewController.h"
#import "LBRegisterViewController.h"
#import "GLForgetPasswordController.h"
#import "BasetabbarViewController.h"
#import <WXApi.h>
#import "GLRegister_InfoCompletionController.h"

@interface LBLoginViewController ()<WXApiDelegate>
{
    BOOL _isWeixinLogin;
}

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnTop;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, copy)NSString *appid;

@end

@implementation LBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.accountView.layer.cornerRadius = 5.f;
    self.passwordView.layer.cornerRadius = 5.f;
    self.accountView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.passwordView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.accountView.layer.borderWidth = 1.f;
    self.passwordView.layer.borderWidth = 1.f;

    self.loginBtnTop.constant = 60 * autoSizeScaleY;
    
    self.loginBtn.layer.cornerRadius = 5.f;
    _isWeixinLogin = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinLoginWith:) name:@"weixinLoginNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_isWeixinLogin) {
        dict[@"loginmode"] = @"2";
        dict[@"appid"] = self.appid;
    }else{
        [self.view endEditing:YES];
        if (self.accountTF.text.length <=0 ) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
            return;
        }
        if (self.passwordTF.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
            return;
        }
        if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 12) {
            [SVProgressHUD showErrorWithStatus:@"请输入6-12位密码"];
            return;
        }
        dict[@"loginmode"] = @"1";
        dict[@"userphone"] = self.accountTF.text;
        dict[@"password"] = self.passwordTF.text;
    }
    //    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KLogin_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == LOGIN_SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            
            [UserModel defaultUser].group = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"group"]];
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].money = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"money"]];
            [UserModel defaultUser].nickname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].portrait = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"portrait"]];
            [UserModel defaultUser].status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].uname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uname"]];
            [UserModel defaultUser].user_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_id"]];

            [UserModel defaultUser].loginstatus = YES;

            [usermodelachivar achive];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}
- (IBAction)registe:(id)sender {
    
    LBRegisterViewController *registVC = [[LBRegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (IBAction)weixinLogin:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"groupCar" ;
        [WXApi sendReq:req];
    }
}

#pragma mark - 微信登录
- (void)weixinLoginWith:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
//    NSLog(@"dic = %@",dic);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"loginmode"] = @"2";
    dict[@"appid"] = dic[@"openid"];

     _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KLogin_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == NO_ACCOUNT_CODE) {//微信登录,没账号关联返回
            GLRegister_InfoCompletionController *infoVC = [[GLRegister_InfoCompletionController alloc] init];
            infoVC.navigationItem.title = @"信息补全";
            infoVC.appid = dic[@"openid"];
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }else if([responseObject[@"code"] integerValue] == LOGIN_SUCCESS_CODE){

            _isWeixinLogin = YES;
            self.appid = dic[@"openid"];
            [self login:@""];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 忘记密码
- (IBAction)forgetPassword:(id)sender {
    
    GLForgetPasswordController *forgetVC = [[GLForgetPasswordController alloc] init];
    forgetVC.navigationItem.title = @"找回密码";
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}


@end
