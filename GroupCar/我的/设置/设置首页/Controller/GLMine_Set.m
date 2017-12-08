//
//  GLMine_Set.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set.h"
#import "GLMine_SetCell.h"
#import "GLMine_Set_AccountController.h"

@interface GLMine_Set ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *valueArr;

@end

@implementation GLMine_Set

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    self.quitBtn.layer.cornerRadius = 5.f;
    self.quitBtn.layer.borderColor = YYSRGBColor(95, 94, 239, 1).CGColor;
    self.quitBtn.layer.borderWidth = 1.f;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SetCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SetCell"];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SetCell"];
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.selectionStyle = 0;
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
            GLMine_Set_AccountController *accountVC = [[GLMine_Set_AccountController alloc] init];
            accountVC.navigationItem.title = @"账号安全";
            [self.navigationController pushViewController:accountVC animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }

}

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"账号安全",@"公司关于",@"版本信息",@"联系客服",@"清除缓存"];
    }
    return _titleArr;
}

- (NSArray *)valueArr{
    if (!_valueArr) {
        _valueArr = @[@"v2.2",@""];
    }
    return _valueArr;
}

@end
