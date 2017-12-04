//
//  LBOutOfTheOrdinaryTableViewCell.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/8/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBOutOfTheOrdinaryTableViewCell.h"

@implementation LBOutOfTheOrdinaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.layer.cornerRadius = self.imageV.frame.size.width / 2;
    self.imageV.clipsToBounds = YES;
    self.bottomV.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
    
}
//立即兑换
- (IBAction)clickRedeemNow:(UIButton *)sender {
    
    [self.delegete clickExchangeNow:self.indexRow];
}

@end
