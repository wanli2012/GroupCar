//
//  LBDownPaymentsTableViewCell.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBDownPaymentsTableViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBShowpayDetailCollectionViewCell.h"

@interface LBDownPaymentsTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *paymentsBt;
@property (weak, nonatomic) IBOutlet UIButton *numberBt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UIButton *detailBt;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong , nonatomic)NSArray *dataArr;
@property (assign , nonatomic)NSInteger buttonindex;//记录点击的哪个按钮

@property (assign , nonatomic)NSInteger payselectindex;//首付选中记录
@property (assign , nonatomic)NSInteger numselectindex;//期数选中记录

@property (weak, nonatomic) IBOutlet UILabel *paylabel;
@property (weak, nonatomic) IBOutlet UILabel *numlabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLb;


@end

@implementation LBDownPaymentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentW.constant = kSCREEN_WIDTH * 2;
    self.contentH.constant = 100;
    [self.paymentsBt horizontalCenterTitleAndImage:5];
    [self.numberBt horizontalCenterTitleAndImage:5];
    [self.detailBt horizontalCenterImageAndTitle:5];
    
    _payselectindex = -1;
    _numselectindex = -1;
    
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 25);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    self.collectionview.collectionViewLayout = layout;
    
     [self.collectionview registerNib:[UINib nibWithNibName:@"LBShowpayDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBShowpayDetailCollectionViewCell"];
    
}


#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBShowpayDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBShowpayDetailCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = self.dataArr[indexPath.row];
    cell.label.textColor = [UIColor darkGrayColor];
    
    if (_buttonindex == 1) {
        if (_payselectindex != -1 && indexPath.item == _payselectindex) {
            cell.label.textColor =YYSRGBColor(97, 88, 235, 1);
        }
    }else{
        if (_numselectindex != -1 && indexPath.item == _numselectindex) {
            cell.label.textColor =YYSRGBColor(97, 88, 235, 1);
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_buttonindex == 1) {
        _payselectindex = indexPath.item;
        self.paylabel.text = [NSString stringWithFormat:@"%@W",self.dataArr[indexPath.row]];
    }else{
        _numselectindex = indexPath.item;
    self.numlabel.text = [NSString stringWithFormat:@"%@W",self.dataArr[indexPath.row]];
    
    }
    
    [self.collectionview reloadData];//刷新
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];//返回
    
}


//首付
- (IBAction)paymentsEvent:(UIButton *)sender {
    _buttonindex = 1;
    
    self.dataArr = self.paydataArr;
    [self.collectionview reloadData];
    [self.detailBt setTitle:@"首付" forState:UIControlStateNormal];
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0) animated:YES];
}
//期数
- (IBAction)NumberOfPeriods:(UIButton *)sender {
     _buttonindex = 2;
    
    self.dataArr = self.numberdataArr;
    [self.collectionview reloadData];
    [self.detailBt setTitle:@"期数" forState:UIControlStateNormal];
     [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0) animated:YES];
}
//月供
- (IBAction)theMonthEvent:(id)sender {
}
- (IBAction)backEvent:(UIButton *)sender {
    
     [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr=[NSArray array];
    }
    return _dataArr;

}
@end
