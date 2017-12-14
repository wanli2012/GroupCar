//
//  GLHomeController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeController.h"
#import "GLHomeHeaderView.h"
#import "GLHomeCell.h"
#import "GLHomeModel.h"
#import "GLWebViewController.h"
#import "SDCycleScrollView.h"

//单选picker 和动画
#import "GLSimpleSelectionPickerController.h"
#import "editorMaskPresentationController.h"


@interface GLHomeController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate,GLHomeCellDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (nonatomic, assign)NSInteger page;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;

@property (nonatomic, strong)NSMutableArray *bannerModels;
@property (nonatomic, strong)NSMutableArray *cateModels;
@property (nonatomic, strong)NSDictionary *noticeDic;
@property (nonatomic, strong)NSMutableArray *cityModels;
@property (nonatomic, strong)NSMutableArray *cityNameArr;

@property (nonatomic, copy)NSString *city_id;

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic)NSString *app_Version;//当前版本号


@end

@implementation GLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchView.layer.cornerRadius = 5.f;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLHomeHeaderView"];
     
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHomeCell" bundle:nil] forCellWithReuseIdentifier:@"GLHomeCell"];

    [self.collectionView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        [self postBanner:YES];
        [self postBrand:YES];
        [self postNotice:YES];

    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;
    
    self.page = 1;
    [self postRequest:YES];
    [self postBanner:YES];
    [self postBrand:YES];
    [self postNotice:YES];

    //版本更新提示
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
//    [self Postpath:GET_VERSION];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;

    }
    self.city_id = @"";
    
}

#pragma mark - 请求城市
//- (void)postCity:(BOOL)isRefresh{
//
//    [NetworkManager requestPOSTWithURLStr:KCity_Interface paramDic:@{} finish:^(id responseObject) {
//
//        [self endRefresh];
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
//
//            [self.cityModels removeAllObjects];
//            for (NSDictionary *dic in responseObject[@"data"]) {
//                GLHome_CityModel *model = [GLHome_CityModel mj_objectWithKeyValues:dic];
//                [self.cityModels addObject:model];
//            }
//
//        }else{
//            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//        }
//
//        [self.collectionView reloadData];
//    } enError:^(NSError *error) {
//
//        [self endRefresh];
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
//}

#pragma mark - 请求品牌
- (void)postBrand:(BOOL)isRefresh{

    [NetworkManager requestPOSTWithURLStr:KGet_Band_Interface paramDic:@{} finish:^(id responseObject) {

        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                if(isRefresh){
                    [self.cateModels removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLHome_CateModel * model = [GLHome_CateModel mj_objectWithKeyValues:dic];
                    
                    [self.cateModels addObject:model];
                }
                
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.cateModels.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
    } enError:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
#pragma mark - 请求公告
- (void)postNotice:(BOOL)isRefresh{
    
    [NetworkManager requestPOSTWithURLStr:KGet_Notice_Interface paramDic:@{} finish:^(id responseObject) {

        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.noticeDic = responseObject[@"data"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
    } enError:^(NSError *error) {
 
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
#pragma mark - 请求banner
- (void)postBanner:(BOOL)isRefresh{
    
    [NetworkManager requestPOSTWithURLStr:KGet_ShopBanner_Interface paramDic:@{} finish:^(id responseObject) {
 
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                if(isRefresh){
                    [self.bannerModels removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLHome_bannerModel * model = [GLHome_bannerModel mj_objectWithKeyValues:dic];
                    [self.bannerModels addObject:model];
                }
                NSMutableArray *arrM = [NSMutableArray array];
                
                for (GLHome_bannerModel *model in self.bannerModels) {
                    NSString *imageurl = [NSString stringWithFormat:@"%@",model.banner_img];
                    [arrM addObject:imageurl];
                }
                
                self.cycleScrollView.imageURLStringsGroup = arrM;
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.cateModels.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
    } enError:^(NSError *error) {

        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 请求数据
- (void)postRequest:(BOOL)isRefresh{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"city"] = self.city_id;

//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KGet_ShopGoods_Interface paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                if(isRefresh){
                    [self.models removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLHomeModel * model = [GLHomeModel mj_objectWithKeyValues:dic];

                    [self.models addObject:model];
                }
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.models.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)endRefresh {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self postRequest:YES];
}

#pragma mark - 城市选择
- (IBAction)cityChoose:(id)sender {

    if (self.cityModels.count != 0) {
        [self popChooser:self.cityNameArr Title:@"请选择城市"];
        return;
    }
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:KCity_Interface paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.cityModels removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLHome_CityModel *model = [GLHome_CityModel mj_objectWithKeyValues:dic];
                [self.cityModels addObject:model];
            }
            [self.cityNameArr removeAllObjects];
            for (GLHome_CityModel *model in self.cityModels) {
                [self.cityNameArr addObject:model.name];
            }
            [self popChooser:self.cityNameArr Title:@"请选择职业"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
  
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}
#pragma mark - 弹出单项选择器
- (void)popChooser:(NSMutableArray *)dataArr Title:(NSString *)title{
    
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    vc.dataSourceArr = dataArr;
    vc.titlestr = title;
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        GLHome_CityModel *model = weakSelf.cityModels[index];
        weakSelf.cityLabel.text = dataArr[index];
        weakSelf.city_id = model.id;
        [weakSelf postRequest:YES];
        [weakSelf.collectionView reloadData];
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 收藏
- (void)collecte:(NSInteger)index{
    
    GLHomeModel *model = self.models[index];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"goodsid"] = model.goods_id;
    
    if ([model.set integerValue] == 1) {//1已收藏 2没收藏
        [NetworkManager requestPOSTWithURLStr:KDel_Collection_Interface paramDic:dict finish:^(id responseObject) {
//            [_loadV removeloadview];
            [self endRefresh];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                model.set = @"2";

            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
            [self.collectionView reloadData];
        } enError:^(NSError *error) {
//            [_loadV removeloadview];
            [self endRefresh];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];

    }else{
        
        [NetworkManager requestPOSTWithURLStr:KCollecte_goods_Interface paramDic:dict finish:^(id responseObject) {
//            [_loadV removeloadview];
            [self endRefresh];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                model.set = @"1";
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
            [self.collectionView reloadData];
        } enError:^(NSError *error) {
//            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
    
}
#pragma mark - 搜索
- (IBAction)search:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];

    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_SearhURL];
    
    webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&city_id=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,self.city_id];
    
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
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
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
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
        

    }
}

#pragma mark - SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    GLHome_bannerModel *adModel = self.bannerModels[index];

    self.hidesBottomBarWhenPushed = YES;

    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    GLHomeModel *model = self.models[index];
    
    self.hidesBottomBarWhenPushed = NO;
    //1自定义广告 2商品广告 3活动广告 4外部链接广告
    if([adModel.type integerValue] == 1){

//        adVC.navTitle = adModel.banner_title;
//        adVC.url = [NSString stringWithFormat:@"%@%@",AD_URL,adModel.banner_id];
//        [self.navigationController pushViewController:adVC animated:YES];

    }else if([adModel.type integerValue] == 2){

        NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CarDetailURL];
        webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&goodsid=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,model.goods_id];
        
        [self.navigationController pushViewController:webVC animated:YES];

    }else if([adModel.type integerValue] == 3){

        NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CarDetailURL];
        webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&goodsid=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,model.goods_id];
        
        [self.navigationController pushViewController:webVC animated:YES];

    }else{
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adModel.url]];
    }

    self.hidesBottomBarWhenPushed = NO;
}

///** 图片滚动回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
//
//}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.models.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHomeCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.model = self.models[indexPath.row];
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kSCREEN_WIDTH - 20) / 2;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLWebViewController *webVC = [[GLWebViewController alloc] init];
    GLHomeModel *model = self.models[indexPath.row];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",H5_baseURL,H5_CarDetailURL];
    
    webVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&appPort=1&goodsid=%@",baseUrl,[UserModel defaultUser].token,[UserModel defaultUser].user_id,model.goods_id];
    
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//返回headerView
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionReusableView *reusableview = nil;
    GLHomeHeaderView *myHeaderView;
    if (kind == UICollectionElementKindSectionHeader)
    {
        myHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GLHomeHeaderView" forIndexPath:indexPath];
        //在这里进行headerView的操作
        [myHeaderView addSubview:self.cycleScrollView];

    }
    
    myHeaderView.city_id = self.city_id;
    myHeaderView.cateModels = self.cateModels;
    myHeaderView.bannerModels = self.bannerModels;
    myHeaderView.noticeDic = self.noticeDic;
    return myHeaderView;
}
//返回headerView的大小为宽320  高 100
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = (kSCREEN_WIDTH - 60)/5 + 20;
    CGSize size = CGSizeMake(kSCREEN_WIDTH, 300 + 45 + height * 2);
    
    return size;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

#pragma mark - 动画的代理
//动画
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}
//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    [self chooseindustry:transitionContext];
}
-(void)chooseindustry:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
        }];
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
- (NSMutableArray *)bannerModels{
    if (!_bannerModels) {
        _bannerModels = [NSMutableArray array];
    }
    return _bannerModels;
}
- (NSMutableArray *)cateModels{
    if (!_cateModels) {
        _cateModels = [NSMutableArray array];
    }
    return _cateModels;
}
- (NSMutableArray *)cityModels{
    if (!_cityModels) {
        _cityModels = [NSMutableArray array];
    }
    return _cityModels;
}
- (NSMutableArray *)cityNameArr{
    if (!_cityNameArr) {
        _cityNameArr = [NSMutableArray array];
    }
    return _cityNameArr;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50 - 500);
        
    }
    return _nodataV;
}
-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        
        _cycleScrollView.localizationImageNamesGroup = @[[UIImage imageNamed:PlaceHolderImage],[UIImage imageNamed:PlaceHolderImage]];
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:PlaceHolderImage];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }
    
    return _cycleScrollView;
    
}
@end
