//
//  GLMine_PersonInfoModel.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_PersonInfoModel : NSObject

@property (nonatomic, copy)NSString *portrait;//用户头像
@property (nonatomic, copy)NSString *nickname;//用户昵称
@property (nonatomic, copy)NSString *uname;//用户ID
@property (nonatomic, copy)NSString *gname;//推荐人ID
@property (nonatomic, copy)NSString *gnickname;//推荐人昵称

@end
