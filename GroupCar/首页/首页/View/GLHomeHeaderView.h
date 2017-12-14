//
//  GLHomeHeaderView.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SDCycleScrollView.h"
#import "GLHomeModel.h"

//@protocol GLHomeHeaderViewDelegate <NSObject>
//
//- (void)brandList:(NSInteger)index;
//
//@end

@interface GLHomeHeaderView : UICollectionReusableView

//@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong)NSArray <GLHome_bannerModel *>*bannerModels;
@property (nonatomic, strong)NSMutableArray <GLHome_CateModel *>*cateModels;
@property (nonatomic, strong)NSDictionary *noticeDic;

@property (nonatomic, copy)NSString *city_id;

//@property (nonatomic, weak)id <GLHomeHeaderViewDelegate>delegate;


@end
