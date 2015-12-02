//
//  pwdViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/9.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "pwdViewController.h"
#import "Masonry.h"
#import "WebVC.h"
#import "forgetAndChangePwdView.h"
@interface pwdViewController ()<UITextFieldDelegate>

@end

@implementation pwdViewController
{
    UITextField *mPhoneTx;
    UITextField *mPwdTx;
    
    UILabel *ttt;
    
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
    self.hiddenlll = YES;
    self.mPageName = self.Title = @"密码登录";
    self.contentView.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    int top = 94;
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithRed:0.882 green:0.878 blue:0.871 alpha:1];
    [self.view addSubview:line1];
    
    ttt = [UILabel new];
    ttt.font = [UIFont systemFontOfSize:15];
    ttt.text = @"验证手机，马上进入e点修";
    ttt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ttt];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = line1.backgroundColor;
    [self.view addSubview:line2];
    line1.hidden = YES;
    line2.hidden = YES;
    ttt.hidden = YES;
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(ttt.mas_left).with.offset(-5);
        make.height.equalTo(@1);
        make.width.equalTo(@65);
    }];
    
    [ttt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(86);
        make.left.equalTo(line1.mas_right).with.offset(5);
        make.right.equalTo(line2.mas_left).with.offset(-5);
        make.height.equalTo(@15);
        make.width.equalTo(@170);
        
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(top);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(ttt.mas_right).with.offset(5);
        make.height.equalTo(@1);
        make.width.equalTo(@65);
    }];
    [self initTxView];
}
- (void)initTxView{
    UIView *phoneView = [UIView new];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.cornerRadius = 4;
    phoneView.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    phoneView.layer.borderWidth = 0.75f;
    [self.view addSubview:phoneView];
    
    UIImage *image = [UIImage imageNamed:@"phone"];
    UIImageView *phoneImg = [UIImageView new];
    phoneImg.image = image ;
    [phoneView addSubview:phoneImg];
    
    mPhoneTx = [UITextField new];
    mPhoneTx.delegate = self;
    mPhoneTx.tag = 11;
    mPhoneTx.font = [UIFont systemFontOfSize:14];
    mPhoneTx.placeholder = @"请输入手机号码";
    [mPhoneTx setKeyboardType:UIKeyboardTypeNumberPad];
    mPhoneTx.clearButtonMode = UITextFieldViewModeUnlessEditing;

    [phoneView addSubview:mPhoneTx];
    
    
    UIView *codeView = [UIView new];
    codeView.backgroundColor = phoneView.backgroundColor;
    codeView.layer.masksToBounds = YES;
    codeView.layer.cornerRadius = 4;
    codeView.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    codeView.layer.borderWidth = 0.75f;
    [self.view addSubview:codeView];
    
    UIImage *image2 = [UIImage imageNamed:@"passwd"];
    UIImageView *pwdImg = [UIImageView new];
    pwdImg.image = image2;
    [codeView addSubview:pwdImg];
    
    mPwdTx = [UITextField new];
    mPwdTx.delegate = self;
    mPwdTx.tag = 20;
    mPwdTx.font = [UIFont systemFontOfSize:14];
    mPwdTx.placeholder = @"请输入密码";
    [mPwdTx setSecureTextEntry:YES];
//    [mPwdTx setKeyboardType:UIKeyboardTypeNumberPad];
    mPwdTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [codeView addSubview:mPwdTx];
    

    UIButton *wkForgetBtn = [UIButton new];
    [wkForgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [wkForgetBtn addTarget:self action:@selector(FAction:) forControlEvents:UIControlEventTouchUpInside];
    [wkForgetBtn setTitleColor:M_CO forState:UIControlStateNormal];
    [wkForgetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    wkForgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:wkForgetBtn];
    
    
    UIButton *loginBtn = [UIButton new];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:M_CO];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapAction];
    
    NSDictionary *mStyle = @{@"Action":[WPAttributedStyleAction styledActionWithAction:^{
        
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
    NSString *ssss = @"点击“登录”，即表示您同意";
    
    WPHotspotLabel *aaa = [WPHotspotLabel new];
    aaa.hidden = YES;
    aaa.font = [UIFont systemFontOfSize:14];
    aaa.numberOfLines = 0;
    aaa.textColor = M_TextColor;
    aaa.attributedText = [[NSString stringWithFormat:@"%@<Action>《e点修免责申明》</Action>",ssss] attributedStringWithStyleBook:mStyle];
    [self.view addSubview:aaa];
    
    [phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ttt.bottom).with.offset(0);
        make.left.equalTo(self.view.left).with.offset(15);
        make.right.equalTo(self.view.right).with.offset(-15);
        make.height.offset(@45);
    }];
    
    [phoneImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.top).with.offset(13);
        make.left.equalTo(phoneView.left).with.offset(15);
        make.right.equalTo(mPhoneTx.left).with.offset(-10);
        make.bottom.equalTo(phoneView.bottom).with.offset(-12);
        make.height.offset(@19);
        make.width.offset(@16);
        
    }];
    
    [mPhoneTx makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.top).with.offset(10);
        make.left.equalTo(phoneImg.right).with.offset(10);
        make.right.equalTo(phoneView.right).with.offset(-10);
        make.bottom.equalTo(phoneView.bottom).with.offset(-10);
    }];

    
    [codeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.bottom).with.offset(15);
        make.left.equalTo(self.view.left).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.offset(@45);
    }];
    
    [pwdImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.top).with.offset(13);
        make.left.equalTo(codeView.left).with.offset(15);
        make.right.equalTo(mPwdTx.left).with.offset(-10);
        make.bottom.equalTo(codeView.left).offset(-12);
        make.height.offset(@19);
        make.width.offset(@16);
    }];
    
    [mPwdTx makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.top).with.offset(10);
        make.left.equalTo(pwdImg.right).with.offset(10);
        make.right.equalTo(codeView.right).with.offset(-10);
        make.bottom.equalTo(codeView.bottom).with.offset(-10);
    }];
    

    [wkForgetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.bottom).with.offset(10);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.offset(@45);
        make.width.offset(@135);
    }];
    
    
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wkForgetBtn.bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.offset(@45);
    }];
    
    [aaa makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.offset(@35);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  登录事件
 *
 *  @param sender 手机/密码
 */
- (void)loginAction:(UIButton *)sender{
    
    if (![Util isMobileNumber:mPhoneTx.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [mPhoneTx becomeFirstResponder];
        return;
    }
    if (mPwdTx.text == nil || [mPwdTx.text isEqualToString:@""]) {
        [self showErrorStatus:@"验证码不能为空"];
        [mPwdTx becomeFirstResponder];
        return;
    }

    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
    [SUser loginWithPhone:mPhoneTx.text psw:mPwdTx.text block:^(SResBase *resb, SUser *user) {
        if ( resb.msuccess ) {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self loginOk];
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];

        }
    }];
    
    
}
#pragma mark----登录成功跳转
- (void)loginOk{
  
    if( self.quikTagVC )
    {
        [self setToViewController_2:self.quikTagVC];
    }
    else
    {
        [self popViewController_2];
    }
    
}
#pragma mark ----忘记密码
- (void)FAction:(UIButton *)sender{
    MLLog(@"忘记密码");
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    forgetAndChangePwdView *f =[secondStroyBoard instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:f animated:YES];
}
#pragma  mark -----键盘消失
- (void)tapAction{
    
    [mPhoneTx resignFirstResponder];
    [mPwdTx resignFirstResponder];
}
///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制密码输入长度
#define PASS_LENGHT 20
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==11) {
        res= TEXT_MAXLENGTH-[new length];

        
    }else
    {
        res= PASS_LENGHT-[new length];

        
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

@end
