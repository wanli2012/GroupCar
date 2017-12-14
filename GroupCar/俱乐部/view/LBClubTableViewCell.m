//
//  LBClubTableViewCell.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBClubTableViewCell.h"

@interface LBClubTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LBClubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setModel:(GLClubModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.event_img] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
//    self.titleLabel.text = model.event_title;
    
}


@end
