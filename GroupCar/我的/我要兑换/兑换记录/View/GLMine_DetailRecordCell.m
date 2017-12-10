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
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@end

@implementation GLMine_DetailRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_RecordModel *)model{
    _model = model;
    
    NSString * timeStampString = model.addtime;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    
    self.dateLabel.text = [objDateformat stringFromDate:date];
    if ([model.backtype integerValue] == 1) {
        self.typeLabel.text = @"兑换余额";
    }else{
        self.typeLabel.text = @"兑换积分";
    }

    self.counterLabel.text = [NSString stringWithFormat:@"手续费:%@", model.counter];
    self.sumLabel.text = model.back_money;
    self.reasonLabel.text = [NSString stringWithFormat:@"失败原因:%@",model.reason];
    
    if (model.typeIndex == 1) {
        self.reasonLabel.hidden = YES;
        self.sumLabel.textColor = kMain_Color;
        self.counterLabel.hidden = NO;
    }else if(model.typeIndex == 2){
        self.reasonLabel.hidden = NO;
        self.sumLabel.textColor = [UIColor darkGrayColor];
        self.counterLabel.hidden = YES;
    }else if(model.typeIndex == 3){
        self.reasonLabel.hidden = NO;
        self.counterLabel.hidden = NO;
        self.sumLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
