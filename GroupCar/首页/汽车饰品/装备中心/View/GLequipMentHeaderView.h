//
//  GLequipMentHeaderView.h
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLequipMentHeaderViewDelegate <NSObject>

- (void)jumpTo:(NSInteger)index;

@end

@interface GLequipMentHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak)id <GLequipMentHeaderViewDelegate> delegate;

@end
