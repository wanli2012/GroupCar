//
//  LoadWaitView.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LoadWaitView.h"
//#import <SDWebImage/UIImage+GIF.h>

@interface LoadWaitView  ()



@end

@implementation LoadWaitView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadWaitView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
//        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestrue)];
        [self addGestureRecognizer:tap];
        
        [self initinterface];
        
        self.isTap = NO;
        
    }
    return self;

}

+(LoadWaitView*)addloadview:(CGRect)rect tagert:(id)tagert{
    
    LoadWaitView *loadview=[[LoadWaitView alloc] initWithFrame:rect];
    [tagert addSubview:loadview];
    
    return loadview;

}

-(void)removeloadview{

    [self removeFromSuperview];
    [self.loadImage stopAnimating];

}

-(void)initinterface{
 
    self.loadImage.animationImages = self.imageArr;
    self.loadImage.animationDuration = 1;//设置动画时间
    self.loadImage.animationRepeatCount = 0;//设置动画次数 0 表示无限
    
    [self.loadImage startAnimating];
    
}

-(void)tapgestrue{

    if (self.isTap == NO) {
        [self removeFromSuperview];
        [self.loadImage stopAnimating];
    }else{
        return;
    }
}

-(NSArray*)imageArr{

    if (!_imageArr) {
        NSMutableArray *arr = [NSMutableArray array];
        for(int i = 1; i < 44 ;i ++){
            NSString *str = [NSString stringWithFormat:@"%zd.png",i];
            [arr addObject:[UIImage imageNamed:str]];
        }
        _imageArr = arr;
        
    }
    return _imageArr;
}

@end
