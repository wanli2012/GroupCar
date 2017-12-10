//
//  GLMine_RecordModel.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_RecordModel : NSObject

@property (nonatomic, copy)NSString *addtime;//兑换时间
@property (nonatomic, copy)NSString *backtype;//兑换方式 1余额 2积分
@property (nonatomic, copy)NSString *back_money;//兑换金额
@property (nonatomic, copy)NSString *reason;//失败原因 type等于3返回
@property (nonatomic, copy)NSString *back_id;//兑换id
@property (nonatomic, copy)NSString *counter;//手续费

@property (nonatomic, assign)NSInteger typeIndex;//cell类型

@end
