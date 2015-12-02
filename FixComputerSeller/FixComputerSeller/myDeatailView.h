//
//  myDeatailView.h
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/24.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface myDeatailView : BaseVC
///头像
@property (weak, nonatomic) IBOutlet UIImageView *mHeaderImg;
///用户名
@property (weak, nonatomic) IBOutlet UILabel *mUserName;
///手机号码
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
///设置按钮
@property (weak, nonatomic) IBOutlet UIButton *mSetBtn;
///背景
@property (weak, nonatomic) IBOutlet UIView *mBgkView;

@end
