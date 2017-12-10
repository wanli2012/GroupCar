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
#import "GLClubModel.h"

@interface GLClubController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;

@end

static NSString *LBClub = @"LBClubTableViewCell";

@implementation GLClubController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:LBClub bundle:nil] forCellReuseIdentifier:LBClub];//
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf postRequest:NO];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    self.page = 1;
    [self postRequest:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

#pragma mark - 请求数据
- (void)postRequest:(BOOL)isRefresh{
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++ ;
    }

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_Club_Activity_Interface paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                if(isRefresh){
                    [self.models removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLClubModel * model = [GLClubModel mj_objectWithKeyValues:dic];
                    
                    [self.models addObject:model];
                }
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.models.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - UITableViewDelegate UITalbeViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.models.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    GLNearby_SectionHeaderView *headV = [[NSBundle mainBundle]  loadNibNamed:@"GLNearby_SectionHeaderView" owner:nil options:nil].lastObject;
//
//    if (section == 0) {
//        headV.titleLb.font = [UIFont fontWithName:@"迷你简汉真广标" size:17];
//    }
//
//    return headV;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LBClub forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    return cell;
    
    return [[UITableViewCell alloc]init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 50);
        
    }
    return _nodataV;
}

@end
