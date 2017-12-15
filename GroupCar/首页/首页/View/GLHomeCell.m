//
//  GLHomeCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeCell.h"

@interface GLHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *downPaymentLabel;//首付
@property (weak, nonatomic) IBOutlet UIButton *collecteBtn;

@end

@implementation GLHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = [UIFont systemFontOfSize:11 * autoSizeScaleX];
    self.priceLabel.font = [UIFont systemFontOfSize:15 * autoSizeScaleX];
    
}

- (void)setModel:(GLHomeModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.goods_name;
    
    if ([model.goods_discount floatValue] > 10000000) {
        CGFloat discount = [model.goods_discount floatValue] / 10000000;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2fKW",discount];
        
    }else if([model.goods_discount floatValue] > 10000){
        
        CGFloat discount = [model.goods_discount floatValue] / 10000;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2fW",discount];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.goods_discount];
    }
    
    self.downPaymentLabel.text = [NSString stringWithFormat:@"首付:%@成",model.lowest];
    
    if([model.set integerValue] == 1){//1已收藏 2没收藏
        
        [self.collecteBtn setImage:[UIImage imageNamed:@"like-red"] forState:UIControlStateNormal];
    }else{
        [self.collecteBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)collecte:(id)sender {
    if ([self.delegate respondsToSelector:@selector(collecte:)]) {
        [self.delegate collecte:self.index];
    }
}

@end
