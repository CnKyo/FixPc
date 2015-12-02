//
//  forgetAndChangePwdView.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "forgetAndChangePwdView.h"

@interface forgetAndChangePwdView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wkPhoneTX;
@property (weak, nonatomic) IBOutlet UITextField *wkCodeTx;
@property (weak, nonatomic) IBOutlet UITextField *wkNewPWD;
@property (weak, nonatomic) IBOutlet UITextField *wkComfirPWD;
@property (weak, nonatomic) IBOutlet UIButton *wkFbtn;
@property (weak, nonatomic) IBOutlet UIButton *wkLoginBtn;


@property (weak, nonatomic) IBOutlet UIView *wkV1;
@property (weak, nonatomic) IBOutlet UIView *wkV2;
@property (weak, nonatomic) IBOutlet UIView *wkV3;
@property (weak, nonatomic) IBOutlet UIView *wkV4;

@end

@implementation forgetAndChangePwdView
{
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

    self.hiddenlll = YES;
    
    if (self.wkType == 1) {
        self.mPageName = self.Title = @"修改密码";
    }else{
        self.mPageName = self.Title = @"修改密码";
    }

    [self initView];

}

- (void)initView
{
    self.wkV1.layer.masksToBounds = YES;
    self.wkV1.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV1.layer.borderWidth = 0.75f;
    self.wkV1.layer.cornerRadius = 5.0f;
    
    self.wkV2.layer.masksToBounds = YES;
    self.wkV2.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV2.layer.borderWidth = 0.75f;
    self.wkV2.layer.cornerRadius = 5.0f;
    
    self.wkV3.layer.masksToBounds = YES;
    self.wkV3.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV3.layer.borderWidth = 0.75f;
    self.wkV3.layer.cornerRadius = 5.0f;
    
    self.wkV4.layer.masksToBounds = YES;
    self.wkV4.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV4.layer.borderWidth = 0.75f;
    self.wkV4.layer.cornerRadius = 5.0f;
    
    [self.wkPhoneTX setKeyboardType:UIKeyboardTypeNumberPad];
    self.wkPhoneTX.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.wkPhoneTX.keyboardType = UIKeyboardTypeNumberPad;

    self.wkPhoneTX.delegate = self;
    
    self.wkCodeTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
//    [self.wkCodeTx setSecureTextEntry:YES];
    self.wkCodeTx.keyboardType = UIKeyboardTypeNumberPad;
    self.wkCodeTx.delegate = self;
    
    self.wkNewPWD.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [self.wkNewPWD setSecureTextEntry:YES];
    self.wkNewPWD.delegate = self;
    
    self.wkComfirPWD.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [self.wkComfirPWD setSecureTextEntry:YES];
    self.wkComfirPWD.delegate = self;
    
    NSDictionary *mStyle1 = @{@"Action":[WPAttributedStyleAction styledActionWithAction:^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        MLLog(@"打电话");
    }],@"color": M_CO,@"xiahuaxian":@[M_CO,@{NSUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)}]};
    
    WPHotspotLabel *wkFCode = [WPHotspotLabel new];
    wkFCode.hidden = YES;
    wkFCode.font = [UIFont systemFontOfSize:14];
    wkFCode.numberOfLines = 0;
    wkFCode.textColor = M_TextColor;
    wkFCode.attributedText = [[NSString stringWithFormat:@"%@<Action> %@</Action>",@"无法获得验证码，请联系客服",[GInfo shareClient].mServiceTel] attributedStringWithStyleBook:mStyle1];
    [self.view addSubview:wkFCode];
    
    [wkFCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wkLoginBtn.bottom).with.offset(10);
        make.left.equalTo(self.view.left).with.offset(15);
        make.right.equalTo(self.view.right).with.offset(-15);
        make.height.offset(@45);
    }];
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapAction];
    
    [self.wkLoginBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)LoginAction{
    MLLog(@"确认修改");
    
    if (![Util isMobileNumber:self.wkPhoneTX.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [self.wkPhoneTX becomeFirstResponder];
        return;
    }
    if (self.wkCodeTx.text == nil || [self.wkCodeTx.text isEqualToString:@""]) {
        [self showErrorStatus:@"验证码不能为空"];
        [self.wkCodeTx becomeFirstResponder];
        return;
    }
    if (self.wkNewPWD.text != self.wkComfirPWD.text) {
        [self showErrorStatus:@"2次输入密码不一致"];
        [self.wkCodeTx becomeFirstResponder];
        return;
    }
    
    [SUser reSetPswWithPhone:_wkPhoneTX.text newpsw:_wkNewPWD.text smcode:_wkCodeTx.text block:^(SResBase *resb, SUser *user) {
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self popToRootViewController];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -----键盘消失
- (void)tapAction{
    
    [self.wkPhoneTX resignFirstResponder];
    [self.wkCodeTx resignFirstResponder];
    [self.wkNewPWD resignFirstResponder];
    [self.wkComfirPWD resignFirstResponder];

}
///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制密码输入长度
#define PASS_LENGHT 20
#define CodeLength 6
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res = 0;
    if (textField.tag==20) {
        res= PASS_LENGHT-[new length];
        
        
    }
    if (textField.tag == 11) {
        res= TEXT_MAXLENGTH-[new length];

    }
    if (textField.tag == 6)
    {
        res= CodeLength-[new length];
        
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
