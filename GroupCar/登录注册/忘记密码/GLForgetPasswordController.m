//
//  GLForgetPasswordController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLForgetPasswordController.h"

@interface GLForgetPasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *ensureView;

@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;//提交
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码按钮


@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.sumbitBtn.layer.cornerRadius = 5.f;
    
    self.phoneView.layer.cornerRadius = 5.f;
    self.passwordView.layer.cornerRadius = 5.f;
    self.ensureView.layer.cornerRadius = 5.f;
    self.codeView.layer.cornerRadius = 5.f;
    
    self.phoneView.layer.borderWidth = 1.f;
    self.passwordView.layer.borderWidth = 1.f;
    self.ensureView.layer.borderWidth = 1.f;
    self.codeView.layer.borderWidth = 1.f;
    
    self.phoneView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.passwordView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.ensureView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    if (self.phoneTF.text.length != 11 || ![predicateModel valiMobile:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号输入不正确"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    
    if (self.ensureTF.text.length < 6 || self.ensureTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    
    if (self.codeTF.text.length != 4 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入4位的验证码"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";
    dict[@"password"] = self.passwordTF.text;
    dict[@"phone"] = self.phoneTF.text;
    dict[@"confirmpwd"] = self.ensureTF.text;
    dict[@"verification"] = self.codeTF.text;
    
    [NetworkManager requestPOSTWithURLStr:KChangePassword_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:@"找回密码成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 获取验证码
- (IBAction)getCode:(id)sender {
    
    if (self.phoneTF.text.length != 11 || ![predicateModel valiMobile:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号输入不正确"];
        return;
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:KGet_Code_Interface paramDic:@{@"phone":self.phoneTF.text} finish:^(id responseObject) {
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入字符种类
    if (range.length == 1 && string.length == 0) {
        
        return YES;
        
    }else if(textField == self.phoneTF || textField == self.codeTF){
        if (![predicateModel inputShouldNumber:string]) {
            [SVProgressHUD showErrorWithStatus:@"手机号只能输入数字"];
            return NO;
        }
    }else{
        if (![predicateModel inputShouldLetterOrNum:string]) {
            [SVProgressHUD showErrorWithStatus:@"只能输入字母或数字"];
            return NO;
        }
    }
    //限制长度
     if(textField == self.phoneTF){
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
            [SVProgressHUD showErrorWithStatus:@"手机号只能11位"];
            
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
        
    }else if(textField == self.codeTF){
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
            [SVProgressHUD showErrorWithStatus:@"验证码最多6位"];
            return NO;
        }
        
    }
    return YES;
}
@end
