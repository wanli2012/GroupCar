//
//  BasetabbarViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BasetabbarViewController.h"
#import "BaseNavigationViewController.h"


//#import "GLHomePageController.h"
#import "GLHomeController.h"

#import "GLClubController.h"
#import "GLMineController.h"

//#import "GLequipMentController.h"

#import "GLCollectController.h"
#import "LBLoginViewController.h"

@interface BasetabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation BasetabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate=self;
    [self addViewControllers];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(exitLogin) name:@"exitLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(shopingCar) name:@"shopingCar" object:nil];
    
}
//完善资料退出跳转登录
-(void)exitLogin{
    self.selectedIndex = 0;
}

- (void)addViewControllers {

    //首页
    GLHomeController *homeVC = [[GLHomeController alloc] init];
    BaseNavigationViewController *homeNav = [[BaseNavigationViewController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [self barTitle:@"商城" image:@"首页" selectImage:@"首页点中"];

//    商城
//    GLMallController *mallVC = [[GLMallController alloc] init];
//    BaseNavigationViewController *mallNav = [[BaseNavigationViewController alloc] initWithRootViewController:mallVC];
//    mallNav.tabBarItem = [self barTitle:@"我的" image:@"wd_icon" selectImage:@"wd_selected_icon"];

    GLCollectController *mallVC = [[GLCollectController alloc] init];
    BaseNavigationViewController *mallNav = [[BaseNavigationViewController alloc] initWithRootViewController:mallVC];
    mallNav.tabBarItem = [self barTitle:@"收藏" image:@"商城" selectImage:@"商城点中"];
    //俱乐部
    GLClubController *clubVC = [[GLClubController alloc] init];
    BaseNavigationViewController *clubNav = [[BaseNavigationViewController alloc] initWithRootViewController:clubVC];
    clubNav.tabBarItem = [self barTitle:@"俱乐部" image:@"俱乐部" selectImage:@"俱乐部点中"];
    
    //我的
    GLMineController *mineVC = [[GLMineController alloc] init];
    BaseNavigationViewController *mineNav = [[BaseNavigationViewController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [self barTitle:@"我的" image:@"我的" selectImage:@"我的点中"];
    
    
    self.viewControllers = @[homeNav,mallNav,clubNav, mineNav];
    
    self.selectedIndex=0;
    
}

- (UITabBarItem *)barTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    
    item.title = title;
    item.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : YYSRGBColor(102, 139, 255, 1)} forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -4);
    return item;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:1] || viewController == [tabBarController.viewControllers objectAtIndex:3]) {
       
        if ([UserModel defaultUser].loginstatus == YES) {
            return YES;
        }
        
        LBLoginViewController *loginVC = [[LBLoginViewController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
        
    }
    
    return YES;
}
//刷新界面
-(void)refreshInterface{
    
   [self.viewControllers reverseObjectEnumerator];
    [self addViewControllers];

}

- (void)pushToHome{
    
     self.selectedIndex = 0;
}

-(void)shopingCar{

    self.selectedIndex = 2;

}

@end
