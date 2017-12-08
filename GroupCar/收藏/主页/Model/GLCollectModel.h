//
//  GLCollectModel.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCollectModel : NSObject

@property (nonatomic, copy)NSString *picName;
@property (nonatomic, copy)NSString *goodName;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *firstPrice;

@property (nonatomic, assign)BOOL isSelect;//是否被选中
@property (nonatomic, assign)BOOL isEdit;//是否处于编辑状态

@end
