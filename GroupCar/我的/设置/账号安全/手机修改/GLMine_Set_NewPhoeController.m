//
//  GLMine_Set_NewPhoeController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_NewPhoeController.h"
#import "GLMine_Set_AccountController.h"

@interface GLMine_Set_NewPhoeController ()

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_Set_NewPhoeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 5.f;
    
    self.phoneView.layer.cornerRadius = 5.f;
    self.phoneView.layer.borderWidth = 1.f;
    self.phoneView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.codeView.layer.cornerRadius = 5.f;
    self.codeView.layer.borderWidth = 1.f;
    self.codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
}

- (IBAction)submit:(id)sender {
    
    if (self.codeTF.text.length < 4 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入4位的验证码"];
        return;
    }
    if (self.phoneTF.text.length < 11 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号"];
        return;
    }else if(![predicateModel valiMobile:self.phoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"手机号输入不合法"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";
    dict[@"phone"] = self.phoneTF.text;
    dict[@"verification"] = self.codeTF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KChange_Phone_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            
            NSArray *temArray = self.navigationController.viewControllers;
            
            for(UIViewController *temVC in temArray)
            {
                if ([temVC isKindOfClass:[GLMine_Set_AccountController class]])
                {
                    [self.navigationController popToViewController:temVC animated:YES];
                }
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)getCode:(id)sender {
    
    if (self.phoneTF.text.length < 11 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号"];
        return;
    }else if(![predicateModel valiMobile:self.phoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"手机号输入不合法"];
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


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.codeTF){
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
    if(textField == self.codeTF){
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
            [SVProgressHUD showErrorWithStatus:@"验证码为4位"];
            return NO;
        }
    }
    if(textField == self.phoneTF){
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            [SVProgressHUD showErrorWithStatus:@"手机号为11位"];
            return NO;
        }
    }
    return YES;
}


@end
