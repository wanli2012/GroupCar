//
//  GLMine_MessageController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MessageController.h"
#import "GLMine_MessageCell.h"

@interface GLMine_MessageController ()<UITableViewDelegate,UITableViewDataSource,GLMine_MessageCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MessageCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MessageCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    //设置导航栏
    [self setNav];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 设置导航栏
- (void)setNav{
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [right setTitle:@"清空" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [right.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [right addTarget:self action:@selector(delAll) forControlEvents:UIControlEventTouchUpInside];
    
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    [right setTitleEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    right.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}
#pragma mark - 清空全部消息
- (void)delAll {
    
    if(self.models.count == 0){
        [SVProgressHUD showErrorWithStatus:@"没有消息可以清空了"];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定清空消息？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController removeFromParentViewController];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"2";//1单条消息清除 2全部消息清除
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KDel_Message_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
          
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
         
            [self.models removeAllObjects];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
//    dict[@"type"] = @"1";
    dict[@"page"] = @(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:KMessage_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                if(isRefresh){
                    [self.models removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_MessageModel * model = [GLMine_MessageModel mj_objectWithKeyValues:dic];

                    [self.models addObject:model];
                }
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

#pragma mark - 删除消息
- (void)deleteTheMessage:(NSInteger)index{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该消息？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController removeFromParentViewController];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        GLMine_MessageModel *model = self.models[index];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].user_id;
        dict[@"type"] = @"1";//1单条消息清除 2全部消息清除
        dict[@"logid"] = model.id;
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:KDel_Message_Interface paramDic:dict finish:^(id responseObject) {

            [_loadV removeloadview];

            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){

                [self.models removeObjectAtIndex:index];

                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];

                [self.tableView reloadData];
            }else{

                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }

        } enError:^(NSError *error) {
            [_loadV removeloadview];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    GLMine_MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MessageCell"];
    cell.model = self.models[indexPath.row];
    
    cell.delegate = self;
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return tableView.rowHeight;
}

#pragma mark - 左滑删除功能
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
//            GLMine_MessageModel *model = self.models[indexPath.row];
//
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"token"] = [UserModel defaultUser].token;
//            dict[@"uid"] = [UserModel defaultUser].user_id;
//            dict[@"type"] = @"1";//1单条消息清除 2全部消息清除
//
//            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//            [NetworkManager requestPOSTWithURLStr:KDel_Message_Interface paramDic:dict finish:^(id responseObject) {
//                
//                [_loadV removeloadview];
//
//                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
//
//                    [self.models removeObjectAtIndex:indexPath.row];
//
//                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//
//                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }else{
//
//                   [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//                }
//
//            } enError:^(NSError *error) {
//                [_loadV removeloadview];
//            }];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
