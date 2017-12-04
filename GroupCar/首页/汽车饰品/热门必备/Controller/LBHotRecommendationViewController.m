//
//  LBHotRecommendationViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/8/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBHotRecommendationViewController.h"
#import "LBOutOfTheOrdinaryTableViewCell.h"

@interface LBHotRecommendationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *CellID = @"LBOutOfTheOrdinaryTableViewCell";

@implementation LBHotRecommendationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"热门推荐";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableview registerNib:[UINib nibWithNibName:CellID bundle:nil] forCellReuseIdentifier:CellID];

}

#pragma mark --- tableview  delegete

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBOutOfTheOrdinaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.exchangeBt.hidden = YES;
    cell.trailing.constant = 10;
    cell.leading.constant = 10;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
