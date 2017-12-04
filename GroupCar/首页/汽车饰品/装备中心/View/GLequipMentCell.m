//
//  GLequipMentCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLequipMentCell.h"

@interface GLequipMentCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GLequipMentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *str = @"积分:10000";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:11]
     
                          range:NSMakeRange(3, str.length - 3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(3, str.length - 3)];
    
    self.priceLabel.attributedText = AttributedStr;
}



@end
