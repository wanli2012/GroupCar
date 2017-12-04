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

#define GLOBAL_COLOR YYSRGBColor(104, 103, 238 , 1.0) //主颜色

#define autoSizeScaleX (kSCREEN_WIDTH/320.f)
#define autoSizeScaleY (kSCREEN_HEIGHT/568.f)

#define FONT(s)       [UIFont systemFontOfSize:s]


#endif /* Const_h */
