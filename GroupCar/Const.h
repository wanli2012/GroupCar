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

#define GLOBAL_COLOR YYSRGBColor(111, 110, 238 , 1.0) //主颜色

#define autoSizeScaleX (kSCREEN_WIDTH/320.f)
#define autoSizeScaleY (kSCREEN_HEIGHT/568.f)

#define FONT(s)       [UIFont systemFontOfSize:s]

#define SUCCESS_CODE 104
#define PAGE_ERROR_CODE 108
#define ERROR_CODE 106
#define OVERDUE_CODE 102
#define LOGIC_ERROR_CODE 101
#define STOP_CODE 107
#define INPUT_CODE 103
#define NO_LOGIN_CODE 105
#define LOGIN_SUCCESS_CODE 100




#define BaseURL @"http://192.168.0.149/car/App/User"
#define KRegister @"User/PartnerRegister"

#endif /* Const_h */
