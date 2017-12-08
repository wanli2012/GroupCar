//
//  GLMine_Set_PhoneModifyController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_PhoneModifyController.h"
#import "GLMine_Set_NewPhoeController.h"

@interface GLMine_Set_PhoneModifyController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMine_Set_PhoneModifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeView.layer.cornerRadius = 5.f;
    self.codeView.layer.borderWidth = 1.f;
    self.codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.getCodeBtn.layer.cornerRadius = 5.f;
    self.getCodeBtn.layer.borderWidth = 1.f;
    self.getCodeBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
 
    self.nextBtn.layer.cornerRadius = 5.f;
    
    self.noticeLabel.text = [NSString stringWithFormat:@"验证码将发送至%@",[UserModel defaultUser].phone];
    
}

- (IBAction)submit:(id)sender {
    if (self.codeTF.text.length < 4 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入4位的验证码"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"1";
    dict[@"phone"] = [UserModel defaultUser].phone;
    dict[@"verification"] = self.codeTF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KChange_Phone_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.hidesBottomBarWhenPushed = YES;
            GLMine_Set_NewPhoeController *newPhoneVC = [[GLMine_Set_NewPhoeController alloc] init];
            newPhoneVC.navigationItem.title = @"修改手机号";
            [self.navigationController pushViewController:newPhoneVC animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
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
    return YES;
}

@end
