//
//  GLMine_RealnameController.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RealnameController.h"

@interface GLMine_RealnameController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *IDTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *identifyTF;

@end

@implementation GLMine_RealnameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.borderColor = kMain_Color.CGColor;
    self.submitBtn.layer.borderWidth = 1.f;
}

- (IBAction)submit:(id)sender {
    NSLog(@"提交认证");
}

#pragma mark - UITextFieldDelegeta
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
@end
