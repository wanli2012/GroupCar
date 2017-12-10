//
//  GLMine_DetailRecordController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_DetailRecordController.h"
#import "GLMine_DetailRecordCell.h"
#import "GLMine_RecordModel.h"

@interface GLMine_DetailRecordController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_DetailRecordController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_DetailRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_DetailRecordCell"];
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

#pragma mark - 请求数据
- (void)postRequest:(BOOL)isRefresh{
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++ ;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"page"] = @(_page);
    if (self.type == 1) {
        dict[@"type"] = @"1";
    }else if(self.type == 2){
        dict[@"type"] = @"3";
    }else if(self.type == 3){
        dict[@"type"] = @"2";
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KExchange_Record_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                if(isRefresh){
                    [self.models removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_RecordModel * model = [GLMine_RecordModel mj_objectWithKeyValues:dic];
                    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_DetailRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_DetailRecordCell"];
    GLMine_RecordModel *model = self.models[indexPath.row];
    model.typeIndex = self.type;
    cell.model = model;
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == 1 || self.type == 3){
        return 65;
    }else{
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        return tableView.rowHeight;
    }
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
