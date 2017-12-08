//
//  GLRegister_Info_HavePhoneController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLRegister_Info_HavePhoneController.h"

@interface GLRegister_Info_HavePhoneController ()


@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLRegister_Info_HavePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.passwordView.layer.borderWidth = 1.f;
    
}

- (IBAction)submit:(id)sender {
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"type"] = @"3";//1注册账号 2完善注册账号 3已有账号绑定
    dict[@"userphone"] = self.phone;
    dict[@"password"] = self.passwordTF.text;
    dict[@"appid"] = self.appid;//微信appid,2完善注册账号 3账号绑定时传
    dict[@"port"] = @"1";//那个端口注册 1ios 2安卓 3web 默认1
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KRegister paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            
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

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    //    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"loginmode"] = @"2";
    dict[@"appid"] = self.appid;
   
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
    if(textField == self.passwordTF){
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"密码最多16位"];
            return NO;
        }
    }
    return YES;
}

@end
