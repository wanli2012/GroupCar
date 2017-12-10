//
//  GLCollectModel.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCollectModel : NSObject

@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_discount;
@property (nonatomic, copy)NSString *lowest;
@property (nonatomic, copy)NSString *thumb;
@property (nonatomic, copy)NSString *cid;

@property (nonatomic, assign)BOOL isSelect;//是否被选中
@property (nonatomic, assign)BOOL isEdit;//是否处于编辑状态

@end
