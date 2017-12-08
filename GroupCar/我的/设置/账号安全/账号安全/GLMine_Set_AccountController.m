//
//  GLMine_Set_AccountController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/4.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_AccountController.h"
#import "GLMine_Set_forgetController.h"//忘记密码
#import "GLMine_Set_ModifyPasswordController.h"//修改密码
#import "GLMine_Set_PhoneModifyController.h"//手机号修改

@interface GLMine_Set_AccountController ()

@end

@implementation GLMine_Set_AccountController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 二级密码修改
- (IBAction)secondPwdModify:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_forgetController *modifyVC = [[GLMine_Set_forgetController alloc] init];
    modifyVC.type = 2;
    modifyVC.navigationItem.title = @"二级密码修改";
    [self.navigationController pushViewController:modifyVC animated:YES];
}

#pragma mark - 忘记密码
- (IBAction)forgetPassword:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_forgetController *forgetVC = [[GLMine_Set_forgetController alloc] init];
    forgetVC.navigationItem.title = @"忘记密码";
    forgetVC.type = 1;
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - 密码修改
- (IBAction)modifyPwd:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_ModifyPasswordController *modifyVC = [[GLMine_Set_ModifyPasswordController alloc] init];
    
    modifyVC.navigationItem.title = @"密码修改";
    [self.navigationController pushViewController:modifyVC animated:YES];
}

#pragma mark - 手机号修改
- (IBAction)phoneNumModify:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_PhoneModifyController *modifyVC = [[GLMine_Set_PhoneModifyController alloc] init];
    modifyVC.navigationItem.title = @"修改手机号";
    [self.navigationController pushViewController:modifyVC animated:YES];
}



@end
