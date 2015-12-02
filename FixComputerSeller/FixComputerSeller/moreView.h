//
//  moreView.h
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface moreView : UIView

//头像
@property (weak, nonatomic) IBOutlet UIImageView *mHeader;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *mUserName;

//电话
@property (weak, nonatomic) IBOutlet UILabel *mPhone;

//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *mEditBtn;

@property (weak, nonatomic) IBOutlet UILabel *mYue;
@property (weak, nonatomic) IBOutlet UILabel *mTiXianYue;
@property (weak, nonatomic) IBOutlet UILabel *mDongJieYue;


//请假
@property (weak, nonatomic) IBOutlet UIButton *mQingJia;

//服务时间设置
@property (weak, nonatomic) IBOutlet UIButton *mSetServiceTime;

//服务范围设置
@property (weak, nonatomic) IBOutlet UIButton *mServiceAddress;

//投诉与建议
@property (weak, nonatomic) IBOutlet UIButton *mOpinion;

//消息
@property (weak, nonatomic) IBOutlet UIButton *mMessage;

//关于我们
@property (weak, nonatomic) IBOutlet UIButton *mAboutUs;

//注销
@property (weak, nonatomic) IBOutlet UIButton *mLogOut;

+ (moreView *)shareView;

+ (moreView *)shareTwo;
@end
