//
//  LBAutoDetailSectionHeaderView.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBAutoDetailSectionHeaderView.h"

@interface LBAutoDetailSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *carBt;
@property (weak, nonatomic) IBOutlet UIButton *infoBt;
@property (weak, nonatomic) IBOutlet UIButton *ruleBt;

@property (strong , nonatomic)UIView *strokeView;

@end

@implementation LBAutoDetailSectionHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.buttonView addSubview:self.strokeView];

}

- (IBAction)carParameter:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _strokeView.frame = CGRectMake(0, 48,kSCREEN_WIDTH/3.0, 2);
    }];
    self.carBt.selected = YES;
    self.infoBt.selected = NO;
    self.ruleBt.selected = NO;
    
}
- (IBAction)DetailedConfiguration:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
       _strokeView.frame = CGRectMake(kSCREEN_WIDTH/3.0, 48,kSCREEN_WIDTH/3.0, 2);
    }];
    
    self.carBt.selected = NO;
    self.infoBt.selected = YES;
    self.ruleBt.selected = NO;
    
}
- (IBAction)purchaseRule:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _strokeView.frame = CGRectMake(kSCREEN_WIDTH/3.0 * 2, 48,kSCREEN_WIDTH/3.0, 2);
    }];
    self.carBt.selected = NO;
    self.infoBt.selected = NO;
    self.ruleBt.selected = YES;
    
}

-(UIView*)strokeView{

    if (!_strokeView) {
        _strokeView = [[UIView alloc]initWithFrame:CGRectMake(0, 48,kSCREEN_WIDTH/3.0, 2)];
        _strokeView.backgroundColor = YYSRGBColor(58, 44, 233, 1);
    }

    return _strokeView;
}

@end
