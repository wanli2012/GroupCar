//
//  LBMallHomepageViewController.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBMallHomepageViewController.h"
#import "MineCollectionHeaderV.h"
#import "GLequipMentCell.h"
#import "GLNearby_SectionHeaderView.h"
#import "LBMallHomePageSectionHeader.h"
#import "LBActivityAreaCollectionViewCell.h"
#import "LBHotRecomendCollectionViewCell.h"

#define sizeScaleActivity  (273/361.0)
#define sizeScaleHot  (254/353.0)

@interface LBMallHomepageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LBMallHomePageSectionHeaderDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic)MineCollectionHeaderV *mineCollectionHeaderV;
@property (strong, nonatomic)LBMallHomePageSectionHeader *mallHomePageSectionHeader;

@end

@implementation LBMallHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCollectionView];//注册
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //[flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    //[flowLayout setHeaderReferenceSize:CGSizeMake(kSCREEN_WIDTH,  170)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.0];
    [flowLayout setMinimumLineSpacing:0.0];
    self.collectionview.collectionViewLayout = flowLayout;
}

-(void)registerCollectionView{
    // 注册表头
    [self.collectionview registerClass:[MineCollectionHeaderV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MineCollectionHeaderV"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"LBMallHomePageSectionHeader" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBMallHomePageSectionHeader"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"LBActivityAreaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBActivityAreaCollectionViewCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"LBHotRecomendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBHotRecomendCollectionViewCell"];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
#pragma mark - LBMallHomePageSectionHeaderDelegate 查看更多
- (void)more:(NSInteger)index{
    switch (index) {
        case 0:
        {
            NSLog(@"---------");
        }
            break;
        case 1:
        {
            NSLog(@"活动专区 ---- 更多");
        }
            break;
        case 2:
        {
            NSLog(@"热门推荐 ---- 更多");
        }
            break;
            
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return  0;
    }else if (section == 1){
    return 1;
    }
        return 10;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
  if (indexPath.section == 1){
        LBActivityAreaCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBActivityAreaCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor whiteColor];
      return cell;
    }else if (indexPath.section == 2){
        LBHotRecomendCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBHotRecomendCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
    }

    return [[UICollectionViewCell alloc]init];
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1){
       return CGSizeMake(kSCREEN_WIDTH , ((kSCREEN_WIDTH)/2 - 5) * sizeScaleActivity);
    }else if (indexPath.section == 2){
       return CGSizeMake(((kSCREEN_WIDTH)/2.0 - 5), ((kSCREEN_WIDTH)/2 - 5) * sizeScaleHot + 50);
    }
    return CGSizeMake(0, 0);
}

//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
            _mineCollectionHeaderV = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"MineCollectionHeaderV"
                                                                               forIndexPath:indexPath];
        return _mineCollectionHeaderV;
    }else {

            _mallHomePageSectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"LBMallHomePageSectionHeader"
                                                                               forIndexPath:indexPath];
        _mallHomePageSectionHeader.delegate = self;
        _mallHomePageSectionHeader.section = indexPath.section;
        
        if(indexPath.section == 1){
            
            _mallHomePageSectionHeader.titleLabel.text = @"活动专区";
        }else if(indexPath.section == 2){
            _mallHomePageSectionHeader.titleLabel.text = @"热门推荐";
        }
        
        return _mallHomePageSectionHeader;
    
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return CGSizeMake(kSCREEN_WIDTH,  170);
    }else{
        return CGSizeMake(kSCREEN_WIDTH,  50);
    }

}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


@end
