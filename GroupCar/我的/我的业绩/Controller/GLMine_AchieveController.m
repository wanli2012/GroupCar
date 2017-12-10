//
//  GLMine_AchieveController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AchieveController.h"
#import "GLMine_ShareAchieveController.h"//分享业绩
#import "GLMine_DelegteAchieveController.h"//代理业绩

@interface GLMine_AchieveController ()

@end

@implementation GLMine_AchieveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hidesBottomBarWhenPushed=YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:40])
    {
        self.yFloat = 0;
        [self addviewcontrol];
    }
    return self;
}

-(void)addviewcontrol{
    
    NSArray *titleArray = @[@"分享奖励",
                            @"代理奖励",
                            ];
    NSArray *classNames = @[
                            [GLMine_ShareAchieveController class],
                            [GLMine_DelegteAchieveController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = kMain_Color;
    self.selectedIndicatorColor = kMain_Color;

    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / titleArray.count, 40);
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
}

@end
