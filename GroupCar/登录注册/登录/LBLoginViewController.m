//
//  LBLoginViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBLoginViewController.h"
#import "UIButton+SetEdgeInsets.h"


@interface LBLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerBt;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UIButton *forgetBt;
@property (weak, nonatomic) IBOutlet UIView *baseV1;
@property (weak, nonatomic) IBOutlet UIView *baseV2;

@end

@implementation LBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
//注册
- (IBAction)registerevent:(UIButton *)sender {
}
//登录
- (IBAction)loginevnt:(UIButton *)sender {
}

-(void)updateViewConstraints{
    [super updateViewConstraints];

    self.forgetBt.layer.cornerRadius = 15;
    self.forgetBt.clipsToBounds = YES;
    self.forgetBt.layer.borderWidth = 1;
    self.forgetBt.layer.borderColor = YYSRGBColor(85, 86, 238, 1).CGColor;
    
    self.loginBt.layer.cornerRadius = 2;
    self.loginBt.clipsToBounds = YES;

    self.baseV1.layer.shadowOpacity = 0.5;// 阴影透明度
    self.baseV1.layer.shadowColor = YYSRGBColor(86, 85, 238, 1).CGColor;// 阴影的颜色
    self.baseV1.layer.shadowRadius = 10;// 阴影扩散的范围控制
    self.baseV1.layer.shadowOffset  = CGSizeMake(0, 0);// 阴影的范围
    
    self.baseV2.layer.shadowOpacity = 0.5;// 阴影透明度
    self.baseV2.layer.shadowColor = YYSRGBColor(86, 85, 238, 1).CGColor;// 阴影的颜色
    self.baseV2.layer.shadowRadius = 10;// 阴影扩散的范围控制
    self.baseV2.layer.shadowOffset  = CGSizeMake(0, 0);// 阴影的范围
    
    self.baseV2.layer.cornerRadius = 4;
    self.baseV1.layer.cornerRadius = 4;


}

@end
