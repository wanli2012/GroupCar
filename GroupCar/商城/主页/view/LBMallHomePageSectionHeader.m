//
//  LBMallHomePageSectionHeader.m
//  GroupCar
//
//  Created by 四川三君科技有限公司 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBMallHomePageSectionHeader.h"

@interface LBMallHomePageSectionHeader ()
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@end


@implementation LBMallHomePageSectionHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)more:(id)sender {

    if([self.delegate respondsToSelector:@selector(more:)]){
        [self.delegate more:self.section];
    }
}

@end
