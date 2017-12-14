//
//  GLHomeHeaderView.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeHeaderView.h"
#import "GLHomeHeaderCollectionCell.h"
#import "GLHomeController.h"
#import "GLWebViewController.h"

@interface GLHomeHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIView *checkMoreView;

@end


@implementation GLHomeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self addSubview:self.cycleScrollView];

    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHomeHeaderCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHomeHeaderCollectionCell"];
    
    
    //设置公告view的阴影
    self.noticeView.layer.shadowOpacity = 0.5;// 阴影透明度
    
    self.noticeView.layer.shadowColor = kMain_Color.CGColor;// 阴影的颜色
    
    self.noticeView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    self.noticeView.layer.shadowOffset = CGSizeMake(0, 0);// 阴影的范围

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noticeDetail:)];
    [self.noticeView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap_more = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkMore)];
    [self.checkMoreView addGestureRecognizer:tap_more];
    
}

- (void)setCateModels:(NSArray<GLHome_CateModel *> *)cateModels{
    _cateModels = [NSMutableArray arrayWithArray:cateModels];
    GLHome_CateModel *model = [[GLHome_CateModel alloc] init];
    model.catename = @"更多";
    model.pic = [UIImage imageNamed:@"home_more"];
    
    if (_cateModels.count > 1) {
        
        [_cateModels addObject:model];
    }
    
    [self.collectionView reloadData];
    
}

- (void)setBannerModels:(NSArray<GLHome_bannerModel *> *)bannerModels{
    _bannerModels = bannerModels;
//    NSMutableArray *arrM = [NSMutableArray array];
//    
//    for (GLHome_bannerModel *model in self.bannerModels) {
//        NSString *imageurl = [NSString stringWithFormat:@"%@",model.banner_img];
//        [arrM addObject:imageurl];
//    }
//    
//    self.cycleScrollView.imageURLStringsGroup = arrM;

}

- (void)setNoticeDic:(NSDictionary *)noticeDic{
    _noticeDic = noticeDic;
    self.noticeLabel.text = noticeDic[@"title"];
}
#pragma mark - 查看更多
- (void)checkMore {
    [self viewController].hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CarListURL];
    
    webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&city_id=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,self.city_id];
    
    [[self viewController].navigationController pushViewController:webVC animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
}
#pragma mark - 公告详情
- (void)noticeDetail:(id)sender {
    [self viewController].hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_noticeDetailURL];
    
    webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id];
    
    [[self viewController].navigationController pushViewController:webVC animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
}

#pragma mark - SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//
//    GLBusinessAdModel *adModel = self.adModels[index];
//
//    self.hidesBottomBarWhenPushed = YES;
//
//    GLBusiness_CertificationController *adVC = [[GLBusiness_CertificationController alloc] init];
//    if([adModel.type integerValue] == 1){
//
//        adVC.navTitle = adModel.banner_title;
//        adVC.url = [NSString stringWithFormat:@"%@%@",AD_URL,adModel.banner_id];
//        [self.navigationController pushViewController:adVC animated:YES];
//
//    }else if([adModel.type integerValue] == 2){
//
//        GLMall_DetailController *detailVC = [[GLMall_DetailController alloc] init];
//        detailVC.goods_id = adModel.z_id;
//        [self.navigationController pushViewController:detailVC animated:YES];
//
//    }else if([adModel.type integerValue] == 3){
//
//        GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
//        detailVC.item_id = adModel.z_id;
//        [self.navigationController pushViewController:detailVC animated:YES];
//
//    }else{
//        //        adVC.navTitle = adModel.banner_title;
//        //        adVC.url = [NSString stringWithFormat:@"%@",adModel.url];
//        //        [self.navigationController pushViewController:adVC animated:YES];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adModel.url]];
//    }
//
//    self.hidesBottomBarWhenPushed = NO;
//}
//
///** 图片滚动回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
//
//}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cateModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_CateModel *model = self.cateModels[indexPath.row];
    
    GLHomeHeaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHomeHeaderCollectionCell" forIndexPath:indexPath];
    
    if (self.cateModels.count > 1) {
        
        if (indexPath.row == self.cateModels.count - 1) {
            cell.picImageV.image = [UIImage imageNamed:@"home_more"];
           
        }else{
            [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        }
    }else{
      [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    }
    
    cell.titleLabel.text = model.catename;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self viewController].hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    GLHome_CateModel *model = self.cateModels[indexPath.row];
    
    
    if (self.cateModels.count > 1) {
        
        if (indexPath.row == self.cateModels.count - 1) {
            NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_brandURL];
            webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&city_id=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,self.city_id];
        }else{
            
            NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CarListURL];
            webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&cate_id=%@&city_id=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,model.cate_id,self.city_id];
        }
    }else{
        NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CarListURL];
        webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&cate_id=%@&city_id=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,model.cate_id,self.city_id];
    }
    
    [[self viewController].navigationController pushViewController:webVC animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
}

- (GLHomeController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GLHomeController class]]) {
            return (GLHomeController *)nextResponder;
        }
    }
    return nil;
}


//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (kSCREEN_WIDTH -60)/5;
    CGFloat height = width + 20;
  
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 15, 10);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//-(SDCycleScrollView*)cycleScrollView
//{
//    if (!_cycleScrollView) {
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)
//                                                              delegate:self
//                                                      placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
//        
//        _cycleScrollView.localizationImageNamesGroup = @[[UIImage imageNamed:PlaceHolderImage],[UIImage imageNamed:PlaceHolderImage]];
//        _cycleScrollView.clipsToBounds = YES;
//        _cycleScrollView.autoScrollTimeInterval = 1;// 自动滚动时间间隔
//        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
//        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
//        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
//         _cycleScrollView.placeholderImage = [UIImage imageNamed:PlaceHolderImage];
//        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
//    }
//    
//    return _cycleScrollView;
//    
//}
@end
