//
//  GLMine_CardCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CardCell.h"

@interface GLMine_CardCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@end

@implementation GLMine_CardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height /2 ;
}


@end
