//
//  ViewController.h
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface ViewController : BaseVC

///登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
///联系客服按钮
@property (weak, nonatomic) IBOutlet UIButton *connectionBtn;
///获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

///手机号背景view
@property (weak, nonatomic) IBOutlet UIView *phoneView;
///验证码背景view
@property (weak, nonatomic) IBOutlet UIView *codeView;

///手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTx;
///验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *codeTx;


@property (nonatomic,strong)    UIViewController* tagVC;

@property (nonatomic,strong)    UIViewController* quikTagVC;

@end

