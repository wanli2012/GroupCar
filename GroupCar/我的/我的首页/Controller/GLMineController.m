//
//  GLMineController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"
#import "LCStarRatingView.h"
#import "GLMine_Set.h"
#import "GLMine_Cell.h"
#import "GLMine_PersonInfoController.h"//个人信息

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *arrList;
@property (nonatomic, copy)NSArray *imageArr;
@property (weak, nonatomic) IBOutlet UIView *leftV;
@property (weak, nonatomic) IBOutlet UIView *rightV;
@property (weak, nonatomic) IBOutlet UIView *rightV2;
@property (weak, nonatomic) IBOutlet UIView *leftV2;

@end

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
   
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:@"GLMine_Cell" bundle:nil] forCellReuseIdentifier:@"GLMine_Cell"];
    [self setUI];//设置UI样式
  
}

#pragma mark - 设置UI样式
- (void)setUI{
    
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

#pragma mark - 消息
- (IBAction)message:(id)sender {
    NSLog(@"消息");
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
    NSLog(@"个人代理商");
}
#pragma mark - 我的业绩
- (IBAction)myAchievement:(id)sender {
    NSLog(@"我的业绩");
}
#pragma mark - 我要充值
- (IBAction)recharge:(id)sender {
    NSLog(@"我要充值");
}
#pragma mark - 我要兑换
- (IBAction)exchange:(id)sender {
    NSLog(@"我要兑换");
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
            NSLog(@"推荐好友");
        }
            break;
        case 1:
        {
            GLMine_Set * setVC = [[GLMine_Set alloc] init];
            setVC.navigationItem.title = @"设置";
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

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
        _imageArr = @[@"phone-Sign",@"phone-Sign",@"phone-Sign"];
    }
    return _imageArr;
}

@end
