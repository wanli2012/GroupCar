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

    self.navigationBar.barTintColor = [UIColor whiteColor];

    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:YYSRGBColor(51, 51, 51, 1)}];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // viewController.hidesBottomBarWhenPushed = YES; //隐藏底部标签栏
    
    [super pushViewController:viewController animated:animated];
    
    [self.visibleViewController.navigationItem setHidesBackButton:YES];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 44)];
    [button setImage:[UIImage imageNamed:@"f返回-"] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐(UIControlContentHorizontalAlignment、CenterUIControlContentHorizontalAlignmentFill、UIControlContentHorizontalAlignmentRight)
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.visibleViewController.navigationItem.leftBarButtonItem = ba;

    [self setDisplayCustomTitleText:viewController.navigationItem.title];
    
}
- (void)setDisplayCustomTitleText:(NSString*)text

{
    // Init views with rects with height and y pos
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    // Use autoresizing to restrict the bounds to the area that the titleview allows
    
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    titleView.autoresizesSubviews = YES;
    
    titleView.backgroundColor = [UIColor  clearColor];
    titleView.userInteractionEnabled = YES;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
//    titleLabel.tag = kUIVIEWCONTROLLER_LABEL_TAG;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
//    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    titleLabel.textColor = YYSRGBColor(111, 110, 237, 1);
    
    titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    titleLabel.userInteractionEnabled = YES;
    
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popself)];
    [titleLabel addGestureRecognizer:tap];
    
    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    
    CGRect frame;
    
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    
    maxWidth += 5;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
    
    frame = titleLabel.frame;
    
    frame.size.width = 150;
    
    titleLabel.frame = frame;
    
    frame = titleView.frame;
    
    frame.size.width = 320 - maxWidth * 2;
    
    titleView.frame = frame;
    
    // Set the text
    
    titleLabel.text = text;
    
    // Add as the nav bar's titleview
    
    [titleView addSubview:titleLabel];
    
    self.visibleViewController.navigationItem.titleView = titleView;
    
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
