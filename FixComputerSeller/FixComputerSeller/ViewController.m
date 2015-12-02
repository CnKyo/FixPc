//
//  ViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController.h"
#import "WebVC.h"
#import "pwdViewController.h"
#import "forgetAndChangePwdView.h"
@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController{
    ///判断验证码发送时间
    NSTimer   *timer;
    
    int ReadTime;

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     IQKeyboardManager为自定义收起键盘
     **/
    [[IQKeyboardManager sharedManager] setEnable:YES];///视图开始加载键盘位置开启调整
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];///是否启用自定义工具栏
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;///启用手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];///视图消失键盘位置取消调整
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];///关闭自定义工具栏
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}


- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    self.mPageName = self.Title =  @"登录";
    ReadTime = 61;
    self.hiddenBackBtn = YES;
    self.hiddenlll = YES;
    self.navBar.rightBtn.frame = CGRectMake(DEVICE_Width-100, 20, 120, 44);
    self.rightBtnTitle = @"密码登录";
    [self initView];
    

}
- (void)initView{

    self.phoneView.layer.masksToBounds = YES;
    self.phoneView.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.phoneView.layer.borderWidth = 0.75f;
    self.phoneView.layer.cornerRadius = 5.0f;
    
    self.codeView.layer.masksToBounds = YES;
    self.codeView.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.codeView.layer.borderWidth = 0.75f;
    self.codeView.layer.cornerRadius = 5.0f;

    
    [self.phoneTx setKeyboardType:UIKeyboardTypeNumberPad];
    self.phoneTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.phoneTx.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTx.delegate = self;
    
    self.codeTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
//    [self.codeTx setSecureTextEntry:YES];
    self.codeTx.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTx.delegate = self;
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapAction];

    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeBtn addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.connectionBtn addTarget:self action:@selector(ConnectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *mStyle1 = @{@"Action":[WPAttributedStyleAction styledActionWithAction:^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        MLLog(@"打电话");
    }],@"color": M_CO};
    
    NSDictionary *mStyle2 = @{@"Action":[WPAttributedStyleAction styledActionWithAction:^{
        NSString *url = [GInfo shareClient].mAboutUrl;
        NSString *ss = @"?";
        if ([url rangeOfString:ss].location != NSNotFound) {
            MLLog(@"这个字符串中有?");
            url = [NSString stringWithFormat:@"%@&agent=m",[GInfo shareClient].mProtocolUrl];
            
        }else{
            url = [NSString stringWithFormat:@"%@?agent=m",[GInfo shareClient].mProtocolUrl];
            
        }
        
        WebVC* vc = [[WebVC alloc]init];
        vc.mName = @"免责声明";
        vc.mUrl = url;
        [self pushViewController:vc];
    }],@"color": M_CO};
    
    WPHotspotLabel *wkFCode = [WPHotspotLabel new];
    wkFCode.hidden = YES;
    wkFCode.font = [UIFont systemFontOfSize:14];
    wkFCode.numberOfLines = 0;
    wkFCode.textColor = M_TextColor;
    wkFCode.attributedText = [[NSString stringWithFormat:@"%@<Action> %@</Action>",@"无法获得验证码，请联系客服",[GInfo shareClient].mServiceTel] attributedStringWithStyleBook:mStyle1];
    [self.view addSubview:wkFCode];
    
    WPHotspotLabel *wkFmianze = [WPHotspotLabel new];
    wkFmianze.hidden = NO;
    wkFmianze.font = [UIFont systemFontOfSize:14];
    wkFmianze.numberOfLines = 0;
    wkFmianze.textColor = M_TextColor;
    wkFmianze.attributedText = [[NSString stringWithFormat:@"%@<Action>《e点修免责申明》</Action>",@"点击“登录”，即表示您同意"] attributedStringWithStyleBook:mStyle2];
    [self.view addSubview:wkFmianze];
    
    [wkFCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.bottom).with.offset(10);
        make.left.equalTo(self.view.left).with.offset(15);
        make.right.equalTo(self.view.right).with.offset(-15);
        make.height.offset(@45);
    }];
    
    [wkFmianze makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(wkFCode).with.offset(30);
        make.top.equalTo(self.loginBtn.bottom).with.offset(10);

        make.left.equalTo(self.view.left).with.offset(15);
        make.right.equalTo(self.view.right).with.offset(-15);
        make.height.offset(@45);
    }];
    
    
}
- (void)rightBtnTouched:(id)sender{
    pwdViewController *p = [pwdViewController new];
    [self pushViewController:p];

//    washYiXieViewController *w = [washYiXieViewController new];
//    [self pushViewController:w];
    
}
#pragma 登录事件
- (void)loginAction:(UIButton *)sender{
    
    MLLog(@"登录");
    if (![Util isMobileNumber:self.phoneTx.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [self.phoneTx becomeFirstResponder];
        return;
    }
    if (self.codeTx.text == nil || [self.codeTx.text isEqualToString:@""]) {
        [self showErrorStatus:@"验证码不能为空"];
        [self.codeTx becomeFirstResponder];
        return;
    }
    if (self.codeTx.text.length > 6){
        [self showErrorStatus:@"验证码输入错误"];
        [self.codeTx becomeFirstResponder];
        return;
    }
    
    [SUser loginWithPhone:_phoneTx.text psw:nil vcode:_codeTx.text block:^(SResBase *resb, SUser *user) {
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self loginOk];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];

}

#pragma 验证码事件
- (void)codeAction:(UIButton *)sender{
    MLLog(@"验证码");
    if (![Util isMobileNumber:_phoneTx.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_phoneTx becomeFirstResponder];
        return;
    }
    _codeBtn.userInteractionEnabled = NO;
    
    [SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeClear];
    [SUser sendSM:_phoneTx.text block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(postPhoneTestCode)
                                                   userInfo:nil
                                                    repeats:YES];
            
            [timer fire];
        }
        
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            _codeBtn.userInteractionEnabled = YES;
        }
    
        
    }];


}
#pragma mark----忘记密码
- (void)ConnectionAction:(UIButton *)sender{
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    forgetAndChangePwdView *f =[secondStroyBoard instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:f animated:YES];
}
- (void)postPhoneTestCode{
    ReadTime --;
    if (ReadTime <= 0) {
        
        MLLog(@"你点击了获取验证码");
        
        [_codeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        ReadTime = 61;
        _codeBtn.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
        return;
    }
    else{
        NSString *timestr = [NSString stringWithFormat:@"%i秒后再试",ReadTime];
        [_codeBtn setTitle:timestr forState:UIControlStateNormal];
        
    }
}

#pragma mark----登录成功跳转
- (void)loginOk{
    
//    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    OrderViewController *ooo =[secondStroyBoard instantiateViewControllerWithIdentifier:@"ooo"];
//    [self.navigationController pushViewController:ooo animated:YES];

    
    if( self.quikTagVC )
    {
        [self setToViewController_2:self.quikTagVC];
    }
    else
    {
        [self popViewController_2];
    }

}
#pragma  mark -----键盘消失
- (void)tapAction{
    
    [self.phoneTx resignFirstResponder];
    [self.codeTx resignFirstResponder];
}
///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制验证码输入长度
#define PASS_LENGHT 6
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==6) {
        res= PASS_LENGHT-[new length];
        
        
    }else
    {
        res= TEXT_MAXLENGTH-[new length];
        
    }
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
