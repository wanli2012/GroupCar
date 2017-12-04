//
//  GLequipMentController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLequipMentController.h"
#import "GLequipMentCell.h"
#import "GLequipmentHeaderView.h"
#import "GLequipMentSectionHeader.h"
#import "FJWaterfallFlowLayout.h"
#import "LBOutOfTheOrdinaryViewController.h"
#import "LBHotRecommendationViewController.h"

@interface GLequipMentController ()<UICollectionViewDelegate,UICollectionViewDataSource,FJWaterfallFlowLayoutDelegate,GLequipMentHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GLequipMentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"装备中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    FJWaterfallFlowLayout *fjWaterfallFlowLayout = [[FJWaterfallFlowLayout alloc] init];
    fjWaterfallFlowLayout.itemSpacing = 10;
    fjWaterfallFlowLayout.lineSpacing = 10;
    fjWaterfallFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    fjWaterfallFlowLayout.colCount = 2;
    fjWaterfallFlowLayout.delegate = self;
    
    self.collectionView.collectionViewLayout = fjWaterfallFlowLayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLequipMentCell" bundle:nil] forCellWithReuseIdentifier:@"GLequipMentCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLequipMentHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLequipMentHeaderView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLequipMentSectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLequipMentSectionHeader"];
    
}
#pragma mark GLequipMentHeaderViewDelegate

- (void)jumpTo:(NSInteger)index{
    switch (index) {
        case 10://热门推荐
        {
            self.hidesBottomBarWhenPushed = YES;
            LBHotRecommendationViewController *vc=[[LBHotRecommendationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 11://爱车必备
        {
            NSLog(@"爱车必备");
        }
            break;
        case 12://与众不同
        {
            self.hidesBottomBarWhenPushed = YES;
            LBOutOfTheOrdinaryViewController *vc=[[LBOutOfTheOrdinaryViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13://全部分类
        {
            NSLog(@"全部分类");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark FJWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath
{
   
    CGFloat multiple = (CGFloat)300/365;
    CGFloat multiple2 = (CGFloat)260/365;
    
    if(indexPath.section == 0){
        
        if (indexPath.row == 0) {
            return multiple * width;
        }else{
            return (multiple * width - 10)/2;
        }
    }else{
        return multiple2 * width;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return CGSizeMake(kSCREEN_WIDTH, 160);
    }else{
        return CGSizeMake(kSCREEN_WIDTH, 70);
    }
}

#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 3;
    }else{
        
        return 4;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLequipMentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLequipMentCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.bottomView.hidden = YES;
    }
    
    return cell;
    
}

//返回headerView
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GLequipMentHeaderView *headerView;
    GLequipMentSectionHeader *sectionHeader;
    
    if (indexPath.section == 0) {
        
        if (!headerView) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLequipMentHeaderView" forIndexPath:indexPath];
            headerView.delegate = self;
        }
        
        return headerView;
        
    }else{
        
        if (!sectionHeader) {
            sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLequipMentSectionHeader" forIndexPath:indexPath];
            
        }
        return sectionHeader;
    }

}

@end
