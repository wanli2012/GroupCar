//
//  Const.h
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#ifndef Const_h
#define Const_h

#define kSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define YYSRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define TABBARTITLE_COLOR YYSRGBColor(120, 161, 255 , 1.0) //导航栏颜色

#define kMain_Color YYSRGBColor(111, 110, 238 , 1.0) //主颜色

#define autoSizeScaleX (kSCREEN_WIDTH/320.f)
#define autoSizeScaleY (kSCREEN_HEIGHT/568.f)

#define FONT(s)  [UIFont systemFontOfSize:s]

#define SUCCESS_CODE 104
#define PAGE_ERROR_CODE 108
#define ERROR_CODE 106
#define OVERDUE_CODE 102
#define LOGIC_ERROR_CODE 101
#define STOP_CODE 107
#define INPUT_CODE 103
#define NO_LOGIN_CODE 105
#define LOGIN_SUCCESS_CODE 100
#define NO_ACCOUNT_CODE 109


#define USHARE_APPKEY @"59a772c965b6d60e730002a1"
#define WEIXIN_APPKEY @"wx3719a66cd8983420"

#define WEIXIN_APPSECRET @"4fae7202764cda777d88c9515b5ca24e"


//占位图
#define PlaceHolderImage @"爱车"

#define Share_URL @"http://www.baidu.com"

#define BaseURL @"http://192.168.0.149/car/App/"
#define KRegister @"User/PartnerRegister" //注册
#define KGet_Code_Interface @"User/PartneVerificationCode"//验证码
#define KLogin_Interface @"User/PartnerLogin" //登录
#define KUserPerfect_Interface @"User/PartnerUserPerfect" //微信登录完善信息手机号验证接口
#define KChangePassword_Interface @"User/PartnerCryptogram"//用户修改密码 忘记密码修改
#define KSetSecond_Password_Interface @"User/PartnerUserPay"//用户设置二级密码
#define KChange_Phone_Interface @"User/ParterUserPhone"//用户更改账户手机号
#define KTrueName_Interface @"User/PartnerUserTruename"//用户实名认证
#define KInfoChange_Interface @"User/PartnerInformation"//用户个人信息修改
#define KMyInfo_Interface @"User/PartnerUser"//我的信息
#define KAchievement_Interface @"User/PartnerUserAchievement"//用户业绩
#define KJifen_Exchange_Interface @"User/PartnerUserConvertibility"//用户积分兑换
#define KMoney_Exchange_Interface @"User/PartnerUserRemainingSum"//余额兑换
#define KGet_BankCard_Interface @"User/PartnerUserBank"//获取用户的银行卡
#define KAdd_bankCard_Interface @"User/PartnerUserAddBank"//用户添加银行卡
#define KGet_BankName_Interface @"Deploy/Bank"//获取银行
#define KExchange_Record_Interface @"User/PartnerUserEcRecord"//用户兑换记录
#define KDel_Message_Interface @"User/PartnerUserMessageDel"//删除消息
#define KMessage_Interface @"User/PartnerUserMessageCenter"//消息中心
#define KGet_Delegate_Interface @"User/PartnerUserAgencyAgreement"//用户成为代理获取协议
#define KGet_Club_Activity_Interface @"Deploy/ClubActivities"//获取俱乐部活动
#define KGet_Collection_Interface @"User/PartnerUserCollection"//获取我的收藏
#define KDel_Collection_Interface @"User/PartnerUserCollectionDel"//删除收藏

#endif /* Const_h */
