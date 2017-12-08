//
//  GLMine_DetailRecordCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_DetailRecordCell.h"

@interface GLMine_DetailRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@end

@implementation GLMine_DetailRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_RecordModel *)model{
    _model = model;
    
    self.dateLabel.text = model.date;
    self.typeLabel.text = model.type;
    self.sumLabel.text = model.sum;
    self.reasonLabel.text = [NSString stringWithFormat:@"失败原因:%@",model.reason];
    
    if (model.typeIndex == 1) {
        self.reasonLabel.hidden = YES;
        self.sumLabel.textColor = kMain_Color;
    }else{
        self.reasonLabel.hidden = NO;
        self.sumLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
