//
//  GLRegister_Info_NoPhoneController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLRegister_Info_NoPhoneController.h"
#import "GLWebViewController.h"

@interface GLRegister_Info_NoPhoneController ()
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *ensureView;
@property (weak, nonatomic) IBOutlet UIView *recommendView;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;
@property (weak, nonatomic) IBOutlet UITextField *recommendTF;
@property (weak, nonatomic) IBOutlet UIButton *submintBtn;

@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLRegister_Info_NoPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.passwordView.layer.borderWidth = 1.f;
    
    self.ensureView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.ensureView.layer.borderWidth = 1.f;
    
    self.recommendView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.recommendView.layer.borderWidth = 1.f;
    
}

//注册协议
- (IBAction)registerProtocol:(id)sender {
   
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    
    webVC.url = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_Recharge_DelegateURL];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

//是否勾选协议
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"choice"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"nochoice"];
    }
}

- (IBAction)submit:(id)sender {
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.ensureTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if(_isAgreeProtocol){
        dict[@"agreement"] = @"1";//1注册账号 2完善注册账号传 协议是否勾选 传1
    }else{
        dict[@"agreement"] = nil;
    }
    
    dict[@"type"] = @"2";//1注册账号 2完善注册账号 3已有账号绑定
    dict[@"userphone"] = self.phone;
    dict[@"password"] = self.passwordTF.text;
    dict[@"confirmpwd"] = self.ensureTF.text;
    dict[@"appid"] = self.appid;
    dict[@"Referee"] = self.recommendTF.text;
    dict[@"port"] = @"1";//那个端口注册 1ios 2安卓 3web 默认1
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KRegister paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:@"完善成功"];
            
            [self login];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

- (void)login{
    [self.view endEditing:YES];

    //    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"loginmode"] = @"2";
    dict[@"appid"] = self.appid;
    
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passwordTF) {
        [self.ensureTF becomeFirstResponder];
    }else if(textField == self.ensureTF){
        [self.recommendTF becomeFirstResponder];
    }else if(textField == self.recommendTF){
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入字符种类
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    
    }else{
        if (![predicateModel inputShouldLetterOrNum:string]) {
            [SVProgressHUD showErrorWithStatus:@"只能输入字母或数字"];
            return NO;
        }
    }
    //限制长度
    if(textField == self.recommendTF){
        
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"推荐人ID最多16位"];
            
            return NO;
        }
        
    }else if(textField == self.passwordTF){
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"密码最多16位"];
            return NO;
        }
        
    }else if(textField == self.ensureTF){
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
        }

    }
    return YES;
}
@end
