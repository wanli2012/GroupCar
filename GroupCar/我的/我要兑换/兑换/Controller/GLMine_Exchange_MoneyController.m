//
//  GLMine_Exchange_MoneyController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Exchange_MoneyController.h"
#import "GLMine_CardChooseController.h"
#import "GLMine_MyExchangeController.h"

@interface GLMine_Exchange_MoneyController ()

@property (weak, nonatomic) IBOutlet UIImageView *addImageV;//添加图片
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;//银行卡号和银行
@property (weak, nonatomic) IBOutlet UITextField *exchangeTF;//兑换金额
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTF;//二级密码
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//余额
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交

@end

@implementation GLMine_Exchange_MoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.cornerRadius = 5.f;
}

#pragma mark - 银行卡选择
- (IBAction)bankCardChoose:(id)sender {
    
    [self viewController].hidesBottomBarWhenPushed = YES;
    GLMine_CardChooseController *chooseVC = [[GLMine_CardChooseController alloc] init];
   __weak __typeof(self) weakSelf = self;
    chooseVC.block = ^(NSString *bankName, NSString *bankNum, NSString *bank_id) {
        weakSelf.bankLabel.text = [NSString stringWithFormat:@"%@(尾号%@)",bankName,bankNum];
    };
    chooseVC.navigationItem.title = @"银行卡选择";
    [[self viewController].navigationController pushViewController:chooseVC animated:YES];
}
- (GLMine_MyExchangeController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GLMine_MyExchangeController class]]) {
            return (GLMine_MyExchangeController *)nextResponder;
        }
    }
    return nil;
}
@end
