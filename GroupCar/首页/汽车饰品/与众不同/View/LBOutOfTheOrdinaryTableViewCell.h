//
//  LBOutOfTheOrdinaryTableViewCell.h
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/8/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OutOfTheOrdinaryDelegete <NSObject>

- (void)clickExchangeNow:(NSInteger)row;

@end

@interface LBOutOfTheOrdinaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (assign, nonatomic)id<OutOfTheOrdinaryDelegete> delegete;
@property (assign, nonatomic)NSInteger indexRow;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@end
