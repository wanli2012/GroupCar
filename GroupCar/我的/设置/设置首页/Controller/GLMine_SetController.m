//
//  GLMine_SetController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/4.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetController.h"
#import "GLMine_Set_AccountController.h"

@interface GLMine_SetController ()
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation GLMine_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"设置";
    self.quitBtn.layer.cornerRadius = 5.f;
    self.quitBtn.layer.borderColor = YYSRGBColor(95, 94, 239, 1).CGColor;
    self.quitBtn.layer.borderWidth = 1.f;
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;
    
}

#pragma mark - 账号安全
- (IBAction)accountSecurity:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_AccountController *accountVC = [[GLMine_Set_AccountController alloc] init];
    accountVC.navigationItem.title = @"账号安全";
    [self.navigationController pushViewController:accountVC animated:YES];
    
}

#pragma mark - 关于公司
- (IBAction)aboutCompany:(id)sender {
    NSLog(@"关于公司");
}
#pragma mark - 版本信息
- (IBAction)editionInfo:(id)sender {
    NSLog(@"版本信息");
}
#pragma mark - 联系客服
- (IBAction)contractUS:(id)sender {
    NSLog(@"联系客服");
}
#pragma mark - 清除缓存
- (IBAction)clearMemory:(id)sender {
    NSLog(@"清除缓存");
}

#pragma mark - 退出登录
- (IBAction)quit:(id)sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserModel defaultUser].loginstatus = NO;
        [UserModel defaultUser].portrait = @"";
        [UserModel defaultUser].token = @"";
        [UserModel defaultUser].user_id = @"";
        
        [usermodelachivar achive];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"suckEffect";
        [self.view.window.layer addAnimation:animation forKey:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
