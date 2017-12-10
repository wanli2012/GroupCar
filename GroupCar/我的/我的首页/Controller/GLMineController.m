//
//  GLMineController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"
//#import "LCStarRatingView.h"
#import "GLMine_Cell.h"
#import "GLMine_SetController.h"//设置
#import "GLMine_PersonInfoController.h"//个人信息
#import "GLMine_MessageController.h"//消息
#import "GLMine_RecommendController.h"//推荐好友
#import "GLMine_MyExchangeController.h"//我要兑换
#import "GLMine_AchieveController.h"//我的业绩
#import "GLMine_RechargeController.h"//充值
#import "GLMine_RealnameController.h"//实名认证
#import "GLMine_DelegateController.h"//成为代理商

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *arrList;
@property (nonatomic, copy)NSArray *imageArr;
@property (weak, nonatomic) IBOutlet UIView *leftV;
@property (weak, nonatomic) IBOutlet UIView *rightV;
@property (weak, nonatomic) IBOutlet UIView *rightV2;
@property (weak, nonatomic) IBOutlet UIView *leftV2;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//身份
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self.tableview registerNib:[UINib nibWithNibName:@"GLMine_Cell" bundle:nil] forCellReuseIdentifier:@"GLMine_Cell"];
    [self setUI];//设置UI样式
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self postRequest];
}
#pragma mark - 设置UI样式
- (void)setUI{
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    
    self.leftV.layer.shadowColor = YYSRGBColor(111, 110, 237, 1).CGColor;
    self.leftV.layer.shadowOpacity = 0.6f;
    self.leftV.layer.shadowRadius = 5.f;
    self.leftV.layer.shadowOffset = CGSizeMake(0,0);
    
    self.leftV2.layer.shadowColor = YYSRGBColor(111, 110, 237, 1).CGColor;
    self.leftV2.layer.shadowOpacity = 0.6f;
    self.leftV2.layer.shadowRadius = 5.f;
    self.leftV2.layer.shadowOffset = CGSizeMake(0,0);
    
    self.rightV.layer.shadowColor = YYSRGBColor(111, 110, 237, 1).CGColor;
    self.rightV.layer.shadowOpacity = 0.6f;
    self.rightV.layer.shadowRadius = 5.f;
    self.rightV.layer.shadowOffset = CGSizeMake(0,0);
    
    self.rightV2.layer.shadowColor = YYSRGBColor(111, 110, 237, 1).CGColor;
    self.rightV2.layer.shadowOpacity = 0.6f;
    self.rightV2.layer.shadowRadius = 5.f;
    self.rightV2.layer.shadowOffset = CGSizeMake(0,0);

}

#pragma mark - 请求数据
- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;

    [NetworkManager requestPOSTWithURLStr:KMyInfo_Interface paramDic:dict finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                [UserModel defaultUser].portrait = responseObject[@"data"][@"portrait"];
                [UserModel defaultUser].group = responseObject[@"data"][@"group"];
                [UserModel defaultUser].nickname = responseObject[@"data"][@"nickname"];
                [UserModel defaultUser].money = responseObject[@"data"][@"money"];
                [UserModel defaultUser].mark = responseObject[@"data"][@"mark"];
                [UserModel defaultUser].u_group = responseObject[@"data"][@"u_group"];
                [UserModel defaultUser].status = responseObject[@"data"][@"status"];
                
                [usermodelachivar achive];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self setupHeader];
    } enError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}
#pragma mark - 头视图赋值
- (void)setupHeader{
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].portrait] placeholderImage: [UIImage imageNamed:@"touxiang"]];
    
    if ([[UserModel defaultUser].u_group integerValue] == 1) {//1代表用户还是会员 2是个人代理
        self.statusLabel.text = @"会员";
    }else if([[UserModel defaultUser].u_group integerValue] == 2){
        self.statusLabel.text = @"个人代理";
    }
    
    if([UserModel defaultUser].nickname.length == 0){
        self.nameLabel.text = @"昵称";
    }else{
        self.nameLabel.text = [UserModel defaultUser].nickname;
    }
    
    self.jifenLabel.text = [UserModel defaultUser].mark;
    self.moneyLabel.text = [UserModel defaultUser].money;
}

#pragma mark - 消息
- (IBAction)message:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_MessageController *messageVC = [[GLMine_MessageController alloc] init];
    messageVC.navigationItem.title = @"消息";
    [self.navigationController pushViewController:messageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 个人信息
- (IBAction)personInfo:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfoController *personInfoVC = [[GLMine_PersonInfoController alloc] init];
    personInfoVC.navigationItem.title = @"个人信息";
    [self.navigationController pushViewController:personInfoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 成为代理商
- (IBAction)becomeDelegate:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_DelegateController *delegateVC = [[GLMine_DelegateController alloc] init];
    delegateVC.navigationItem.title = @"我要成为代理商";
    [self.navigationController pushViewController:delegateVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - 我的业绩
- (IBAction)myAchievement:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_AchieveController *achieveVC = [[GLMine_AchieveController alloc] init];
    achieveVC.navigationItem.title = @"我的业绩";
    [self.navigationController pushViewController:achieveVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 我要充值
- (IBAction)recharge:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_RechargeController *rechargeVC = [[GLMine_RechargeController alloc] init];
    rechargeVC.navigationItem.title = @"充值";
    [self.navigationController pushViewController:rechargeVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 我要兑换
- (IBAction)exchange:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_MyExchangeController *exchangeVC = [[GLMine_MyExchangeController alloc] init];
    exchangeVC.navigationItem.title = @"我要兑换";
    [self.navigationController pushViewController:exchangeVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark ---------UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Cell"];
    cell.selectionStyle = 0;
    cell.picImageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.titleLabel.text = self.arrList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
        {
            GLMine_RecommendController *recommendVC = [[GLMine_RecommendController alloc] init];
            recommendVC.navigationItem.title = @"推荐好友";
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
            break;
        case 1:
        {
            GLMine_SetController * setVC = [[GLMine_SetController alloc] init];
            setVC.navigationItem.title = @"设置";
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        case 2:
        {
            GLMine_RealnameController *realNameVC = [[GLMine_RealnameController alloc] init];
            realNameVC.navigationItem.title = @"实名认证";
            [self.navigationController pushViewController:realNameVC animated:YES];
        }
            
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - 懒加载
-(NSArray*)arrList{
    if (!_arrList) {
        _arrList = @[@"推荐好友",@"设置",@"实名认证"];
    }
    return _arrList;
}

- (NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"推荐好友",@"Setup",@"实名认证"];
    }
    return _imageArr;
}

@end
