//
//  GLWebViewController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface GLWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)JSContext *jsContext;

@end

@implementation GLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *str = [NSString stringWithFormat:@"%@",request.URL];
    if ([str containsString:@"index.html"] || [str containsString:@"club.html"] || [str containsString:@"collections.html"] || [str containsString:@"my.html"] || [str containsString:@"regist.html"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    NSLog(@"jsContext == %@",self.jsContext[@"collecte"]);
    self.jsContext[@"collecte"] = self;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)collecte {
    NSLog(@"djklfjlsjflsj--------------------------f");
}

@end
