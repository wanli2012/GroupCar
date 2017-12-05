//
//  LBLoginViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBLoginViewController.h"
#import "LBRegisterViewController.h"

@interface LBLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnTop;

@end

@implementation LBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.accountView.layer.cornerRadius = 5.f;
    self.passwordView.layer.cornerRadius = 5.f;
    self.accountView.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);
    self.passwordView.backgroundColor = YYSRGBColor(255, 255, 255, 0.2);

    self.loginBtnTop.constant = 60 * autoSizeScaleY;
    
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.borderWidth = 1.f;
    
}

- (IBAction)login:(id)sender {
    NSLog(@"登录");
    
    
}
- (IBAction)registe:(id)sender {
    [self presentViewController:[LBRegisterViewController new] animated:YES completion:nil];
    
}
- (IBAction)weixinLogin:(id)sender {
    NSLog(@"微信登录");
}


@end
