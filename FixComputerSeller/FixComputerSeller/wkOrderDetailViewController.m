//
//  wkOrderDetailViewController.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "wkOrderDetailViewController.h"
#import "wkOrderDetail.h"
#import "wkCustomView.h"
#import "feedbackViewController.h"
#import <MapKit/MapKit.h>
#import "customAlertView.h"
#import "mHaveBack.h"

#import "mOrderRefund.h"
#import "feiyongViewController.h"


#import "mServiceContent.h"
@interface wkOrderDetailViewController ()<UITextFieldDelegate>

@end

@implementation wkOrderDetailViewController
{
    UIScrollView *sss;
    
    wkOrderDetail *mOrderDetail;
    
    
    
    /**
     *  底部按钮
     */
    UIView *mBottomView;
    
    CGFloat wkAddressH;
    CGFloat wkContenH;
    
    UIView *mTopView;
    UIButton *tempBtn;
    UIImageView *lineImage;
    
    /**
     *  服务内容
     */
    UIView  *mServiceContentView;
    
    customAlertView *alertVC;
    
    /**
     *  工作日志
     */
    mHaveBack *mJobNoteHeaderView;
    /**
     *  有日志
     */
    mHaveBack *mJobNoteView;
    
    mHaveBack *mHaveHuifu;
    
    mServiceContent *mRightTitle;
    mServiceContent *mRightContent;
    
    wkOrderDetail *mCancelView;
}
@synthesize mGoods,mType;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.hiddenlll = YES;
    
    self.mPageName = self.Title = @"订单详情";
    
    sss = [UIScrollView new];
    sss.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sss];
    
    [sss makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    
}
- (void)getData{
    
    [SVProgressHUD showWithStatus:@"获取中" maskType:SVProgressHUDMaskTypeClear];
    
    if ( _wkorder ) {
        
        [_wkorder getDetail:^(SResBase *resb) {
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                [self initView];
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                [self addKEmptyView:nil];
            }
        }];
        
    }
    else{
        SOrder *sorder = [SOrder new];
        
        sorder.mId = _wkArgs;
        [sorder getDetail:^(SResBase *resb) {
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                _wkorder = sorder;
                [self initView];
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                [self addKEmptyView:nil];
            }
        }];
    }
    
}
- (void)initView{
    //    [mOrderDetail removeFromSuperview];
    //    [mBottomView removeFromSuperview];
    //    [mTopView removeFromSuperview];
    //    [mServiceContentView removeFromSuperview];
    //    [mJobNoteHeaderView removeFromSuperview];
    //    [mJobNoteView removeFromSuperview];
    //    [mHaveHuifu removeFromSuperview];
    //    [mRightTitle removeFromSuperview];
    //    [mRightContent removeFromSuperview];
    //    [mCancelView removeFromSuperview];
    
    
    if (_wkorder.mOrderStatus == 300) {
        [self initRefund1];
    }else{
        if (_wkorder.mOrderRate) {
            [self initHaveHuifu];
            
        }else{
            [self initDetailView];
            
        }
        
        [self initBottomBtn];
    }
    [self initServiceContent];
    
    
}
#pragma mark----服务内容
- (void)initServiceContent{
    
    mServiceContentView = [UIView new];
    mServiceContentView.hidden = YES;
    mServiceContentView.backgroundColor = [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1];
    [sss addSubview:mServiceContentView];
    
    [mServiceContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss.right).with.offset(0);
        make.top.equalTo(mTopView.bottom).with.offset(15);
        make.bottom.equalTo(sss).with.offset(0);
        make.width.offset(sss.mwidth);
        
    }];
    
    
    
    
    mRightTitle = [mServiceContent shareTitle];
    [mServiceContentView addSubview:mRightTitle];
    
    mRightTitle.frame = CGRectMake(0, 0, mServiceContentView.mwidth, 45);
    
    
    int y = mRightTitle.mbottom;
    if (_wkorder.mServiceContent.count == 0 || _wkorder.mServiceContent == nil) {
        mRightContent = [mServiceContent shareName];
        mRightContent.frame = CGRectMake(0, y, mServiceContentView.mwidth, 45);
        mRightContent.mServiceName.text = @"";
        mRightContent.mPrice.text = [NSString stringWithFormat:@""];
        [mServiceContentView addSubview:mRightContent];
    }else{
        for (OrderServiceContent *mOrderContent in _wkorder.mServiceContent) {
            
            mRightContent = [mServiceContent shareName];
            mRightContent.frame = CGRectMake(0, y, mServiceContentView.mwidth, 45);
            mRightContent.mServiceName.text = mOrderContent.mGooods.mName;
            mRightContent.mPrice.text = [NSString stringWithFormat:@"¥%.2f",mOrderContent.mGooods.mPrice];
            [mServiceContentView addSubview:mRightContent];
            y+=45;
        }
    }
}
#pragma mark----订单详情－正常1
- (void)initDetailView{
    
    mTopView = [UIView new];
    mTopView.backgroundColor = [UIColor whiteColor];
    [sss addSubview:mTopView];
    
    mOrderDetail = [wkOrderDetail shareOrderDetail];
    
    
    [mOrderDetail.mConnection addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [mOrderDetail.mNav addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [sss addSubview:mOrderDetail];
    

    mJobNoteHeaderView = [mHaveBack shareNoteView];
    [mJobNoteHeaderView.mAddNoteBtn addTarget:self action:@selector(AddNoteAction:) forControlEvents:UIControlEventTouchUpInside];
    [sss addSubview:mJobNoteHeaderView];
    
    mBottomView = [UIView new];
    mBottomView.hidden = YES;
    mBottomView.backgroundColor = [UIColor whiteColor];
    [sss addSubview:mBottomView];
    
    mOrderDetail.mServiceName.text = _wkorder.mGooods.mName;
    wkAddressH = [Util labelText:_wkorder.mAddress fontSize:15 labelWidth:mOrderDetail.mServiceAdd.mwidth];
    wkContenH = [Util labelText:_wkorder.mReMark fontSize:15 labelWidth:mOrderDetail.mServiceNote.mwidth];
    
    
    NSString *payType = nil;
    
    if (_wkorder.mPayState == 1) {
        payType = [NSString stringWithFormat:@"支付方式：%@",_wkorder.mPayment];
    }else{
        payType = [NSString stringWithFormat:@"支付方式：%@",@"未支付"];
        
    }
    
    [mOrderDetail.mPayStatus hyb_setAttributedText:[NSString stringWithFormat:@"服务时间：<style color=#878787>%@</style>",_wkorder.mApptime]];
    
    
    [mOrderDetail.mServiceNum hyb_setAttributedText:[NSString stringWithFormat:@"服务数量：<style color=#878787>%d</style>",_wkorder.mNum]];
    
    [mOrderDetail.mServiceTime hyb_setAttributedText:[NSString stringWithFormat:@"服务时间：<style color=#878787>%@</style>",_wkorder.mApptime]];
    
    [mOrderDetail.mConnectName hyb_setAttributedText:[NSString stringWithFormat:@"联系人：<style color=#878787>%@</style>",_wkorder.mUserName]];
    
    [mOrderDetail.mPhone hyb_setAttributedText:[NSString stringWithFormat:@"联系电话：<style color=#878787>%@</style>",_wkorder.mPhoneNum]];
    
    mOrderDetail.mServiceAdd.text = _wkorder.mAddress;
    
    
    [mOrderDetail.mServiceCode hyb_setAttributedText:[NSString stringWithFormat:@"订单编号：<style color=#878787>%@</style>",_wkorder.mSn]];
    
    if (_wkorder.mReMark == nil || [_wkorder.mReMark isEqualToString:@""]) {
        [mOrderDetail.mServiceNote hyb_setAttributedText:[NSString stringWithFormat:@"备注：<style color=#878787>%@</style>",@"暂无"]];
    }else{
        [mOrderDetail.mServiceNote hyb_setAttributedText:[NSString stringWithFormat:@"备注：<style color=#878787>%@</style>",_wkorder.mReMark]];
        
    }
    
    
    [mOrderDetail.mPrice hyb_setAttributedText:[NSString stringWithFormat:@"费用：<style color=#878787>¥%.2f</style>",_wkorder.mPayMoney]];
    
    
    [mOrderDetail.mPayType hyb_setAttributedText:[NSString stringWithFormat:@"支付方式：<style color=#878787>%@</style>",_wkorder.mPayment]];
    
    [mOrderDetail.mYizhifu hyb_setAttributedText:[NSString stringWithFormat:@"已支付：<style color=#878787>¥%.2f</style>",_wkorder.mTotalMoney]];
    
    CGFloat wkTotleH = 469-36+wkAddressH+wkContenH;
    if (wkTotleH<=469) {
        
        wkTotleH = 469;
    }
    
    [mTopView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sss).with.offset(0);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
        make.bottom.equalTo(mOrderDetail.top).with.offset(0);
        make.height.offset(@50);
    }];
    
    [mOrderDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mTopView.bottom).with.offset(0);
        make.bottom.equalTo(mJobNoteHeaderView.top).with.offset(0);
        make.height.offset(wkTotleH);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    

    mJobNoteHeaderView.frame = CGRectMake(0, wkTotleH+30, sss.mwidth, 65);
    int y = mJobNoteHeaderView.mbottom;
    
    if (_wkorder.mStaffLogArr.count == 0 || _wkorder.mStaffLogArr == nil) {
        mJobNoteView = [mHaveBack shareAddNoteView];
        mJobNoteView.frame = CGRectMake(0, y, sss.mwidth, 70);
        mJobNoteView.mNoteContent.text = @"暂无日志";
        mJobNoteView.mNoteTime.text = @"";
        [sss addSubview:mJobNoteView];
    }else{
        for (StaffLog *mSatffLog in _wkorder.mStaffLogArr) {
            mJobNoteView = [mHaveBack shareAddNoteView];
            mJobNoteView.frame = CGRectMake(0, y, sss.mwidth, 70);
            mJobNoteView.mNoteContent.text = mSatffLog.mContent;
            mJobNoteView.mNoteTime.text = mSatffLog.mCreateTime;
            [sss addSubview:mJobNoteView];
            y+=70;
        }
    }
    
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mJobNoteView.bottom).with.offset(0);
        make.bottom.equalTo(sss).with.offset(0);
        make.height.offset(90);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    
    [self loadTopView];
}
#pragma mark----底部按钮
- (void)initBottomBtn{
    
    mBottomView = [UIView new];
    //    mBottomView.hidden = YES;
    mBottomView.frame = CGRectMake(0, self.view.frame.size.height-66, DEVICE_Width, 65);
    mBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mBottomView];
    
    if ( _wkorder.misCanStartService ) {
        
        UIButton *btn = [UIButton new];
        
        btn.frame = CGRectMake(10, 10, DEVICE_Width-20, 45);
        btn.tag = 10234;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = M_CO;
        [btn setTitle:@"开始服务" forState:0];
        [btn addTarget:self action:@selector(reFuseAndAccept:) forControlEvents:UIControlEventTouchUpInside];
        [mBottomView addSubview:btn];
    }
    else if (_wkorder.misCanRefushAndAccept) {
        UIColor *c1 = [UIColor colorWithRed:0.729 green:0.729 blue:0.729 alpha:1];
        UIColor *c2 = M_CO;
        
        NSArray *cArr = @[c1,c2];
        
        NSArray *tArr = @[@"拒绝订单",@"接受订单"];
        
        for (int i = 0; i<cArr.count; i++) {
            
            UIButton *btn = [UIButton new];
            
            btn.frame = CGRectMake(i*DEVICE_Width/2+10,10, DEVICE_Width/2-20, 45);
            btn.tag = 98+i;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4;
            btn.backgroundColor = cArr[i];
            [btn setTitle:tArr[i] forState:0];
            [btn addTarget:self action:@selector(reFuseAndAccept:) forControlEvents:UIControlEventTouchUpInside];
            [mBottomView addSubview:btn];
            
        }
        
    }
    else if (_wkorder.misCanPendingAndShowItem) {
        UIColor *c1 = [UIColor colorWithRed:0.729 green:0.729 blue:0.729 alpha:1];
        UIColor *c2 = M_CO;
        
        NSArray *cArr = @[c1,c2];
        
        NSArray *tArr = @[@"订单挂起",@"选择收费项目"];
        
        for (int i = 0; i<cArr.count; i++) {
            
            UIButton *btn = [UIButton new];
            
            btn.frame = CGRectMake(i*DEVICE_Width/2+10,10, DEVICE_Width/2-20, 45);
            btn.tag = 1055+i;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4;
            btn.backgroundColor = cArr[i];
            [btn setTitle:tArr[i] forState:0];
            [btn addTarget:self action:@selector(reFuseAndAccept:) forControlEvents:UIControlEventTouchUpInside];
            [mBottomView addSubview:btn];
            
        }
        
    }
    
    else if (_wkorder.misCanContinue) {
        UIButton *btn = [UIButton new];
        
        btn.frame = CGRectMake(10, 10, DEVICE_Width-20, 45);
        btn.tag = 305;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = M_CO;
        [btn setTitle:@"继续服务" forState:0];
        [btn addTarget:self action:@selector(reFuseAndAccept:) forControlEvents:UIControlEventTouchUpInside];
        [mBottomView addSubview:btn];
    }
    else if (_wkorder.misCanProtFixStart) {
        UIButton *btn = [UIButton new];
        
        btn.frame = CGRectMake(10, 10, DEVICE_Width-20, 45);
        btn.tag = 107306;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = M_CO;
        [btn setTitle:@"保修开始服务" forState:0];
        [btn addTarget:self action:@selector(reFuseAndAccept:) forControlEvents:UIControlEventTouchUpInside];
        [mBottomView addSubview:btn];
    }
    else if (_wkorder.misCanPending){
        UIButton *btn = [UIButton new];
        
        btn.frame = CGRectMake(10, 10, DEVICE_Width-20, 45);
        btn.tag = 108;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = M_CO;
        [btn setTitle:@"订单挂起" forState:0];
        [btn addTarget:self action:@selector(reFuseAndAccept:) forControlEvents:UIControlEventTouchUpInside];
        [mBottomView addSubview:btn];
    }
    else {
        UIButton *btn = [UIButton new];
        btn.enabled = YES;
        btn.frame = CGRectMake(10, 10, DEVICE_Width-20, 45);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor colorWithRed:0.729 green:0.729 blue:0.729 alpha:1];
        [btn setTitle:_wkorder.mOrderStateStr forState:0];
        [mBottomView addSubview:btn];
    }
}
#pragma mark----按钮点击事件
- (void)reFuseAndAccept:(UIButton *)sender{
    switch (sender.tag) {
        case 10234:
        {
            MLLog(@"开始服务");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_wkorder startSrv:^(SResBase *resb) {
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
                
            }];
        }
            break;
        case 98:
        {
            MLLog(@"接受");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            [_wkorder acceptOrder:^(SResBase *resb) {
                [SVProgressHUD dismiss];
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
                
            }];
        }
            break;
        case 99:
        {
            MLLog(@"拒绝");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_wkorder refushOrder:^(SResBase *resb) {
                [SVProgressHUD dismiss];
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
                
            }];
            
        }
            break;
        case 1055:
        {
            MLLog(@"挂起");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_wkorder pendingOrder:^(SResBase *resb) {
                [SVProgressHUD dismiss];
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
            }];
            
        }
            break;
        case 1056:
        {
            MLLog(@"选择项目");
            feiyongViewController *f = [feiyongViewController new];
            f.mTepOrder = _wkorder;
            [self pushViewController:f];
            
        }
            break;
        case 305:
        {
            MLLog(@"继续");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_wkorder continueOrder:^(SResBase *resb) {
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
                
            }];
        }
            break;
        case 107306:
        {
            MLLog(@"保修");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_wkorder protFixStart:^(SResBase *resb) {
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
            }];
            
        }
            break;
        case 108:
        {
            MLLog(@"挂起");
            [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_wkorder pendingOrder:^(SResBase *resb) {
                [SVProgressHUD dismiss];
                if (resb.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    [self getData];
                }else{
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
            }];
            
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----订单详情－保修1(有回复)
- (void)initHaveHuifu{
    mTopView = [UIView new];
    mTopView.backgroundColor = [UIColor whiteColor];
    [sss addSubview:mTopView];
    
    mOrderDetail = [wkOrderDetail shareOrderDetail];
    [mOrderDetail.mConnection addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [mOrderDetail.mNav addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    [sss addSubview:mOrderDetail];
    
    mHaveHuifu = [mHaveBack shareHaveBack];
    [mHaveHuifu.mBackBtn addTarget:self action:@selector(BackAction:) forControlEvents:UIControlEventTouchUpInside];
    mHaveHuifu.mBackContent.text = _wkorder.mOrderDetailRate.mContent;
    
    if (_wkorder.mOrderDetailRate.mReply == nil || [_wkorder.mOrderDetailRate.mReply isEqualToString:@""]) {
        mHaveHuifu.mMyhuifu.text = [NSString stringWithFormat:@"我的回复：暂无回复"];
        
    }else{
        mHaveHuifu.mMyhuifu.text = [NSString stringWithFormat:@"我的回复：%@",_wkorder.mOrderDetailRate.mReply];
        
    }
    
    if (_wkorder.mOrderDetailRate.mSellerReply == nil || [_wkorder.mOrderDetailRate.mSellerReply isEqualToString:@""]) {
        mHaveHuifu.mHoutaihuifu.text = [NSString stringWithFormat:@"后台回复：暂无回复"];
        
    }else{
        mHaveHuifu.mHoutaihuifu.text = [NSString stringWithFormat:@"后台回复：%@",_wkorder.mOrderDetailRate.mSellerReply];
        
    }
    int x =0;
    for (int i = 0; i<_wkorder.mOrderDetailRate.mScore; i++) {
        UIImageView *img = [UIImageView new];
        img.frame = CGRectMake(x, 0, 22, 20);
        img.image = [UIImage imageNamed:@"pingjiaLv"];
        [mHaveHuifu.mPjL addSubview:img];
        x+=25;
    }
    
    [sss addSubview:mHaveHuifu];
    
    mJobNoteHeaderView = [mHaveBack shareNoteView];
    [mJobNoteHeaderView.mAddNoteBtn addTarget:self action:@selector(AddNoteAction:) forControlEvents:UIControlEventTouchUpInside];
    [sss addSubview:mJobNoteHeaderView];
    
    
    mBottomView = [UIView new];
    mBottomView.hidden = YES;
    mBottomView.backgroundColor = [UIColor whiteColor];
    [sss addSubview:mBottomView];
    
    mOrderDetail.mServiceName.text = _wkorder.mGooods.mName;
    wkAddressH = [Util labelText:_wkorder.mAddress fontSize:15 labelWidth:mOrderDetail.mServiceAdd.mwidth];
    wkContenH = [Util labelText:_wkorder.mReMark fontSize:15 labelWidth:mOrderDetail.mServiceNote.mwidth];
    
    
    NSString *payType = nil;
    
    if (_wkorder.mPayState == 1) {
        payType = [NSString stringWithFormat:@"支付方式：%@",_wkorder.mPayment];
    }else{
        payType = [NSString stringWithFormat:@"支付方式：%@",@"未支付"];
        
    }
    
    [mOrderDetail.mPayStatus hyb_setAttributedText:[NSString stringWithFormat:@"服务时间：<style color=#878787>%@</style>",_wkorder.mApptime]];
    
    
    [mOrderDetail.mServiceNum hyb_setAttributedText:[NSString stringWithFormat:@"服务数量：<style color=#878787>%d</style>",_wkorder.mNum]];
    
    [mOrderDetail.mServiceTime hyb_setAttributedText:[NSString stringWithFormat:@"服务时间：<style color=#878787>%@</style>",_wkorder.mApptime]];
    
    [mOrderDetail.mConnectName hyb_setAttributedText:[NSString stringWithFormat:@"联系人：<style color=#878787>%@</style>",_wkorder.mUserName]];
    
    [mOrderDetail.mPhone hyb_setAttributedText:[NSString stringWithFormat:@"联系电话：<style color=#878787>%@</style>",_wkorder.mPhoneNum]];
    
    
    [mOrderDetail.mServiceAdd hyb_setAttributedText:[NSString stringWithFormat:@"服务地址：<style color=#878787>%@</style>",_wkorder.mAddress]];
    
    
    [mOrderDetail.mServiceCode hyb_setAttributedText:[NSString stringWithFormat:@"订单编号：<style color=#878787>%@</style>",_wkorder.mSn]];
    
    
    if (_wkorder.mReMark == nil || [_wkorder.mReMark isEqualToString:@""]) {
        [mOrderDetail.mServiceNote hyb_setAttributedText:[NSString stringWithFormat:@"备注：<style color=#878787>%@</style>",@"暂无"]];
    }else{
        [mOrderDetail.mServiceNote hyb_setAttributedText:[NSString stringWithFormat:@"备注：<style color=#878787>%@</style>",_wkorder.mReMark]];
        
    }
    
    [mOrderDetail.mPrice hyb_setAttributedText:[NSString stringWithFormat:@"费用：<style color=#878787>¥%.2f</style>",_wkorder.mPayMoney]];
    
    
    [mOrderDetail.mPayType hyb_setAttributedText:[NSString stringWithFormat:@"支付方式：<style color=#878787>%@</style>",_wkorder.mPayment]];
    
    [mOrderDetail.mYizhifu hyb_setAttributedText:[NSString stringWithFormat:@"已支付：<style color=#878787>¥%.2f</style>",_wkorder.mTotalMoney]];
    
    CGFloat wkTotleH = 469-36+wkAddressH+wkContenH;
    if (wkTotleH<=469) {
        
        wkTotleH = 469;
    }
    
    [mTopView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sss).with.offset(0);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
        make.bottom.equalTo(mOrderDetail.top).with.offset(0);
        make.height.offset(@50);
    }];
    
    [mOrderDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mTopView.bottom).with.offset(0);
        make.bottom.equalTo(mHaveHuifu.top).with.offset(0);
        make.height.offset(wkTotleH);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    
    [mHaveHuifu makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mOrderDetail.bottom).with.offset(0);
        make.bottom.equalTo(mJobNoteHeaderView.top).with.offset(0);
        make.height.offset(191);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    
    [mJobNoteHeaderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mHaveHuifu.bottom).with.offset(0);
        make.bottom.equalTo(mBottomView.top).with.offset(0);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    
    int y = 0;
    if (_wkorder.mStaffLogArr.count == 0 || _wkorder.mStaffLogArr == nil) {
        mJobNoteView = [mHaveBack shareAddNoteView];
        mJobNoteView.frame = CGRectMake(0, y, sss.mwidth, 70);
        mJobNoteView.mNoteContent.text = @"暂无日志";
        mJobNoteView.mNoteTime.text = @"";
        [mJobNoteHeaderView.mAddView addSubview:mJobNoteView];
    }else{
        for (StaffLog *mSatffLog in _wkorder.mStaffLogArr) {
            mJobNoteView = [mHaveBack shareAddNoteView];
            mJobNoteView.frame = CGRectMake(0, y, sss.mwidth, 70);
            mJobNoteView.mNoteContent.text = mSatffLog.mContent;
            mJobNoteView.mNoteTime.text = mSatffLog.mCreateTime;
            [mJobNoteHeaderView.mAddView addSubview:mJobNoteView];
            y+=70;
        }
    }
    
    
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mJobNoteView.bottom).with.offset(10);
        make.bottom.equalTo(sss).with.offset(0);
        make.height.offset(90);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    //    [self initBottomBtn];
    
    [self loadTopView];
    
}
#pragma mark----退款1
- (void)initRefund1{
    mTopView = [UIView new];
    mTopView.backgroundColor = [UIColor whiteColor];
    [sss addSubview:mTopView];
    
    mOrderDetail = [wkOrderDetail shareOrderDetail];
    [mOrderDetail.mConnection addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [mOrderDetail.mNav addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    [sss addSubview:mOrderDetail];
    
    mCancelView = [wkOrderDetail shareCancelreason];
    [sss addSubview:mCancelView];
    
    mOrderDetail.mServiceName.text = _wkorder.mGooods.mName;
    wkAddressH = [Util labelText:_wkorder.mAddress fontSize:15 labelWidth:mOrderDetail.mServiceAdd.mwidth];
    wkContenH = [Util labelText:_wkorder.mReMark fontSize:15 labelWidth:mOrderDetail.mServiceNote.mwidth];
    
    
    [mOrderDetail.mPayStatus hyb_setAttributedText:[NSString stringWithFormat:@"服务时间：<style color=#878787>%@</style>",_wkorder.mApptime]];
    
    
    [mOrderDetail.mServiceNum hyb_setAttributedText:[NSString stringWithFormat:@"服务数量：<style color=#878787>%d</style>",_wkorder.mNum]];
    
    [mOrderDetail.mServiceTime hyb_setAttributedText:[NSString stringWithFormat:@"服务时间：<style color=#878787>%@</style>",_wkorder.mApptime]];
    
    [mOrderDetail.mConnectName hyb_setAttributedText:[NSString stringWithFormat:@"联系人：<style color=#878787>%@</style>",_wkorder.mUserName]];
    
    [mOrderDetail.mPhone hyb_setAttributedText:[NSString stringWithFormat:@"联系电话：<style color=#878787>%@</style>",_wkorder.mPhoneNum]];
    
    
    [mOrderDetail.mServiceAdd hyb_setAttributedText:[NSString stringWithFormat:@"服务地址：<style color=#878787>%@</style>",_wkorder.mAddress]];
    
    
    [mOrderDetail.mServiceCode hyb_setAttributedText:[NSString stringWithFormat:@"订单编号：<style color=#878787>%@</style>",_wkorder.mSn]];
    
    
    if (_wkorder.mReMark == nil || [_wkorder.mReMark isEqualToString:@""]) {
        [mOrderDetail.mServiceNote hyb_setAttributedText:[NSString stringWithFormat:@"备注：<style color=#878787>%@</style>",@"暂无"]];
    }else{
        [mOrderDetail.mServiceNote hyb_setAttributedText:[NSString stringWithFormat:@"备注：<style color=#878787>%@</style>",_wkorder.mReMark]];
        
    }
    
    [mOrderDetail.mPrice hyb_setAttributedText:[NSString stringWithFormat:@"费用：<style color=#878787>¥%.2f</style>",_wkorder.mPayMoney]];
    
    
    [mOrderDetail.mPayType hyb_setAttributedText:[NSString stringWithFormat:@"支付方式：<style color=#878787>%@</style>",_wkorder.mPayment]];
    
    [mOrderDetail.mYizhifu hyb_setAttributedText:[NSString stringWithFormat:@"已支付：<style color=#878787>¥%.2f</style>",_wkorder.mTotalMoney]];
    
    CGFloat wkTotleH = 469-36+wkAddressH+wkContenH;
    if (wkTotleH<=469) {
        
        wkTotleH = 469;
    }
    
    [mTopView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sss).with.offset(0);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
        make.bottom.equalTo(mOrderDetail.top).with.offset(0);
        make.height.offset(@50);
    }];
    
    [mOrderDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mTopView.bottom).with.offset(0);
        make.bottom.equalTo(mCancelView.top).with.offset(0);
        make.height.offset(wkTotleH);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    
    NSString *cancelReasonStr = nil;
    
    if (_wkorder.mCancelReason == nil || [_wkorder.mCancelReason isEqualToString:@""]) {
        cancelReasonStr = @"未填写";
    }else{
        cancelReasonStr = _wkorder.mCancelReason;
        
    }
    
    CGFloat   reasonH = [Util labelText:cancelReasonStr fontSize:15 labelWidth:mCancelView.mCancelreason.mwidth];
    
    CGFloat tt = 57+reasonH;
    
    [mCancelView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mOrderDetail.bottom).with.offset(0);
        make.bottom.equalTo(sss).with.offset(0);
        make.height.offset(tt);
        make.width.equalTo(sss.width);
        make.left.equalTo(sss).with.offset(0);
        make.right.equalTo(sss).with.offset(0);
    }];
    
    [self loadTopView];
    
}

#pragma mark----回复评价
- (void)BackAction:(UIButton *)sender{
    MLLog(@"回复");
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    feedbackViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"xxx"];
    lll.mType = 2;
    lll.mOrder = _wkorder;
    lll.mOrder.mId = _wkorder.mId;
    [self.navigationController pushViewController:lll animated:YES];
}
#pragma mark----填写日志
- (void)AddNoteAction:(UIButton *)sender{
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    feedbackViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"xxx"];
    lll.mType = 1;
    lll.mOrder = _wkorder;
    lll.mOrder.mId = _wkorder.mId;
    [self.navigationController pushViewController:lll animated:YES];
}
#pragma mark----开始服务
- (void)startAction:(UIButton *)sender{
    MLLog(@"开始服务");
}
#pragma mark----拨打
- (void)connectAction:(UIButton *)sender{
    MLLog(@"拨打");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_wkorder.mPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
#pragma mark----导航
- (void)navAction:(UIButton *)sender{
    MLLog(@"导航");
    //跳转到高德地图
    NSString* ampurl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=testapp&backScheme=zyseller&lat=%.7f&lon=%.7f&dev=0&style=0",_wkorder.mLat,_wkorder.mLongit];
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ampurl]] )
    {//
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ampurl]];
    }
    else
    {//ioS map
        
        CLLocationCoordinate2D to;
        to.latitude =  _wkorder.mLat;
        to.longitude =  _wkorder.mLongit;
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
        toLocation.name = _wkorder.mAddress;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    
}
#pragma mark----初始化顶部2个按钮
-(void)loadTopView
{
    
    float x = 0;
    for (int i =0; i<2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, DEVICE_Width/2-20, 45)];
        [btn setTitle:@"订单确认" forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:M_CO forState:0];
        [mTopView addSubview:btn];
        if (i==0) {
            tempBtn = btn;
            lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 3)];
            lineImage.backgroundColor = M_CO;
            lineImage.center = btn.center;
            CGRect rect = lineImage.frame;
            rect.origin.y = 47;
            lineImage.frame = rect;
            [mTopView addSubview:lineImage];
        }
        else
        {
            [btn setTitle:@"服务内容" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1] forState:UIControlStateNormal];
            // paixuImage.backgroundColor = [UIColor redColor];
            
        }
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(topbtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        x+=DEVICE_Width/2;
    }
    
    UIImageView *xianimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, DEVICE_Width, 1)];
    xianimg.backgroundColor  = COLOR(232, 232, 232);
    [mTopView addSubview:xianimg];
    
    
}

-(void)topbtnTouched:(UIButton *)sender
{
    
    if (tempBtn == sender&&sender.tag !=12) {
        return;
    }
    else
    {
        if (sender.tag ==10) {
            NSLog(@"left");
            mServiceContentView.hidden = YES;
            mOrderDetail.hidden = NO;
            
        }
        else
        {
            NSLog(@"right");
            mServiceContentView.hidden = NO;
            mOrderDetail.hidden = YES;
        }
        
        
        [tempBtn setTitleColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1] forState:0];
        [sender setTitleColor:M_CO forState:0];
        tempBtn = sender;
        CGRect rect = lineImage.frame;
        rect.origin.y = 42;
        float x = sender.center.x;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect arect = lineImage.frame ;
            arect.origin.x = x-lineImage.frame.size.width/2;
            lineImage.frame = arect;
        }];
        
    }
    
}
- (void)showAlertView{
    alertVC = [customAlertView shareView];
    
    [alertVC setFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-50)];
    alertVC.bgView.backgroundColor = [UIColor colorWithRed:0.141 green:0.149 blue:0.184 alpha:0.4];
    alertVC.bgkVC.layer.masksToBounds = YES;
    alertVC.bgkVC.layer.cornerRadius = 5;
    alertVC.btn.layer.masksToBounds = YES;
    alertVC.btn.layer.cornerRadius = 5;
    [alertVC.btn addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    int startTime = _wkorder.mServiceStartTime;
    int endTime  = _wkorder.mServiceFinishTime;
    
    int num = (endTime - startTime)/60;
    if (num>60) {
        alertVC.contentLb.text = [NSString stringWithFormat:@"本次服务用时:%.1f小时",num/60.0f];
        
    }
    if (num<0){
        alertVC.contentLb.text = @"本次服务用时:0分钟";
        
    }
    else{
        alertVC.contentLb.text = [NSString stringWithFormat:@"本次服务用时:%d分钟",num];
        
    }
    [self.contentView addSubview:alertVC];
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabAction:)];
    [self.contentView addGestureRecognizer:tapAction];
}
- (void)tabAction:(UIGestureRecognizer *)sender{
    [alertVC removeFromSuperview];
}
#pragma mark----自定义弹框消失
- (void)okBtn:(UIButton *)sender{
    
    [alertVC removeFromSuperview];
}

@end
