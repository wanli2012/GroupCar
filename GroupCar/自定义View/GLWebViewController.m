//
//  GLWebViewController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UShareUI/UShareUI.h>

@interface GLWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)JSContext *jsContext;

@property (nonatomic, copy)NSString *shareUrl;

@end

@implementation GLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView setScalesPageToFit:YES];

    [self.webView.scrollView setBounces:NO];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *str = [NSString stringWithFormat:@"%@",request.URL];
    
    if ([str containsString:@"index.html"] ||
        [str containsString:@"club.html"] ||
        [str containsString:@"collections.html"] ||
        [str containsString:@"my.html"] ||
        [str containsString:@"regist.html"] ||
        [str containsString:@"set.html"] ||
        [str containsString:@"agent.html"] ||
        [str containsString:@"login.html"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([str hasPrefix:@"mm://"]){
        if ([str containsString:@"sc.html"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLWebViewNotification" object:nil];
        }else{
            
            NSString *http = @"http://";
            
            NSString *url = [http stringByAppendingFormat:@"%@",[str substringFromIndex:5]];
            
            self.shareUrl = url;
            [self share:url];
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

#pragma mark - 分享到社交圈
- (void)share:(NSString *)url{

    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
        
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UIImage *thumbURL = [UIImage imageNamed:@"爱车"];

    //分享消息对象设置分享内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"久久汽车" descr:@"商品分享" thumImage:thumbURL];
    shareObject.webpageUrl = self.shareUrl;
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

@end
