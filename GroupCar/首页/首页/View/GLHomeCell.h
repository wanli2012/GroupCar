//
//  GLHomeCell.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHomeModel.h"

@protocol GLHomeCellDelegate <NSObject>

- (void)collecte:(NSInteger)index;

@end


@interface GLHomeCell : UICollectionViewCell

@property (nonatomic, strong)GLHomeModel *model;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLHomeCellDelegate>delegate;

@end
