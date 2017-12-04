//
//  GLClubController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLClubController.h"
#import "GLNearby_SectionHeaderView.h"
#import "LBClubTableViewCell.h"

@interface GLClubController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *LBClub = @"LBClubTableViewCell";

@implementation GLClubController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self.tableview registerNib:[UINib nibWithNibName:LBClub bundle:nil] forCellReuseIdentifier:LBClub];
}

#pragma mark --- tableview  delegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GLNearby_SectionHeaderView *headV = [[NSBundle mainBundle] loadNibNamed:@"GLNearby_SectionHeaderView" owner:nil options:nil].lastObject;
    
    if (section == 0) {
        headV.titleLb.font = [UIFont fontWithName:@"迷你简汉真广标" size:17];
    }
    
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
        LBClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LBClub forIndexPath:indexPath];
        cell.selectionStyle = 0;
        return cell;
    
    return [[UITableViewCell alloc]init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
@end
