//
//  GLMallController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMallController.h"
#import "MenuScreeningView.h"
#import "LBMallCarListTableViewCell.h"

@interface GLMallController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *buttonview;
@property (weak, nonatomic) IBOutlet UIButton *fitterButton;
@property (nonatomic, strong) MenuScreeningView *menuScreeningView;  //条件选择器
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *LBMallCarList = @"LBMallCarListTableViewCell";

@implementation GLMallController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.buttonview addSubview:self.menuScreeningView];
    
    [self.tableview registerNib:[UINib nibWithNibName:LBMallCarList bundle:nil] forCellReuseIdentifier:LBMallCarList];
}


#pragma mark --- tableview  delegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMallCarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LBMallCarList forIndexPath:indexPath];
    cell.selectionStyle = 0;
    return cell;
    
    return [[UITableViewCell alloc]init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 330;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self buttonEdgeInsets:self.fitterButton];
}

-(void)buttonEdgeInsets:(UIButton *)button{
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width + 2, 0, button.imageView.bounds.size.width + 10)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 10, 0, -button.titleLabel.bounds.size.width + 2)];
    
}

-(MenuScreeningView*)menuScreeningView{
    
    if (!_menuScreeningView) {
        _menuScreeningView = [[MenuScreeningView alloc] initWithFrame:CGRectMake(0, 0,kSCREEN_WIDTH*(3.0/4) , 45)];
        _menuScreeningView.backgroundColor = [UIColor whiteColor];
    }
    
    return _menuScreeningView;
    
}
@end
