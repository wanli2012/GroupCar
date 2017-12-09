//
//  GLMine_AchieveCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AchieveCell.h"

@interface GLMine_AchieveCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation GLMine_AchieveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_AchieveModel *)model{
    _model = model;
    
    NSString * timeStampString = model.addtime;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];

    
    self.dateLabel.text = [objDateformat stringFromDate: date];
    self.accountLabel.text = model.uname;
    self.moneyLabel.text = model.money;
    self.jifenLabel.text = model.mark;
}
@end
