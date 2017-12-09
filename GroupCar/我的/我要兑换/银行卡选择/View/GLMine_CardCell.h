//
//  GLMine_CardCell.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_CardModel.h"

@interface GLMine_CardCell : UITableViewCell

@property (nonatomic, strong)GLMine_CardModel *model;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
