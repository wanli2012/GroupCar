//
//  GLequipMentHeaderView.m
//  GroupCar
//
//  Created by 龚磊 on 2017/8/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLequipMentHeaderView.h"

@interface GLequipMentHeaderView ()
{
    NSArray *_imageArr;
    NSArray * _titleArr;
}
@end

@implementation GLequipMentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.autoresizingMask = NO;
    
    [self setUI];
}
- (void)setUI{
    
    CGFloat width = kSCREEN_WIDTH / 4;//view的宽
    CGFloat height = 100;//view 的高
    CGFloat labelHeight = 15;//label的高
    CGFloat imageHeight = 50;//图片的高
    
    _imageArr = @[@"热门",@"爱车",@"与众不同",@"全部"];
    _titleArr = @[@"热门推荐",@"爱车必备",@"与众不同",@"全部分类"];
    
    for (int i = 0; i < 4; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i + 10;

        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((width - imageHeight)/2, (height - labelHeight - imageHeight ) / 2, imageHeight, imageHeight)];
        imageV.backgroundColor = [UIColor redColor];
        imageV.image = [UIImage imageNamed:_imageArr[i]];
        imageV.layer.cornerRadius = imageHeight / 2;
        imageV.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - labelHeight- 10, width, labelHeight)];
        label.text = _titleArr[i];
        label.font = FONT(12);
        label.textColor = YYSRGBColor(51, 51, 51, 1);
        label.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];

        [view addSubview:imageV];
        [view addSubview:label];
        [view addGestureRecognizer:tap];
        
        [self.scrollView addSubview:view];

    }
}

- (void)click:(UIGestureRecognizer*)tap{
    
    if ([self.delegate respondsToSelector:@selector(jumpTo:)]) {
        [self.delegate jumpTo:tap.view.tag];
    }
    
}

@end
