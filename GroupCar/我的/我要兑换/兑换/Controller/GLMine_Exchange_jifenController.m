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

@end

@implementation GLMine_Exchange_jifenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 5.f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

@end
