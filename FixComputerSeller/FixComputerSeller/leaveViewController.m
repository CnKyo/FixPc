//
//  leaveViewController.m
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/23.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "leaveViewController.h"
#import "leaveTableViewController.h"
@interface leaveViewController ()

@end

@implementation leaveViewController{

    UIView*     _pickview;
    UIView*     _bgview;
    NSDate*     _startime;
    NSDate*     _enttime;
    
    BOOL        _bmodifstarttime;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.isStoryBoard = YES;
    return [super initWithCoder:aDecoder];
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];///视图消失键盘位置取消调整
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];///关闭自定义工具栏
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"请假";
    self.hiddenA = YES;
    self.hiddenB = YES;
    self.hiddenlll = YES;
    self.rightBtnTitle = @"请假历史";
    [self.navBar.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    self.navBar.rightBtn.frame = CGRectMake(DEVICE_Width-80, self.navBar.leftBtn.origin.y, 100, self.navBar.leftBtn.mheight);
    
    [self initView];
    [self loadPickView];
    // Do any additional setup after loading the view.
}
- (void)initView{
    _lll = [leavVC shareView];
    _lll.frame = CGRectMake(0, 20, DEVICE_Width, 568);
    _lll.backgroundColor = COLOR(236, 237, 239);
    _sss.frame = CGRectMake(0, DEVICE_Height-64, DEVICE_Width, 568);
    _sss.backgroundColor = COLOR(236, 237, 239);

    [_sss addSubview:_lll];

    [_lll.mStartBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lll.mEndBtn addTarget:self action:@selector(endAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lll.mOkBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sss addSubview:_lll];
    _sss.contentSize = CGSizeMake(DEVICE_Width, DEVICE_Height);

}
- (void)startAction:(id)sender {
    _bmodifstarttime = YES;
    [self showPick];
}
- (void)endAction:(id)sender {
    _bmodifstarttime = NO;
    [self showPick];
}
- (void)okAction:(id)sender {
    
    MLLog(@"******:%@,%@",_startime,_enttime);
    int  kstarttime = [[NSString stringWithFormat:@"%f",[_startime timeIntervalSince1970]]intValue]-3600*8;
    int kendtime = [[NSString stringWithFormat:@"%f",[_enttime timeIntervalSince1970]]intValue]-3600*8;
    
    MLLog(@"得到最后的时间:%d,%d",kstarttime,kendtime);
    
    if( _lll.mTxView.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入请假理由"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [[SUser currentUser] leaveReq:kstarttime endtime:kendtime text:_lll.mTxView.text block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self popViewController];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus: resb.mmsg];
        }
    }];

}
- (void)loadPickView{
    UINib* nib = [UINib nibWithNibName:@"pickVC" bundle:nil];
    _pickview = [nib instantiateWithOwner:self options:nil].firstObject;
    
    UIButton* canclebt = (UIButton*)[_pickview viewWithTag:1];
    [canclebt addTarget:self action:@selector(pickbtclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* okbt = (UIButton*)[_pickview viewWithTag:2];
    [okbt addTarget:self action:@selector(pickbtclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _startime = [NSDate date];
    
    _enttime  = [NSDate dateWithTimeIntervalSinceNow:3600*24];
    [self updateTimeInfo];

}
-(void)updateTimeInfo
{
    NSString* st = [Util getTimeStringS:_startime];
    [_lll.mStartBtn setTitle:st  forState:UIControlStateNormal];
    
    st = [Util getTimeStringS:_enttime];
    [_lll.mEndBtn setTitle:st  forState:UIControlStateNormal];
    
}
-(void)pickbtclicked:(UIButton*)sender
{
    if( sender.tag == 1 )
    {//取消
        
    }
    else
    {//确定
        UIDatePicker* tmppick = (UIDatePicker*)[_pickview viewWithTag:3];
        if( _bmodifstarttime )
        {//修改开始时间
            _startime = tmppick.date;
            if( [_enttime earlierDate:_startime] == _enttime )
            {
                _enttime = [_startime dateByAddingTimeInterval:3600*24];
            }
        }
        else
        {//修改结束时间
            _enttime = tmppick.date;
        }
        [self updateTimeInfo];
    }
    [self hidenPick];
}
-(void)bgclicked:(id)sender
{
    [self hidenPick];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showPick
{
    CGRect mR = _pickview.frame;
    mR.size.width = DEVICE_Width;
    _pickview.frame = mR;
    
    _bgview = [[UIView alloc]initWithFrame:self.view.bounds];
    _bgview.alpha = 0.1;
    _bgview.userInteractionEnabled = YES;
    UITapGestureRecognizer* guest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgclicked:)];
    [_bgview addGestureRecognizer: guest];
    
    UIImageView * bgimag = [[UIImageView alloc]initWithFrame:_bgview.bounds];
    bgimag.backgroundColor = [UIColor blackColor];
    bgimag.alpha = 0.75f;
    [_bgview addSubview: bgimag];
    [_bgview addSubview: _pickview];
    UIDatePicker* tmppick = (UIDatePicker*)[_pickview viewWithTag:3];
    if( _bmodifstarttime )
    {
        tmppick.date = _startime;
    }
    else
    {
        tmppick.date = _enttime;
    }
    
    
    CGRect f = _pickview.frame;
    f.origin.y = DEVICE_Height;
    _pickview.frame = f;
    
    [self.view addSubview: _bgview];
    [UIView animateWithDuration:0.3f animations:^{
        
        _bgview.alpha = 1;
        CGRect ff = _pickview.frame;
        ff.origin.y -= ff.size.height;
        _pickview.frame = ff;
        
    }];
    
}
-(void)hidenPick
{
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect ff = _pickview.frame;
        ff.origin.y = DEVICE_Height;
        _pickview.frame = ff;
        _bgview.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_bgview removeFromSuperview];
        [_pickview removeFromSuperview];
        _bgview = nil;
        
    }];
    
}
- (void)rightBtnTouched:(id)sender{
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    leaveTableViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"leaveT"];
    [self.navigationController pushViewController:lll animated:YES];
}

@end
