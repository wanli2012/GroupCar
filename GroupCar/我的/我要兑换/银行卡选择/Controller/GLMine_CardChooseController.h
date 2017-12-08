//
//  GLMine_CardChooseController.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cardChooseBlock)(NSString *bankName,NSString *bankNum,NSString *bank_id);

@interface GLMine_CardChooseController : UIViewController

@property (nonatomic, copy)cardChooseBlock block;

@end
