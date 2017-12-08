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
    
    BOOL _isAgreeProtocol;
    
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
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (nonatomic, copy)NSString *currentStr;


@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(kSCREEN_WIDTH > 320){
        self.scrollView.scrollEnabled = NO;
    }
    
    self.contentViewHeight.constant = 667;
    self.scrollView.bounces = NO;
    self.conentViewWidth.constant = kSCREEN_WIDTH;
    
    self.registeBtn.layer.cornerRadius = 5.f;
    
    self.tuijianrenView.layer.cornerRadius = 5.f;
    self.phoneView.layer.cornerRadius = 5.f;
    self.passwordV.layer.cornerRadius = 5.f;
    self.ensureView.layer.cornerRadius = 5.f;
    self.codeView.layer.cornerRadius = 5.f;
    
    self.tuijianrenView.layer.borderWidth = 1.f;
    self.phoneView.layer.borderWidth = 1.f;
    self.passwordV.layer.borderWidth = 1.f;
    self.ensureView.layer.borderWidth = 1.f;
    self.codeView.layer.borderWidth = 1.f;
    
    self.tuijianrenView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.phoneView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.passwordV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.ensureView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _isAgreeProtocol = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 注册协议
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"choice"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"nochoice"];
    }
}

#pragma mark - 登录
- (IBAction)login:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 获取验证码
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
#pragma mark - 注册
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
    dict[@"type"] = @"1";
    dict[@"agreement"] = @"1";
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.recommendTF) {
        [self.phoneTF becomeFirstResponder];
    }else if(textField == self.phoneTF){
        [self.passwordTF becomeFirstResponder];
    }else if(textField == self.passwordTF){
        [self.ensureTF becomeFirstResponder];
    }else if(textField == self.ensureTF){
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
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [SVProgressHUD showErrorWithStatus:@"验证码最多4位"];
           return NO;
        }
        
    }
    return YES;
}


@end
