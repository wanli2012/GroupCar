//
//  GLHomePageController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomePageController.h"
#import "LBMallCarListTableViewCell.h"
#import "SDCycleScrollView.h"
#import "XBTextLoopView.h"
#import <Masonry/Masonry.h>
#import "LBAutoDetailsViewController.h"
#import "LBLoginViewController.h"

@interface GLHomePageController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//透视图
@property (weak, nonatomic) IBOutlet UIView *middleView;//中间View 类型选择
@property (weak, nonatomic) IBOutlet UIView *noticeView;//公告
@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *loopV;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)XBTextLoopView *loopView;
@property (nonatomic, strong)UILabel *signLabel;//页码显示Label
@end

@implementation GLHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBMallCarListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMallCarListTableViewCell"];
    
    [self setupUI];
    [self creatLoopView];//跑马灯
}

- (void)setupUI{
    
    [self.headerView addSubview:self.cycleScrollView];
    
    //设置公告view的阴影
    self.noticeView.layer.shadowOpacity = 0.5;// 阴影透明度
    
    self.noticeView.layer.shadowColor = kMain_Color.CGColor;// 阴影的颜色
    
    self.noticeView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    self.noticeView.layer.shadowOffset = CGSizeMake(0, 0);// 阴影的范围
    
    self.searchView.layer.cornerRadius = 5.f;
    
}
//跑马灯
-(void)creatLoopView{

    if (!self.loopView) {
        CGFloat h = self.loopV.frame.size.height;
        CGFloat w = self.loopV.frame.size.width;
        self.loopView = [XBTextLoopView textLoopViewWith:@[@"吕兵最帅😆1", @"吕兵还是最帅😆2", @"吕兵还是他妈最帅😆3",@"吕兵还是他妈最帅😆3吕兵还是他妈最帅😆3吕兵还是他妈最帅😆3"] loopInterval:3.0 initWithFrame:CGRectMake(0, 0, w, h) selectBlock:^(NSString *selectString, NSInteger index) {
            NSLog(@"%@===index%ld", selectString, (long)index);
        }];
    }
    [self.loopV addSubview:self.loopView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}
#pragma  mark - 搜索
- (IBAction)search:(id)sender {
    NSLog(@"搜索");
}

#pragma  mark - 新车
- (IBAction)newCar:(id)sender {
    NSLog(@"新车");
}
#pragma  mark - 二手车
- (IBAction)oldCar:(id)sender {
    NSLog(@"二手车");
}
#pragma  mark - 租车
- (IBAction)rentCar:(id)sender {
    NSLog(@"租车");
}


#pragma  mark - 点击图片回调
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSString *str = [NSString stringWithFormat:@"%zd/4",index + 1];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13]
     
                          range:NSMakeRange(0, 1)];
    
    self.signLabel.attributedText = AttributedStr;
    
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMallCarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMallCarListTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 330;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
          LBLoginViewController *vc =[[LBLoginViewController alloc]init];
         [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    LBAutoDetailsViewController *vc =[[LBAutoDetailsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 170)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@""]];
        
        _cycleScrollView.localizationImageNamesGroup = @[[UIImage imageNamed:@"timg"],[UIImage imageNamed:@"timg"],[UIImage imageNamed:@"timg"],[UIImage imageNamed:@"timg"]];
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        
        CGFloat viewWH = 30;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_cycleScrollView.width - viewWH - 10, _cycleScrollView.height - viewWH-5, viewWH, viewWH)];
        view.layer.cornerRadius = viewWH / 2;
        view.clipsToBounds = YES;
        view.backgroundColor = YYSRGBColor(51, 51, 51, 0.3);
        
        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        _signLabel.textColor = [UIColor whiteColor];
        _signLabel.textAlignment = NSTextAlignmentCenter;
        _signLabel.font = [UIFont systemFontOfSize:10];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"1/4"];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:13]
         
                              range:NSMakeRange(0, 1)];
        
        _signLabel.attributedText = AttributedStr;
        
        
        [view addSubview:_signLabel];
        [_cycleScrollView addSubview:view];
        
    }
    
    return _cycleScrollView;
    
}


@end
