//
//  LBRegisterViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBRegisterViewController.h"
#import "LBLoginViewController.h"

@interface LBRegisterViewController ()<UITextFieldDelegate>
{
    NSString *_recommendStr;
    NSString *_phoneStr;
    NSString *_passwordStr;
    NSString *_ensureStr;
    NSString *_codeStr;
    
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet UIView *tuijianrenView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *passwordV;
@property (weak, nonatomic) IBOutlet UIView *ensureView;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UITextField *recommendTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;


@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registeBtn;

@property (nonatomic, copy)NSString *currentStr;


@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(kSCREEN_WIDTH > 320){
        self.scrollView.scrollEnabled = NO;
    }
    
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH,687);
    self.contentViewHeight.constant = 687;
    self.scrollView.bounces = NO;
    self.conentViewWidth.constant = kSCREEN_WIDTH;
    
    self.registeBtn.layer.cornerRadius = 5.f;
    self.registeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registeBtn.layer.borderWidth = 1.f;
    
    self.tuijianrenView.layer.cornerRadius = 5.f;
    self.phoneView.layer.cornerRadius = 5.f;
    self.passwordV.layer.cornerRadius = 5.f;
    self.ensureView.layer.cornerRadius = 5.f;
    self.codeView.layer.cornerRadius = 5.f;
    
    self.tuijianrenView.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);
    self.phoneView.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);
    self.passwordV.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);
    self.ensureView.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);
    self.codeView.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
}

- (IBAction)login:(id)sender {
    
    [self presentViewController:[LBLoginViewController new] animated:YES completion:nil];
}

- (IBAction)regist:(id)sender {
    
    if (self.phoneTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号未输入"];
        return;
    }else if(![predicateModel valiMobile:self.phoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"手机号不合法"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"请设置6 ~ 16位密码"];
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.ensureTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    if(self.codeTF.text.length != 4){
        [SVProgressHUD showErrorWithStatus:@"验证码输入不正确"];
        return;
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"Referee"] = self.phoneTF.text;
//    dict[@"appid"] = encryptsecret;
    dict[@"userphone"] = self.phoneTF.text;
    dict[@"password"] = self.passwordTF.text;
    dict[@"confirmpwd"] = self.ensureTF.text;
    dict[@"verification"] = self.codeTF.text;
    dict[@"port"] = @"1";//那个端口注册 1ios 2安卓 3web 默认1

    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KRegister paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            [UIView animateWithDuration:0.3 animations:^{
                
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
    if(textField == self.recommendTF){
        
        if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            [SVProgressHUD showErrorWithStatus:@"推荐人ID最多16位"];
            
            return NO;
        }
        
    }else if(textField == self.phoneTF){
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
