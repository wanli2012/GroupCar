//
//  BaseNavigationViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.barTintColor = YYSRGBColor(120, 161, 255, 1);
    self.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationBar.tintColor = YYSRGBColor(51, 51, 51, 1);

    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:YYSRGBColor(51, 51, 51, 1)}];
    
    
}

//+(void)initialize
//{
//    UINavigationBar *naBar = [UINavigationBar appearance];
//    naBar.tintColor = YYSRGBColor(230, 38, 7);
//    naBar.backgroundColor = YYSRGBColor(230, 38, 7);
//    naBar.translucent = NO;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSForegroundColorAttributeName] = YYSRGBColor(230, 38, 7);
//    [naBar setTitleTextAttributes:dict];
//}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // viewController.hidesBottomBarWhenPushed = YES; //隐藏底部标签栏
    
    [super pushViewController:viewController animated:animated];
    
    [self.visibleViewController.navigationItem setHidesBackButton:YES];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [button setImage:[UIImage imageNamed:@"f返回-"] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
//    [button setTitle:@"全部分类" forState:UIControlStateNormal];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
//    [button setTitleColor:YYSRGBColor(104, 103, 239, 1) forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐(UIControlContentHorizontalAlignment、CenterUIControlContentHorizontalAlignmentFill、UIControlContentHorizontalAlignmentRight)
\
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.visibleViewController.navigationItem.leftBarButtonItem = ba;
    
}

-(UIBarButtonItem*) createBackButton

{
    
    return [[UIBarButtonItem alloc]
            
            initWithTitle:@"返回"
            
            style:UIBarButtonItemStylePlain
            
            target:self 
            
            action:@selector(popself)];
    
}

-(void)popself

{
    
    [self popViewControllerAnimated:YES];
    
}

@end
