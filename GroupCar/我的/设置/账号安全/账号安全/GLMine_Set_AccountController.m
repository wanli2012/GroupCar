//
//  GLMine_Set_AccountController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/4.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_AccountController.h"
#import "GLMine_Set_modifyPwdController.h"//修改密码

@interface GLMine_Set_AccountController ()

@end

@implementation GLMine_Set_AccountController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 密码修改
- (IBAction)modifyPwd:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_modifyPwdController *modifyVC = [[GLMine_Set_modifyPwdController alloc] init];
    modifyVC.type = 1;
    modifyVC.navigationItem.title = @"密码修改";
    [self.navigationController pushViewController:modifyVC animated:YES];
}
#pragma mark - 银行卡绑定
- (IBAction)bankCardBang:(id)sender {
    
}
#pragma mark - 二级密码修改
- (IBAction)secondPwdModify:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_modifyPwdController *modifyVC = [[GLMine_Set_modifyPwdController alloc] init];
    modifyVC.type = 2;
    modifyVC.navigationItem.title = @"二级密码修改";
    [self.navigationController pushViewController:modifyVC animated:YES];
}



@end
