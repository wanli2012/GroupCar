//
//  LBOutOfTheOrdinaryViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/8/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBOutOfTheOrdinaryViewController.h"
#import "LBOutOfTheOrdinaryTableViewCell.h"
#import "LBOutOfTheOrdinaryView.h"

@interface LBOutOfTheOrdinaryViewController ()<UITableViewDelegate,UITableViewDataSource,OutOfTheOrdinaryDelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *sectionArr;

@end

static NSString *CellID = @"LBOutOfTheOrdinaryTableViewCell";

@implementation LBOutOfTheOrdinaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"与众不同";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableview registerNib:[UINib nibWithNibName:CellID bundle:nil] forCellReuseIdentifier:CellID];
}

#pragma mark --- tableview  delegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LBOutOfTheOrdinaryView *headV = [[NSBundle mainBundle] loadNibNamed:@"LBOutOfTheOrdinaryView" owner:nil options:nil].lastObject;
    headV.imagev.image = [UIImage imageNamed:self.sectionArr[section]];
    
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBOutOfTheOrdinaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.delegete = self;
    cell.imageV.hidden = YES;
    
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ------ 立即兑换

-(void)clickExchangeNow:(NSInteger)row{


}

-(NSArray*)sectionArr{
    
    if (!_sectionArr) {
        _sectionArr = @[@"个性专属",@"定制色彩"];
    }
    return _sectionArr;
    
}


@end
