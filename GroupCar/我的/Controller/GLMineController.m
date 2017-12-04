//
//  GLMineController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"
#import "LCStarRatingView.h"

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starRatingView;
@property (strong, nonatomic) NSArray *arrList;

@end

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.starRatingView.type = LCStarRatingViewCountingTypeInteger;
    self.starRatingView.enabled = NO;
    self.starRatingView.progress = 3;
    self.tableview.tableFooterView = [UIView new];

    
}
#pragma mark ---------tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = YYSRGBColor(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = self.arrList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

-(NSArray*)arrList{

    if (!_arrList) {
        _arrList = @[@"推荐好友",@"我要成为代理商",@"设置"];
    }

    return _arrList;
}

@end
