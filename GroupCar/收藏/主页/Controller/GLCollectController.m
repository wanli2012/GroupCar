//
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

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView.hidden = YES;
    self.headerHeight.constant = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCollectCell" bundle:nil] forCellReuseIdentifier:@"GLCollectCell"];
    
    _isEdit = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark - 编辑
- (IBAction)edit:(UIButton *)sender {
    
    self.editBtn.selected = !self.editBtn.selected;
    
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
    
    _isEdit = !_isEdit;
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
        
        [self.models removeObjectsInArray:arr];
        
        if (self.models.count == 0) {
            [self.selectAllBtn setImage:[UIImage imageNamed:@"choice-no-r"] forState:UIControlStateNormal];
            self.selectAllBtn.selected = NO;
        }
        [self.tableView reloadData];
        
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
        for (int i = 0; i < 6; i ++) {
            GLCollectModel *model = [[GLCollectModel alloc] init];
            model.goodName = [NSString stringWithFormat:@"跑车%zd",i];
            model.price = [NSString stringWithFormat:@"100%zd",i];
            model.firstPrice = [NSString stringWithFormat:@"%zd",i];
            
            model.isSelect = NO;
            model.isEdit = NO;
            [_models addObject:model];
        }
    }
    return _models;
}

@end
