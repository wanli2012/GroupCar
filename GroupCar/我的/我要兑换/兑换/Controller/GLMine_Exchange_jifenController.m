//
//  GLMine_Exchange_jifenController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Exchange_jifenController.h"
//#import "IQKeyboardManager.h"

@interface GLMine_Exchange_jifenController ()

@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;//我的积分
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;//账号
@property (weak, nonatomic) IBOutlet UITextField *exchangeJifenTF;//兑换积分
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//二级密码
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交
@property (weak, nonatomic) IBOutlet UILabel *platLabel;//平台名称

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_Exchange_jifenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 5.f;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.accountLabel.text = [UserModel defaultUser].dz_name;
    self.jifenLabel.text = [UserModel defaultUser].mark;
    
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    if ([self.exchangeJifenTF.text integerValue] <= 0.0) {
        [SVProgressHUD showErrorWithStatus:@"兑换积分数必须大于0"];
        return;
    }
    if ([self.exchangeJifenTF.text integerValue] % 100 != 0) {
        
        [SVProgressHUD showErrorWithStatus:@"兑换积分数必须是100的整数倍!"];
        return;
    }
    
    if ([self.exchangeJifenTF.text integerValue] > [self.jifenLabel.text integerValue]){
        [SVProgressHUD showErrorWithStatus:@"余额不足!"];
        return;
    }
    
    if (self.passwordTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";
    dict[@"integral"] = self.exchangeJifenTF.text;
    dict[@"paypwd"] = self.passwordTF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KJifen_Exchange_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
           
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
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
    if (textField == self.exchangeJifenTF) {
        [self.passwordTF becomeFirstResponder];
    }else if(textField == self.passwordTF){
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入字符种类
    if (range.length == 1 && string.length == 0) {
        
        return YES;
        
    }else if(textField == self.exchangeJifenTF){
        if (![predicateModel inputShouldNumber:string]) {
            [SVProgressHUD showErrorWithStatus:@"兑换积分只能输入数字"];
            return NO;
        }
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
