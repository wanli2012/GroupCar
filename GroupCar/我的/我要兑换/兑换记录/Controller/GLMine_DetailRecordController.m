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
@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_DetailRecordController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_DetailRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_DetailRecordCell"];
    
}

#pragma mark - UITableViewDelegate UITalbeViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_DetailRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_DetailRecordCell"];
    cell.model = self.models[indexPath.row];
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == 1){
        return 65;
    }else{
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        return tableView.rowHeight;
    }
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i < 6; i ++) {
            GLMine_RecordModel *model = [[GLMine_RecordModel alloc] init];
            model.date = [NSString stringWithFormat:@"2017-09-0%zd",i];
            model.type = @"兑换积分";
            model.sum = [NSString stringWithFormat:@"21200%zd",i];
            model.reason = [NSString stringWithFormat:@"就不让你过,你要我啊"];
            model.typeIndex = self.type;
            [_models addObject:model];
        }
    }
    return _models;
}

@end
