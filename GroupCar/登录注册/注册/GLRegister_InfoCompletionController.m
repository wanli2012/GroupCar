//
//  GLRegister_InfoCompletionController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLRegister_InfoCompletionController.h"
#import "GLRegister_Info_NoPhoneController.h"
#import "GLRegister_Info_HavePhoneController.h"

@interface GLRegister_InfoCompletionController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLRegister_InfoCompletionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.phoneView.layer.borderWidth = 1.f;
    
    self.codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.codeView.layer.borderWidth = 1.f;
    
    self.getCodeBtn.layer.borderWidth = 1.f;
    self.getCodeBtn.layer.borderColor = kMain_Color.CGColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)nextStep:(id)sender {
    if (self.phoneTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号未输入"];
        return;
    }else if(![predicateModel valiMobile:self.phoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"手机号不合法"];
        return;
    }
    
    if(self.codeTF.text.length != 4){
        [SVProgressHUD showErrorWithStatus:@"验证码输入不正确"];
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"phone"] = self.phoneTF.text;
    dict[@"verification"] = self.codeTF.text;
    
   _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KUserPerfect_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {

            self.hidesBottomBarWhenPushed = YES;
            if ([responseObject[@"data"][@"status"] integerValue] == 1){//有账号
                GLRegister_Info_HavePhoneController *havePhone = [[GLRegister_Info_HavePhoneController alloc] init];
                havePhone.phone = self.phoneTF.text;
                havePhone.appid = self.appid;
                havePhone.navigationItem.title = @"信息补全";
                [self.navigationController pushViewController:havePhone animated:YES];
            }else{//没有账号
                GLRegister_Info_NoPhoneController *noPhoneVC = [[GLRegister_Info_NoPhoneController alloc] init];
                noPhoneVC.phone = self.phoneTF.text;
                noPhoneVC.appid = self.appid;
                noPhoneVC.navigationItem.title = @"信息补全";
                [self.navigationController pushViewController:noPhoneVC animated:YES];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}
//获取验证码
- (IBAction)getCode:(id)sender {
    if (self.phoneTF.text.length <=0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:KGet_Code_Interface paramDic:@{@"phone":self.phoneTF.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    } enError:^(NSError *error) {
        
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
                self.getCodeBtn.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTF) {
        [self.codeTF becomeFirstResponder];
    }else if(textField == self.codeTF){
        [self.view endEditing:YES];
    }
    return YES;
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
        
    }else if(textField == self.codeTF){
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [SVProgressHUD showErrorWithStatus:@"验证码最多4位"];
            return NO;
        }
        
    }
    return YES;
}

@end
