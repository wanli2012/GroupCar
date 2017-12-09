//
//  GLMine_PersonInfoController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/4.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"
#import "GLMine_PersonInfoModel.h"

@interface GLMine_PersonInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
//@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendIDLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)GLMine_PersonInfoModel *model;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"个人信息";
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT - 64;

    [self postRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)postRequest {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].user_id;
    dict[@"type"] = @"1";

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:KInfoChange_Interface paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] != 0) {
                
                self.model = [GLMine_PersonInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self refresh];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];

}
- (void)refresh{
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.portrait] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.nameLabel.text = self.model.nickname;
    self.IDLabel.text = self.model.uname;
    self.recommendLabel.text = self.model.gnickname;
    self.recommendIDLabel.text = self.model.gname;
    
}
#pragma mark - 修改昵称
- (IBAction)changeNickName:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"昵称修改" message:@"请输入你想要的昵称?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入昵称";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(alertVC.textFields.lastObject.text.length == 0){
            
            return;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].user_id;
        dict[@"type"] = @"2";
        dict[@"user_name"] = alertVC.textFields.lastObject.text;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:KInfoChange_Interface paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                self.model.nickname = alertVC.textFields.lastObject.text;
                [self refresh];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
        }];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 修改头像
- (IBAction)modifyPicture:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"头像修改" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        // 设置选择后的图片可以被编辑
        
        //1.获取媒体支持格式
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = @[mediaTypes[0]];
        //5.其他配置
        //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
        picker.allowsEditing = YES;
        //6.推送
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            // 设置拍照后的图片可以被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:picture];
    [alertVC addAction:camera];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        
        UIImage *picImage = [UIImage imageWithData:data];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].user_id;
        dict[@"type"] = @"2";
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@%@",BaseURL,KInfoChange_Interface] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传

            if (picImage) {

                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(picImage);
                [formData appendPartWithFileData:data name:@"portrait" fileName:fileName mimeType:@"image/png"];
            }

        }progress:^(NSProgress *uploadProgress){

        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

            if ([dic[@"code"]integerValue] == SUCCESS_CODE) {
                self.picImageV.image = [UIImage imageWithData:data];

                [SVProgressHUD showSuccessWithStatus:dic[@"message"]];

            }else{
                [SVProgressHUD showErrorWithStatus:dic[@"message"]];
            }

            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];

            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
//
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
