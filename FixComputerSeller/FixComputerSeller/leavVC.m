//
//  leavVC.m
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/23.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "leavVC.h"

@implementation leavVC

+ (leavVC *)shareView{
    leavVC *view = [[[NSBundle mainBundle]loadNibNamed:@"leavVC" owner:self options:nil]objectAtIndex:0];
    
    view.backgroundColor = [UIColor colorWithRed:0.953 green:0.937 blue:0.933 alpha:1];
    
    view.mBgkView.layer.masksToBounds = YES;
    view.mBgkView.layer.borderColor = [UIColor colorWithRed:0.878 green:0.863 blue:0.859 alpha:1.000].CGColor;
    view.mBgkView.layer.borderWidth = 0.75f;
    view.mBgkView.layer.cornerRadius = 5.0f;


    view.bgkView1.layer.masksToBounds = YES;
    view.bgkView1.layer.cornerRadius = 5.0f;
    view.bgkView1.layer.borderColor = [UIColor colorWithRed:0.878 green:0.863 blue:0.859 alpha:1.000].CGColor;
    view.bgkView1.layer.borderWidth = 1;
    
    view.bgkView2.layer.masksToBounds = YES;
    view.bgkView2.layer.cornerRadius = 5.0f;
    view.bgkView2.layer.borderColor = [UIColor colorWithRed:0.878 green:0.863 blue:0.859 alpha:1.000].CGColor;
    view.bgkView2.layer.borderWidth = 1;
    
    view.mTxView.placeholder = @"请输入你的请假原因";
    
    view.mOkBtn.layer.masksToBounds = YES;
    view.mOkBtn.layer.cornerRadius = 4;
    view.mOkBtn.backgroundColor  = M_CO;
    return view;
}

@end
