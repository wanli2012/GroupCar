//
//  GLMine_Exchange_MoneyController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Exchange_MoneyController.h"
#import "GLMine_CardChooseController.h"
#import "GLMine_MyExchangeController.h"

@interface GLMine_Exchange_MoneyController ()

@property (weak, nonatomic) IBOutlet UIImageView *addImageV;//添加图片
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;//银行卡号和银行
@property (weak, nonatomic) IBOutlet UITextField *exchangeTF;//兑换金额
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTF;//二级密码
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//余额
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, copy)NSString *bank_id;

@end

@implementation GLMine_Exchange_MoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.cornerRadius = 5.f;
}

#pragma mark - 银行卡选择
- (IBAction)bankCardChoose:(id)sender {
    
    [self viewController].hidesBottomBarWhenPushed = YES;
    GLMine_CardChooseController *chooseVC = [[GLMine_CardChooseController alloc] init];
   __weak __typeof(self) weakSelf = self;
    chooseVC.block = ^(NSString *bankName, NSString *bankNum, NSString *bank_id) {
        weakSelf.bankLabel.text = [NSString stringWithFormat:@"%@(尾号%@)",bankName,bankNum];
    };
    chooseVC.navigationItem.title = @"银行卡选择";
    [[self viewController].navigationController pushViewController:chooseVC animated:YES];
}
- (GLMine_MyExchangeController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GLMine_MyExchangeController class]]) {
            return (GLMine_MyExchangeController *)nextResponder;
        }
    }
    return nil;
}
- (IBAction)submit:(id)sender {
    
    if ([self.exchangeTF.text integerValue] <= 0.0) {
        [SVProgressHUD showErrorWithStatus:@"兑换积分数必须大于0"];
        return;
    }
    if ([self.exchangeTF.text integerValue] % 100 != 0) {
        
        [SVProgressHUD showErrorWithStatus:@"兑换积分数必须是100的整数倍!"];
        return;
    }
    
    if ([self.exchangeTF.text integerValue] > [self.moneyLabel.text integerValue]){
        [SVProgressHUD showErrorWithStatus:@"余额不足!"];
        return;
    }
    
    if (self.secondPasswordTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";
    dict[@"bankid"] = self.bank_id;
    dict[@"money"] = self.exchangeTF.text;
    dict[@"paypwd"] = self.secondPasswordTF.text;
    
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
    if (textField == self.exchangeTF) {
        [self.secondPasswordTF becomeFirstResponder];
    }else if(textField == self.secondPasswordTF){
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入字符种类
    if (range.length == 1 && string.length == 0) {
        
        return YES;
        
    }else if(textField == self.exchangeTF){
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
    if(textField == self.secondPasswordTF){
        
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"密码最多16位"];
            
            return NO;
        }
    }
    return YES;
}
@end
