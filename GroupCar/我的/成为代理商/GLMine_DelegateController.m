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

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, copy)NSString *delegeteContent;

@end

@implementation GLMine_DelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentviewWidth.constant = kSCREEN_WIDTH - 30;

    self.bgView.layer.shadowColor = kMain_Color.CGColor;
    self.bgView.layer.shadowOpacity = 0.6f;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    
    [self postRequest];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
#pragma mark - 设置协议内容
- (void)setContent{
    
    self.contentLabel.text = self.delegeteContent;
    
    CGRect rect = [self.contentLabel.text  boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
    
    if (rect.size.height + 75 > kSCREEN_HEIGHT - 280) {
        self.bgViewHeight.constant = kSCREEN_HEIGHT - 280;
    }else{
        self.bgViewHeight.constant = rect.size.height + 75;
    }

}
#pragma mark - 请求数据
- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"1";//1获取代理协议 2验证代理协议
   
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_Delegate_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.delegeteContent = responseObject[@"data"][@"agreement"];
            [self setContent];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
#pragma mark - 是否同意协议
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
