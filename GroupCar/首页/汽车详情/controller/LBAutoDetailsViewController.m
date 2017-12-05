//
//  LBAutoDetailsViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBAutoDetailsViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LBAutoDetailinfoTableViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBDownPaymentsTableViewCell.h"
#import "LBAutoDetailSectionHeaderView.h"

@interface LBAutoDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)UILabel *signLabel;//页码显示Label
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBAutoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableHeaderView = self.cycleScrollView;
    [self registerTableviewcell];//注册
    
}

-(void)registerTableviewcell{
    [self.tableview registerNib:[UINib nibWithNibName:@"LBAutoDetailinfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBAutoDetailinfoTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDownPaymentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBDownPaymentsTableViewCell"];
 
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
          return 2;
    }else if (section == 1){
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LBAutoDetailinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBAutoDetailinfoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.collectionBt verticalCenterImageAndTitle:10];
            return cell;
        }else{
            LBDownPaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDownPaymentsTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.paydataArr = @[@"1",@"1000",@"sc"];
            cell.numberdataArr = @[@"3",@"3000",@"22",@"3",@"3000",@"22",@"3",@"3000",@"22"];
            
            return cell;
        }
    }else{
    
    
    }
   
    return [[UITableViewCell alloc]init];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            tableView.estimatedRowHeight = 138;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            return 110;
        }
    }else{
    
    
    }
    
    return 0;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 1) {
        LBAutoDetailSectionHeaderView *headV = [[NSBundle mainBundle] loadNibNamed:@"LBAutoDetailSectionHeaderView" owner:nil options:nil].lastObject;
        return headV;
    }
    
    return nil;
}

#pragma  mark 点击图片回调
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

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 250)
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


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
@end
