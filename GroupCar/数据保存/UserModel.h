//
//  UserModel.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>
@property (nonatomic, assign) BOOL needAutoLogin;

@property (nonatomic, assign)BOOL   loginstatus;//登陆状态

@property (nonatomic, copy)NSString  *group;//用户身份类型
@property (nonatomic, copy)NSString  *mark;//用户积分
@property (nonatomic, copy)NSString  *money;//用户金额
@property (nonatomic, copy)NSString  *nickname;//昵称
@property (nonatomic, copy)NSString  *phone;//手机号
@property (nonatomic, copy)NSString  *portrait;//用户头像
@property (nonatomic, copy)NSString  *status;//用户是否实名认证 1未认证 2已认证
@property (nonatomic, copy)NSString  *token;//用户令牌 ras加密
@property (nonatomic, copy)NSString  *uname;//用户平台分配账号
@property (nonatomic, copy)NSString  *user_id;//用户id ras加密



+(UserModel*)defaultUser;

@end
