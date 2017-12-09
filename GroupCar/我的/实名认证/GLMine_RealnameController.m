//
//  GLMine_RealnameController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RealnameController.h"

@interface GLMine_RealnameController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *IDTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *identifyTF;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_RealnameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.borderColor = kMain_Color.CGColor;
    self.submitBtn.layer.borderWidth = 1.f;
    self.submitBtn.layer.cornerRadius = 5.f;
    
    if ([[UserModel defaultUser].status integerValue] == 2) {// 1未认证 2已认证
        
        self.IDTF.text = [UserModel defaultUser].dz_name;
        self.nameTF.text = [UserModel defaultUser].truename;
        self.identifyTF.text = [UserModel defaultUser].idcard;
        
        self.IDTF.enabled = NO;
        self.nameTF.enabled = NO;
        self.identifyTF.enabled = NO;
        
        self.IDTF.textColor = [UIColor darkGrayColor];
        self.nameTF.textColor = [UIColor darkGrayColor];
        self.identifyTF.textColor = [UIColor darkGrayColor];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

//提交
- (IBAction)submit:(id)sender {
    
    if (self.IDTF.text.length == 0 || self.IDTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的大众ID"];
        return;
    }
    
    if (![predicateModel validateIdentityCard:self.identifyTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"身份证号输入不合法"];
        return;
    }
    
    if(self.nameTF.text.length == 0 || self.nameTF.text.length > 16){
        [SVProgressHUD showErrorWithStatus:@"姓名长度太长或太短"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";
    dict[@"username"] = self.nameTF.text;
    dict[@"idcard"] = self.identifyTF.text;
    dict[@"dzname"] = self.IDTF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KTrueName_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            [UserModel defaultUser].status = @"2";//用户是否实名认证 1未认证 2已认证
            [UserModel defaultUser].dz_name = self.IDTF.text;
            [UserModel defaultUser].truename = self.nameTF.text;
            [UserModel defaultUser].idcard = self.identifyTF.text;

            [usermodelachivar achive];
            
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

#pragma mark - UITextFieldDelegeta
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.IDTF) {
        [self.nameTF becomeFirstResponder];
    }else if(textField == self.nameTF){
        [self.identifyTF becomeFirstResponder];
    }else if(textField == self.identifyTF){
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入字符种类
    if (range.length == 1 && string.length == 0) {
        
        return YES;
        
    }else if(textField == self.identifyTF || textField == self.IDTF){
        if (![predicateModel inputShouldLetterOrNum:string]) {
            [SVProgressHUD showErrorWithStatus:@"只能输入字母或数字"];
            return NO;
        }
    }
    
    //限制长度
    if(textField == self.IDTF){
        
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"大众ID最多16位"];
            return NO;
        }
        
    }else if(textField == self.nameTF){
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"姓名长度最多16位"];
            return NO;
        }
        
    }else if(textField == self.identifyTF){
        if (textField.text.length >= 18) {
            textField.text = [textField.text substringToIndex:18];
            [SVProgressHUD showErrorWithStatus:@"身份证最多18位"];
            return NO;
        }
    }
    return YES;
}

@end
