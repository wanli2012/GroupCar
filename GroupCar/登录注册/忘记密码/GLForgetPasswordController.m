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
    
}

#pragma mark - 获取验证码
- (IBAction)getCode:(id)sender {
    
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
