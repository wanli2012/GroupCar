//
//  GLMall_GoodsDetailController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_GoodsDetailController.h"
#import "SDCycleScrollView.h"

@interface GLMall_GoodsDetailController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;//兑换按钮
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;//减号按钮
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//加号按钮
@property (weak, nonatomic) IBOutlet UILabel *countLabel;//数量Label

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong)UILabel *signLabel;//页码显示Label

@property (nonatomic, assign)NSInteger count;//商品数量

@end

@implementation GLMall_GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.exchangeBtn.layer.cornerRadius = 5.f;

    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;
    
    [self.contentView addSubview:self.cycleScrollView];
    
    self.count = 1;//设置默认数量为1
}

-(void)viewDidLayoutSubviews{
    self.scrollView.contentSize =CGSizeMake(0,500);
}

//增减数量
- (IBAction)changeCount:(UIButton *)sender {
    
    if (sender == self.reduceBtn) {//点击减号按钮
        if(self.count <= 0){
            self.count = 0;
            return;
        }
        
        self.count -= 1;
    }else{//点击加号按钮

        self.count += 1;
    }

    self.countLabel.text = [NSString stringWithFormat:@"%zd",self.count];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSString *str = [NSString stringWithFormat:@"%zd /4",index + 1];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:20]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(0, 1)];
    
    self.signLabel.attributedText = AttributedStr;

}

//兑换
- (IBAction)exchange:(id)sender {
    
    NSLog(@"兑换");
}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)
                                                                      delegate:self
                                                              placeholderImage:[UIImage imageNamed:@""]];
        
        _cycleScrollView.localizationImageNamesGroup = @[[UIImage imageNamed:@"timg"],[UIImage imageNamed:@"timg"],[UIImage imageNamed:@"timg"],[UIImage imageNamed:@"timg"]];
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        
        CGFloat viewWH = 50;
   
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_cycleScrollView.width - viewWH, _cycleScrollView.height - viewWH, viewWH, viewWH)];
        view.layer.cornerRadius = viewWH / 2;
        view.clipsToBounds = YES;
        view.backgroundColor = YYSRGBColor(51, 51, 51, 0.1);
        
        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        _signLabel.textColor = YYSRGBColor(104, 103, 238, 1);
        _signLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"1 /4"];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:20]
         
                              range:NSMakeRange(0, 1)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(0, 1)];
        
        _signLabel.attributedText = AttributedStr;

       
        [view addSubview:_signLabel];
        [_cycleScrollView addSubview:view];
        
    }
    
    return _cycleScrollView;
    
}


@end
