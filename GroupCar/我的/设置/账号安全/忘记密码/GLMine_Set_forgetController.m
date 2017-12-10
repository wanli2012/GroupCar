//
//  GLMine_Set_modifyPwdController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_forgetController.h"
#import "RSAEncryptor.h"

@interface GLMine_Set_forgetController ()

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *ensurePasswordTF;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;//提示Label

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_Set_forgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    self.noticeLabel.text = [NSString stringWithFormat:@"验证码将发送至%@",[UserModel defaultUser].phone];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)getCode:(id)sender {

    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:KGet_Code_Interface paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
       [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"  重发验证码  " forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"  %.2d秒后重新发送  ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (IBAction)submit:(id)sender {
    if (self.type == 2) {
        if (self.pwdTF.text.length != 6) {
            [SVProgressHUD showErrorWithStatus:@"请设置6位纯数字二级密码"];
            return;
        }

    }else{
        if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 16) {
            [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
            return;
        }
        
        if (self.ensurePasswordTF.text.length < 6 || self.ensurePasswordTF.text.length > 16) {
            [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
            return;
        }
    }
    
    if (self.codeTF.text.length < 4 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入4位的验证码"];
        return;
    }
    if (![self.pwdTF.text isEqualToString:self.ensurePasswordTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (self.type == 2) {//修改二级密码
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].user_id;
        dict[@"paypassword"] = self.pwdTF.text;
        dict[@"phone"] = [UserModel defaultUser].phone;
        dict[@"confirmpwd"] = self.ensurePasswordTF.text;
        dict[@"verification"] = self.codeTF.text;
        
        [NetworkManager requestPOSTWithURLStr:KSetSecond_Password_Interface paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else{//忘记密码
        
        dict[@"type"] = @"2";
        dict[@"password"] = self.pwdTF.text;
        dict[@"phone"] = [UserModel defaultUser].phone;
        dict[@"confirmpwd"] = self.ensurePasswordTF.text;
        dict[@"verification"] = self.codeTF.text;
        
        [NetworkManager requestPOSTWithURLStr:KChangePassword_Interface paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
    
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.codeTF) {
        [self.pwdTF becomeFirstResponder];
    }else if(textField == self.pwdTF){
        [self.ensurePasswordTF becomeFirstResponder];
    }else if(textField == self.ensurePasswordTF){
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
    if (self.type == 2) {
        if(textField == self.pwdTF){
            if (textField.text.length >= 6) {
                textField.text = [textField.text substringToIndex:6];
                [SVProgressHUD showErrorWithStatus:@"二级密码只能为6位顺数字"];
                return NO;
            }
            
        }else if(textField == self.ensurePasswordTF){
            if (textField.text.length >= 6) {
                textField.text = [textField.text substringToIndex:6];
            }
        }
        
    }else{
        if(textField == self.pwdTF){
            if (textField.text.length >= 16) {
                textField.text = [textField.text substringToIndex:16];
                [SVProgressHUD showErrorWithStatus:@"密码最多16位"];
                return NO;
            }
        }else if(textField == self.ensurePasswordTF){
            if (textField.text.length >= 16) {
                textField.text = [textField.text substringToIndex:16];
            }
            
        }else if(textField == self.codeTF){
            if (textField.text.length > 4) {
                textField.text = [textField.text substringToIndex:4];
                [SVProgressHUD showErrorWithStatus:@"验证码为4位"];
                return NO;
            }
        }
    }
    return YES;
}

@end
