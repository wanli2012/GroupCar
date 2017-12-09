//
//  GLMine_MessageCell.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_MessageModel.h"

@protocol GLMine_MessageCellDelegate <NSObject>

- (void)deleteTheMessage:(NSInteger )index;

@end

@interface GLMine_MessageCell : UITableViewCell

@property (nonatomic, strong)GLMine_MessageModel *model;

@property (nonatomic, weak)id <GLMine_MessageCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
