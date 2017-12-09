//
//  GLMine_CardChooseController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CardChooseController.h"
#import "GLMine_CardCell.h"
#import "GLMine_AddCardController.h"
#import "GLMine_CardModel.h"

@interface GLMine_CardChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *models;
//@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_CardChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CardCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CardCell"];
//    [self.tableView addSubview:self.nodataV];
//    self.nodataV.hidden = YES;
    
    self.addBtn.layer.cornerRadius = 5.f;
    
    [self postRequest];
}

#pragma mark - 请求数据
- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_BankCard_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.models removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLMine_CardModel *model = [GLMine_CardModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 添加银行卡
- (IBAction)addBankCard:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddCardController *addVC = [[GLMine_AddCardController alloc] init];
    addVC.navigationItem.title = @"银行卡绑定";
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - UITableViewDelegate UITalbeViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CardCell"];
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_CardModel *model = self.models[indexPath.row];
    self.block(model.bank_name,model.bank_num,model.bank_id);
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 删除银行卡
/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak __typeof(self) weakSelf = self;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
//        Wallet_back_info *model = self.models[indexPath.row];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"token"] = [UserModel defaultUser].token;
//        dict[@"uid"] = [UserModel defaultUser].uid;
//        dict[@"bank_id"] = model.bank_id;
//
//        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//        [NetworkManager requestPOSTWithURLStr:kDEL_CARD_URL paramDic:dict finish:^(id responseObject) {
//
//            [_loadV removeloadview];
//
//            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
//                //发送通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBankCardNotification" object:nil userInfo:nil];
//
//                [weakSelf.models removeObjectAtIndex:indexPath.row];
//
//                //                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
//
//                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [MBProgressHUD showSuccess:@"删除银行卡成功!"];
//            }else{
//                [MBProgressHUD showError:responseObject[@"message"]];
//            }
//
//            //            [weakSelf.tableView reloadData];
//        } enError:^(NSError *error) {
//            [_loadV removeloadview];
//
//        }];
        
        
        
    }];
    
    return @[action1];
}

//- (void)deleteCard:(NSString *)bank_id index:(NSInteger)index {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = [UserModel defaultUser].token;
//    dict[@"uid"] = [UserModel defaultUser].uid;
//    dict[@"bank_id"] = bank_id;
//
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:kDEL_CARD_URL paramDic:dict finish:^(id responseObject) {
//
//        [_loadV removeloadview];
//
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
//            //发送通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBankCardNotification" object:nil userInfo:nil];
//
//            [self.models removeObjectAtIndex:index];
//
//            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [MBProgressHUD showSuccess:@"删除银行卡成功!"];
//        }else{
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//
//        [self.tableView reloadData];
//    } enError:^(NSError *error) {
//        [_loadV removeloadview];
//
//    }];
//}
#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
