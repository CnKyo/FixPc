//
//  mCustomAlertView.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/13.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "mCustomAlertView.h"

@implementation mCustomAlertView

+ (mCustomAlertView *)shareView{
    mCustomAlertView *view = [[[NSBundle mainBundle]loadNibNamed:@"mCustomAlertView" owner:self options:nil]objectAtIndex:0];

    view.mBgkView.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.5];

    view.mCancelBtn.layer.masksToBounds = YES;
    view.mCancelBtn.layer.cornerRadius = 4;
    
    
    view.mCallBtn.layer.masksToBounds = YES;
    view.mCallBtn.layer.cornerRadius = 4;
    
    return view;
}

@end
