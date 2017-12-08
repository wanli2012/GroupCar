//
//  GLMine_RecordModel.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_RecordModel : NSObject

@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *sum;
@property (nonatomic, copy)NSString *reason;

@property (nonatomic, assign)NSInteger typeIndex;

@end
