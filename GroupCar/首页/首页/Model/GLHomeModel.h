//
//  GLHomeModel.h
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHomeModel : NSObject

@property (nonatomic, copy)NSString *goods_id;//商品ID
@property (nonatomic, copy)NSString *goods_name;//商品名
@property (nonatomic, copy)NSString *thumb;//商品展示图
@property (nonatomic, copy)NSString *goods_discount;//商品价格
@property (nonatomic, copy)NSString *lowest;//商品首付几成
@property (nonatomic, copy)NSString *set;//1已收藏 2没收藏

@end

@interface GLHome_bannerModel : NSObject

@property (nonatomic, copy)NSString *banner_id;//轮播id
@property (nonatomic, copy)NSString *banner_img;//轮播图路径
@property (nonatomic, copy)NSString *z_id;//商品id或者活动id
@property (nonatomic, copy)NSString *type;//1自定义广告 2商品广告 3活动广告 4外部链接广告
@property (nonatomic, copy)NSString *url;//外部广告链接


@end

@interface GLHome_CateModel : NSObject

@property (nonatomic, copy)NSString *cate_id;//品牌ID
@property (nonatomic, copy)NSString *catename;//品牌名
@property (nonatomic, copy)NSString *img;//品牌展示图

@property (nonatomic, strong)UIImage *pic;


@end

@interface GLHome_CityModel : NSObject

@property (nonatomic, copy)NSString *id;//品牌ID
@property (nonatomic, copy)NSString *name;//品牌名

@end


