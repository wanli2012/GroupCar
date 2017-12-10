//
//  GLCollectCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCollectCell.h"

@interface GLCollectCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeading;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//是否选中图片

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//商品名
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;//首付

@end

@implementation GLCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLCollectModel *)model{
    _model = model;
    self.titleLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"价格:%@",model.goods_discount];
    self.paymentLabel.text = [NSString stringWithFormat:@"%@成",model.lowest];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if (model.isEdit) {
        self.signImageV.hidden = NO;
        self.imageLeading.constant = 40;
        self.lineLeading.constant = 40;
        self.signImageV.image = [UIImage imageNamed:@"choice-no-r"];
        
        if (model.isSelect) {
            self.signImageV.image = [UIImage imageNamed:@"choice-yes-r"];
        }else{
            self.signImageV.image = [UIImage imageNamed:@"choice-no-r"];
        }
        
    }else{
        self.signImageV.hidden = YES;
        self.imageLeading.constant = 10;
        self.lineLeading.constant = 10;
    }
    
    
}

@end
