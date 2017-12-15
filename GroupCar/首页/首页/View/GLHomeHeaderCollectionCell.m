//
//  GLHomeHeaderCollectionCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeHeaderCollectionCell.h"

@interface GLHomeHeaderCollectionCell()


@end

@implementation GLHomeHeaderCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = (kSCREEN_WIDTH -60)/5/2;
    
    self.picImageV.layer.borderColor = kMain_Color.CGColor;
    self.picImageV.layer.borderWidth = 2.f;
    
}

@end
