//
//  GLMine_DelegateController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_DelegateController.h"

@interface GLMine_DelegateController ()
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentviewWidth;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;

@end

@implementation GLMine_DelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentviewWidth.constant = kSCREEN_WIDTH - 30;

    self.bgView.layer.shadowColor = kMain_Color.CGColor;
    self.bgView.layer.shadowOpacity = 0.6f;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
  
    
    self.contentLabel.text = [NSString stringWithFormat:@"    我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我要成为代理我"];
    
    CGRect rect = [self.contentLabel.text  boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];

    if (rect.size.height + 75 > kSCREEN_HEIGHT - 280) {
        self.bgViewHeight.constant = kSCREEN_HEIGHT - 280;
    }else{
        self.bgViewHeight.constant = rect.size.height + 75;
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"choice"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"nochoice"];
    }
}

#pragma mark - 成为代理商
- (IBAction)beDelegate:(id)sender {
    
}

@end
