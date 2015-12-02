//
//  OrderViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "OrderViewController.h"
#import "takePhotoViewController.h"

#import "UIViewExt.h"
#import "UIView+Additions.h"

@interface OrderViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentV;

@end

@implementation OrderViewController
{
    CGFloat textH;
    CGFloat noteH;
    
    ///用户
    int      userId;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    userId = [SUser currentUser].mUserId;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.isStoryBoard = YES;
    return [super initWithCoder:aDecoder];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.Title = self.mPageName = @"订单";
    self.hiddenBackBtn = YES;
    self.hiddenA = YES;
    self.hiddenB = YES;
    self.hiddenlll = YES;
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView{
    [self getData];
    [self checkAPPUpdate];

    _ooo = [orderMsgView shareView];


    _ooo.mServiceAddressLb.numberOfLines = 2;
    _ooo.mServiceNoteLb.numberOfLines = 2;
    _ooo.mServiceAddressLb.lineBreakMode = NSLineBreakByWordWrapping;
    _ooo.mServiceNoteLb.lineBreakMode = NSLineBreakByWordWrapping;

    _ooo.mServiceAddressLb.text = @"label的高度变化celllabel的labe变化变化abel的高度变化ce";
    _ooo.mServiceNoteLb.text = @"labe变化变化abel的高度变化celllabel的高度变化cabel的高度变化celllabel的高度变化c的高度变化c的高度变化c的高度变化c的高度变化c的高度变化c的高度变化c";
    textH = [_ooo.mServiceAddressLb.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(_ooo.mServiceAddressLb.width, CGFLOAT_MAX)].height;
    noteH = [_ooo.mServiceNoteLb.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(_ooo.mServiceNoteLb.width, CGFLOAT_MAX)].height;
    if (textH >= 40.0) {
        textH = 40.0;
    }
    if (noteH >= 40.0) {
        noteH = 40.0;
    }if (textH == 20) {
        textH = 20;
    }
    
    _ooo.frame = CGRectMake(0, 0, DEVICE_Width, 484+textH+noteH);
    

    [_ooo.hujiaoBtn addTarget:self action:@selector(hujiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_ooo.serviceBtn addTarget:self action:@selector(serviceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _sss = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-64-49)];
    _sss.autoresizesSubviews = NO;
    [_sss addSubview:_ooo];
    
    [self.view addSubview:_sss];

    _sss.contentSize = CGSizeMake(DEVICE_Width, _ooo.frame.size.height);

}
- (void)getData{
    self.page = 1;
    
}
-(void)checkAPPUpdate
{
    if( [GInfo shareClient].mAppDownUrl )
    {
        NSString* msg = [GInfo shareClient].mUpgradeInfo;
        if( [GInfo shareClient].mForceUpgrade )
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:msg delegate:self cancelButtonTitle:@"升级" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:msg delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( [GInfo shareClient].mForceUpgrade )
    {
        [self doupdateAPP];
    }
    else
    {
        if( 1 == buttonIndex )
        {
            [self doupdateAPP];
        }
    }
}
-(void)doupdateAPP
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GInfo shareClient].mAppDownUrl]];
}
- (void)hujiaoAction:(UIButton *)sender{
    MLLog(@"呼叫");
}
- (void)serviceAction:(UIButton *)sender{
    MLLog(@"开始服务");
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    takePhotoViewController *ttt =[secondStroyBoard instantiateViewControllerWithIdentifier:@"ttt"];
    [self.navigationController pushViewController:ttt animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
