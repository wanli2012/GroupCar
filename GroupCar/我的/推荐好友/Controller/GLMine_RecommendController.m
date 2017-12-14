//
//  GLMine_RecommendController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RecommendController.h"
#import <UShareUI/UShareUI.h>
#import "GLMine_AchieveController.h"

@interface GLMine_RecommendController ()

@property (weak, nonatomic) IBOutlet UIButton *myAchieveMent;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, copy)NSString *shareImageUrl;

@end

@implementation GLMine_RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myAchieveMent.layer.borderColor = kMain_Color.CGColor;
    self.myAchieveMent.layer.borderWidth = 1.f;
    
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
    [self.picImageV addGestureRecognizer:ges];
    
//    [self logoQrCode];
    [self postRequest];
    
}

- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:KShare_Image_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
       
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.picImageV sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"qrcode"]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
            self.shareImageUrl = responseObject[@"data"][@"qrcode"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
       
    } enError:^(NSError *error) {
        [_loadV removeloadview];
       
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 我的业绩
- (IBAction)myAchieve:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_AchieveController *achieveVC = [[GLMine_AchieveController alloc] init];
    achieveVC.navigationItem.title = @"我的业绩";
    [self.navigationController pushViewController:achieveVC animated:YES];
    
}

#pragma mark - 分享到社交圈
- (void)share:(UILongPressGestureRecognizer*)longesture{
    
    if (longesture.state == UIGestureRecognizerStateBegan) {
        
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];

        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            // 根据获取的platformType确定所选平台进行下一步操作
            [self shareWebPageToPlatformType:platformType];
        
        }];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UIImage *thumbURL = self.picImageV.image;

    //分享消息对象设置分享内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:thumbURL];
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);

            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }

    }];
}

#pragma mark -  二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    NSString *str = [NSString stringWithFormat:@"%@",Share_URL];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@""];
    
    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, 0, 0)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    //设置图片
    self.picImageV.image = finalyImage;
}

@end
