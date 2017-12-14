
//  GLCollectController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCollectController.h"
#import "GLCollectCell.h"
#import "GLCollectModel.h"

@interface GLCollectController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isEdit;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;


@end

@implementation GLCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView.hidden = YES;
    self.headerHeight.constant = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCollectCell" bundle:nil] forCellReuseIdentifier:@"GLCollectCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    _isEdit = NO;
    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        
    }];
    
    //    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //
    //        [weakSelf postRequest:NO];
    //
    //    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    //    self.tableView.mj_footer = footer;
    
    self.page = 1;
    
}

#pragma mark - 请求数据
- (void)postRequest:(BOOL)isRefresh{
    
    _isEdit = YES;
    self.editBtn.selected = YES;
    [self edit:self.editBtn];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"page"] = @(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_Collection_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if(isRefresh){
                
                [self.models removeAllObjects];
            }
            if ([responseObject[@"data"] count] != 0) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLCollectModel * model = [GLCollectModel mj_objectWithKeyValues:dic];
                    
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
        self.editBtn.selected = YES;
        [self edit:self.editBtn];
        [_loadV removeloadview];
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self postRequest:YES];
}

#pragma mark - 编辑
- (IBAction)edit:(UIButton *)sender {
    
    self.editBtn.selected = !self.editBtn.selected;
    _isEdit = !_isEdit;
    if(self.editBtn.selected){
        if (self.models.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"还未收藏商品"];
            self.editBtn.selected = NO;
            return;
        }
        self.headerHeight.constant = 40;
        self.headerView.hidden = NO;
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-no-r"] forState:UIControlStateNormal];
        self.selectAllBtn.selected = YES;
        [self selectAll:@""];
        
    }else{
        self.headerHeight.constant = 0;
        self.headerView.hidden = YES;
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - 删除
- (IBAction)delete:(id)sender {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (GLCollectModel *model in self.models) {
        if (model.isSelect) {
            [arr addObject:model];
        }
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除这些收藏吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteTheCollection:arr];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    if (arr.count > 0) {
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"未选中任何商品"];
        return;
    }
}

- (void)deleteTheCollection:(NSMutableArray *)selectArr{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (GLCollectModel *model in selectArr) {
        [arr addObject:model.goodsid];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"goodsid"] = [arr componentsJoinedByString:@","];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KDel_Collection_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.models removeObjectsInArray:selectArr];
            
            if (self.models.count == 0) {
                [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-no-r"] forState:UIControlStateNormal];
                self.selectAllBtn.selected = NO;
                self.editBtn.selected = YES;
                [self edit:self.editBtn];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLCollecteNOtification" object:nil];
            
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


#pragma mark - 全选
- (IBAction)selectAll:(id)sender {
    if (self.models.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"还未收藏商品"];
        return;
    }
    
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    
    if (self.selectAllBtn.selected) {
        
        [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-yes-r"] forState:UIControlStateNormal];
        for (GLCollectModel *model in self.models) {
            model.isSelect = YES;
            
        }
        
    }else{
        [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-no-r"] forState:UIControlStateNormal];
        
        for (GLCollectModel *model in self.models) {
            model.isSelect = NO;
        }
    }
    [self.tableView reloadData];
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
    GLCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCollectCell"];
    GLCollectModel *model = self.models[indexPath.row];
    
    model.isEdit = _isEdit;
    cell.model = model;
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLCollectModel *model = self.models[indexPath.row];
    model.isSelect = !model.isSelect;
    
    NSInteger selectNum = 0;
    
    for (GLCollectModel *model in self.models) {
        if (model.isSelect) {
            selectNum += 1;
        }
    }
    
    if (selectNum == self.models.count) {
        self.selectAllBtn.selected = YES;
        [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-yes-r"] forState:UIControlStateNormal];
    }else{
        self.selectAllBtn.selected = NO;
        [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-no-r"] forState:UIControlStateNormal];
    }
    
    
    [self.tableView reloadData];
}


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}
- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50 - 50);
        
    }
    return _nodataV;
}
@end
