//
//  LBMallHomePageSectionHeader.h
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBMallHomePageSectionHeaderDelegate <NSObject>

@optional
- (void)more:(NSInteger)index;

@end

@interface LBMallHomePageSectionHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak)id <LBMallHomePageSectionHeaderDelegate> delegate;
@property (nonatomic, assign)NSInteger section;

@end
