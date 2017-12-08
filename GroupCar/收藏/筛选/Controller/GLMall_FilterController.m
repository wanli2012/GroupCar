//
//  GLMall_FilterController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_FilterController.h"
#import "GLequipMentCell.h"
//#import "DropDownMenuView.h"
#import "GLMall_GoodsDetailController.h"

@interface GLMall_FilterController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *sortBtn;//智能排序
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;//价格
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;//类型
@property (weak, nonatomic) IBOutlet UIButton *defaultSort;//默认排序

//@property (strong, nonatomic)UIView *maskView;
//@property (strong, nonatomic)DropDownMenuView *dropDownMenuView;

@end

@implementation GLMall_FilterController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"全部分类";
    [self.collectionView setContentInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLequipMentCell" bundle:nil] forCellWithReuseIdentifier:@"GLequipMentCell"];
    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDismiss)];
//    [self.maskView addGestureRecognizer:tap];
    
}

- (IBAction)filter:(UIButton *)sender {
    
    if(sender == self.sortBtn){
        NSLog(@"智能排序");
    }else if(sender == self.priceBtn){
        NSLog(@"价格");
    }else if (sender == self.typeBtn){
        NSLog(@"类型");
    }else if(sender == self.defaultSort){
        NSLog(@"默认排序");
    }

}
//点击maskview
-(void)maskDismiss{
    
    [UIView animateWithDuration:0.2 animations:^{

    } completion:^(BOOL finished) {

        
    }];
    
}
#pragma mark UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLequipMentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLequipMentCell" forIndexPath:indexPath];
    
    return cell;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (CGFloat)(kSCREEN_WIDTH - 30)/2;
    CGFloat height = (CGFloat)260 /336 * width;
    
    return CGSizeMake(width, height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMall_GoodsDetailController *detailVC = [[GLMall_GoodsDetailController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
//-(UIView*)maskView{
//    
//    if (!_maskView) {
//        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        _maskView.backgroundColor=[UIColor clearColor];
//    }
//    
//    return _maskView;
//    
//}
//-(DropDownMenuView*)dropDownMenuView{
//    
//    if (!_dropDownMenuView) {
//        _dropDownMenuView=[[NSBundle mainBundle]loadNibNamed:@"DropDownMenuView" owner:self options:nil].firstObject;
//        
//        _dropDownMenuView.layer.cornerRadius = 10.f;
//        _dropDownMenuView.clipsToBounds = YES;
//        _dropDownMenuView.frame = CGRectMake(0, 104, kSCREEN_WIDTH, 0);
//        
//        _dropDownMenuView.dataSoure  = @[@"会员",@"商家",@"创客",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心",@"省级行业服务中心",@"市级行业服务中心"];
//        
//    }
//    
//    return _dropDownMenuView;
//    
//}
@end
