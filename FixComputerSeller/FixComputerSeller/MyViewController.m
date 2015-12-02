//
//  MyViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "MyViewController.h"
#import "feedbackViewController.h"
#import "myMessageViewController.h"
#import "myDeatailView.h"

#import "mMyDetailViewController.h"

#import "WebVC.h"
#import "moreView.h"

#import "noterViewController.h"
#import "setServiceTimeView.h"
#import "PingjiaVC.h"
#import "leaveViewController.h"
@interface MyViewController ()

@end

@implementation MyViewController{

    feedbackViewController *fff;
    
    
    UIScrollView *sss;

    moreView *mView;
    
    moreView *mTwo;
    
}


- (void)getBalance{

    [SVProgressHUD showWithStatus:@"获取中" maskType:SVProgressHUDMaskTypeClear];
    [[SUser currentUser] getBalance:^(SResBase *resb, NSDictionary *dic) {
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
            mView.mYue.text = [NSString stringWithFormat:@"%.2f",[[[[resb.mdata objectForKey:@"seller"] objectForKey:@"extend"] objectForKey:@"totalMoney"] floatValue]];
            mView.mTiXianYue.text = [NSString stringWithFormat:@"%.2f",[[[[resb.mdata objectForKey:@"seller"] objectForKey:@"extend"] objectForKey:@"withdrawMoney"] floatValue]];
            mView.mDongJieYue.text = [NSString stringWithFormat:@"%.2f",[[[[resb.mdata objectForKey:@"seller"] objectForKey:@"extend"] objectForKey:@"frozenMoney"] floatValue]];
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    [self initView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"e点修";
    self.hiddenBackBtn = YES;
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
}
#pragma mark----构造主页面
- (void)initView{
    
    sss = [[UIScrollView alloc]init];
    sss.frame = CGRectMake(0, 64, DEVICE_Width, DEVICE_InNavTabBar_Height);
    sss.contentSize = CGSizeMake(DEVICE_Width, 611);
    sss.showsHorizontalScrollIndicator = NO;
    sss.showsVerticalScrollIndicator = NO;
    sss.backgroundColor = COLOR(236, 237, 239);
    [self.view addSubview:sss];
    
    
    if ([SUser currentUser].mType == 1) {
        [self initOne];
    }else{
        [self initTwo];
    }
    
    if ([SUser isNeedLogin]) {
        mView.mUserName.text = nil;
        mView.mPhone.text = nil;
        mView.mHeader.image = [UIImage imageNamed:@"defultHead"];
        
        [mView.mLogOut setTitle:@"登录" forState:UIControlStateNormal];
        
        
        mTwo.mUserName.text = nil;
        mTwo.mPhone.text = nil;
        mTwo.mHeader.image = [UIImage imageNamed:@"defultHead"];
        
        [mTwo.mLogOut setTitle:@"登录" forState:UIControlStateNormal];
    }
    else{
        
        [mView.mHeader sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead.png"]];
        MLLog(@"头像地址：%@",[SUser currentUser].mHeadImgURL);
        mView.mUserName.text = [SUser currentUser].mUserName;
        mView.mPhone.text = [SUser currentUser].mPhone;
        
        
        [mView.mLogOut setTitle:@"退出登录" forState:UIControlStateNormal];
        
        
        [mTwo.mHeader sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead.png"]];
        MLLog(@"头像地址：%@",[SUser currentUser].mHeadImgURL);
        mTwo.mUserName.text = [SUser currentUser].mUserName;
        mTwo.mPhone.text = [SUser currentUser].mPhone;
        
        
        [mTwo.mLogOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [self getBalance];

    }
    
    
}
- (void)initOne{
    mView = [moreView shareView];
    mView.frame = CGRectMake(0, 0, sss.mwidth, 611);
    [sss addSubview:mView];
    
    [mView.mMessage addTarget:self action:@selector(MsgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mView.mQingJia addTarget:self action:@selector(QingJiaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mView.mEditBtn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    [mView.mSetServiceTime addTarget:self action:@selector(setTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [mView.mAboutUs addTarget:self action:@selector(aboutUSAction:) forControlEvents:UIControlEventTouchUpInside];
    [mView.mLogOut addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [mView.mOpinion addTarget:self action:@selector(FeedBackAction:) forControlEvents:UIControlEventTouchUpInside];
    

}
- (void)initTwo{
    mTwo = [moreView shareTwo];
    mTwo.frame = CGRectMake(0, 0, sss.mwidth, 611);
    [sss addSubview:mTwo];
    
    [mTwo.mMessage addTarget:self action:@selector(MsgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mTwo.mQingJia addTarget:self action:@selector(QingJiaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mTwo.mEditBtn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    [mTwo.mSetServiceTime addTarget:self action:@selector(setTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [mTwo.mAboutUs addTarget:self action:@selector(aboutUSAction:) forControlEvents:UIControlEventTouchUpInside];
    [mTwo.mLogOut addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [mTwo.mOpinion addTarget:self action:@selector(FeedBackAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)MsgAction:(UIButton *)sender{
    
    MLLog(@"消息");
    myMessageViewController *msg = [[myMessageViewController alloc] init];
    [self pushViewController:msg];
}

- (void)QingJiaAction:(UIButton *)sender{

    MLLog(@"请假");
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    leaveViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"leave"];
    
    [self.navigationController pushViewController:lll animated:YES];
}

- (void)headerAction:(UIButton *)sender{
    MLLog(@"头像");
    
    mMyDetailViewController *m = [mMyDetailViewController new];
    [self pushViewController:m];

}

#pragma mark----投诉与建议
- (void)FeedBackAction:(UIButton *)sender{
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    feedbackViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"xxx"];
    [self.navigationController pushViewController:lll animated:YES];
}

- (void)setTimeAction:(UIButton *)sender{
    MLLog(@"设置时间");
    setServiceTimeView *s = [setServiceTimeView new];
    [self pushViewController:s];

}

- (void)aboutUSAction:(UIButton *)sender{
    MLLog(@"关于我们");
    
    
    NSString *url = [GInfo shareClient].mAboutUrl;
    NSString *ss = @"?";
    if ([url rangeOfString:ss].location != NSNotFound) {
        MLLog(@"这个字符串中有?");
        url = [NSString stringWithFormat:@"%@&agent=m",[GInfo shareClient].mAboutUrl];

    }else{
        url = [NSString stringWithFormat:@"%@?agent=m",[GInfo shareClient].mAboutUrl];

    }
    
    WebVC* vc = [[WebVC alloc]init];
    vc.mName = @"关于我们";
    vc.mUrl = url;
    [self pushViewController:vc];
}
- (void)loginAction:(UIButton *)sender{
    MLLog(@"登录");
    [self AlertViewShow:@"退出登录" alertViewMsg:@"是否确定退出当前用户" alertViewCancelBtnTiele:@"取消" alertTag:10];
    


    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if( buttonIndex == 1)
    {
        [SUser logout];
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
//        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self gotoLoginVC];
    }
 
}
- (void)AlertViewShow:(NSString *)alerViewTitle alertViewMsg:(NSString *)msg alertViewCancelBtnTiele:(NSString *)cancelTitle alertTag:(int)tag{
    
    UIAlertView* al = [[UIAlertView alloc] initWithTitle:alerViewTitle message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"确定", nil];
    al.delegate = self;
    al.tag = tag;
    [al show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
