//
//  MineCollectionHeaderV.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "MineCollectionHeaderV.h"
#import <Masonry/Masonry.h>
#import "UIButton+SetEdgeInsets.h"
#import "LBNearby_classifyItemView.h"
#import "LBSetFillet.h"

@interface MineCollectionHeaderV ()<UIScrollViewDelegate>

@property(nonatomic , strong) NSArray *dataArr;
@property (assign, nonatomic)NSInteger SCR_conW;

@end

@implementation MineCollectionHeaderV


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         self.SCR_conW = kSCREEN_WIDTH ;
        [self loadUI];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
    
}

-(void)loadUI{

    _scorllView = [[UIScrollView alloc] init];
    _scorllView.pagingEnabled = YES;
    _scorllView.showsHorizontalScrollIndicator = NO;
    _scorllView.showsVerticalScrollIndicator = NO;
    _scorllView.delegate = self;
    _scorllView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scorllView];
    
    [_scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    _scorllView.contentSize = CGSizeMake(kSCREEN_WIDTH , _scorllView.frame.size.height);
    
    [self initdatasorece:self.dataArr];

}

-(void)initdatasorece:(NSArray*)dataArr{
    
    [self.scorllView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger itemW = 45 * autoSizeScaleX ; //每个分类的宽度
    NSInteger itemH = itemW + 20; // 每个分类的高度
    NSInteger num = 5 ;//每行展示多少个分类
    NSInteger padding_x = 10 ;//第  一个距离边界多少px
    NSInteger padding_top = 5 ;//距离顶部多少px
    NSInteger padding_y = 10 ;//item之间多少px
    NSInteger item_dis = (self.SCR_conW - padding_x * 2 - num * itemW) / (num - 1);
    
    for (int i = 0 ; i < dataArr.count; i++) {
        
        LBNearby_classifyItemView *item = [[NSBundle mainBundle]loadNibNamed:@"LBNearby_classifyItemView" owner:nil options:nil].firstObject;
        

        int  V = i / num;
        int  H = i % num;
        NSInteger sep = self.SCR_conW * (i / 10);
        
        item.tag = 10 + i;
        item.frame = CGRectMake(sep + padding_x + (itemW + item_dis) * H, padding_x + padding_top + (padding_y + itemH) * (V % 2), itemW , itemH);
        item.autoresizingMask = UIViewAutoresizingNone;
        item.backgroundColor = [UIColor clearColor];
        item.titleLb.text = dataArr[i][@"name"];
        item.imagev.image = [UIImage imageNamed:self.dataArr[i][@"thumb"]];;
        item.titleLb.font = [UIFont systemFontOfSize:10 * autoSizeScaleX];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureClassfty:)];
        [item addGestureRecognizer:tapgesture];
        [_scorllView addSubview:item];
        
    }
    
}

-(void)tapgestureClassfty:(UITapGestureRecognizer*)tap{

    
}

-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"name":@"大众",@"thumb":@"大众"},
                     @{@"name":@"法拉利",@"thumb":@"falali-2"},
                     @{@"name":@"丰田",@"thumb":@"丰田"},
                     @{@"name":@"奔驰",@"thumb":@"奔驰"},
                     @{@"name":@"宝马",@"thumb":@"宝马"},
                     @{@"name":@"别克",@"thumb":@"别克"},
                     @{@"name":@"名爵",@"thumb":@"名爵"},
                     @{@"name":@"起亚",@"thumb":@"qiya-2"},
                     @{@"name":@"现代",@"thumb":@"大众"},
                     @{@"name":@"更多",@"thumb":@"MORE"},
                     ];
    }
    
    return _dataArr;

}

@end
