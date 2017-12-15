//
//  GLMine_SetController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/4.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetController.h"
#import "GLMine_Set_AccountController.h"
#import "GLWebViewController.h"

@interface GLMine_SetController ()
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (strong, nonatomic)NSString *app_Version;//当前版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePhoneLabel;
@property (nonatomic, copy)NSString *memory;//内存
@property (weak, nonatomic) IBOutlet UILabel *memoryLabel;
@property (nonatomic, strong)UIView *maskV;

@end

@implementation GLMine_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"设置";
    self.quitBtn.layer.cornerRadius = 5.f;
    self.quitBtn.layer.borderColor = YYSRGBColor(95, 94, 239, 1).CGColor;
    self.quitBtn.layer.borderWidth = 1.f;
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;

    //版本更新提示
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLabel.text = _app_Version;
    self.memoryLabel.text = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    [self postPhone];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)hideHUD {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.maskV.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [SVProgressHUD dismiss];
        
        [self.maskV removeFromSuperview];
        self.maskV = nil;
    }];
    
}

- (void)postPhone{
   
    [NetworkManager requestPOSTWithURLStr:KSet_Interface paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            self.servicePhoneLabel.text = responseObject[@"data"][@"customer"];
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
     
    }];
}
#pragma mark - 账号安全
- (IBAction)accountSecurity:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Set_AccountController *accountVC = [[GLMine_Set_AccountController alloc] init];
    accountVC.navigationItem.title = @"账号安全";
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark - 关于公司
- (IBAction)aboutCompany:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CompanyURL];
    
    webVC.url = [NSString stringWithFormat:@"%@",baseUrl];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 版本信息
- (IBAction)editionInfo:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskV];
    
    [SVProgressHUD showWithStatus:@"正在检测版本"];
     [self Postpath:GET_VERSION];
}

#pragma mark - 检查是否有更新
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    __weak __typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        [SVProgressHUD dismiss];
        [weakSelf hideHUD];
        
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue] > 0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [weakSelf performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
}

-(void)receiveData:(id)sender{
    
    NSString  *Newversion = [NSString stringWithFormat:@"%@",sender[@"version"]];
    
    if (![_app_Version isEqualToString:Newversion]) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新" message:@"发现新版本,是否更新?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [SVProgressHUD showWithStatus:@"已是最新版本"];
        return;
    }
}
#pragma mark - 联系客服
- (IBAction)contractUS:(id)sender {
    
    if (self.servicePhoneLabel.text.length != 0) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.servicePhoneLabel.text]]]; //拨号
    }
}

#pragma mark - 清除缓存
- (IBAction)clearMemory:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearFile];//清楚缓存
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [self folderSizeAtPath :cachPath];
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    //NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    [self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES];
}

-(void)clearCachSuccess{
    
    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];

    self.memoryLabel.text = self.memory;
    
}
#pragma mark - 退出登录
- (IBAction)quit:(id)sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserModel defaultUser].loginstatus = NO;
        [UserModel defaultUser].portrait = @"";
        [UserModel defaultUser].token = @"";
        [UserModel defaultUser].user_id = @"";
        
        [usermodelachivar achive];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"suckEffect";
        [self.view.window.layer addAnimation:animation forKey:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] init];
        _maskV.backgroundColor = YYSRGBColor(184, 184, 184, 0.2);
        _maskV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD)];
        [_maskV addGestureRecognizer:tap];
    }
    return _maskV;
}

@end
