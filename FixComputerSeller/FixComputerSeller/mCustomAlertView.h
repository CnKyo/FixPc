//
//  mCustomAlertView.h
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/13.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mCustomAlertView : UIView
///背景
@property (weak, nonatomic) IBOutlet UIView *mBgkView;

///拨打按钮
@property (weak, nonatomic) IBOutlet UIButton *mCallBtn;

///取消按钮
@property (weak, nonatomic) IBOutlet UIButton *mCancelBtn;

+ (mCustomAlertView *)shareView;

@end
