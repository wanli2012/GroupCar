//
//  LBMallCarListTableViewCell.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBMallCarListTableViewCell.h"
#import "LBSetFillet.h"

@implementation LBMallCarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.LogoImage.layer.mask = [LBSetFillet setFilletRoundedRect:self.LogoImage.bounds cornerRadii:CGSizeMake(self.LogoImage.frame.size.width/2.0, self.LogoImage.frame.size.width/2.0)];

}


@end
