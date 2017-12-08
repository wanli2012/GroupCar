//
//  GLMine_Set_ModifyPasswordController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_ModifyPasswordController.h"

@interface GLMine_Set_ModifyPasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *password_newView;
@property (weak, nonatomic) IBOutlet UIView *ensureView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *password_newTF;
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_Set_ModifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.passwordView.layer.cornerRadius = 5.f;
    self.passwordView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.passwordView.layer.borderWidth = 1.f;
    
    self.password_newView.layer.cornerRadius = 5.f;
    self.password_newView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.password_newView.layer.borderWidth = 1.f;
    
    self.ensureView.layer.cornerRadius = 5.f;
    self.ensureView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.ensureView.layer.borderWidth = 1.f;
    
    self.submitBtn.layer.cornerRadius = 5.f;
    
}

- (IBAction)submit:(id)sender {
 
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"密码应该在6 ~ 16位"];
        return;
    }
    if (self.password_newTF.text.length < 6 || self.password_newTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    if (self.ensureTF.text.length < 6 || self.ensureTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    if (![self.password_newTF.text isEqualToString:self.ensureTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"1";
    dict[@"oldpassword"] = self.passwordTF.text;
    dict[@"password"] = self.password_newTF.text;
    dict[@"confirmpwd"] = self.ensureTF.text;

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passwordTF) {
        [self.password_newTF becomeFirstResponder];
    }else if(textField == self.password_newTF){
        [self.ensureTF becomeFirstResponder];
    }else if(textField == self.ensureTF){
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
        
    }else if(textField == self.ensureTF){
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
        }
        
    }else if(textField == self.password_newTF){
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"密码最多16位"];
            return NO;
        }
    }
    return YES;
}


@end
