//
//  mMyDeatailView.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/13.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "mMyDeatailView.h"

@implementation mMyDeatailView

+ (mMyDeatailView *)shareView{
    mMyDeatailView *view = [[[NSBundle mainBundle]loadNibNamed:@"mMyDeatailView" owner:self options:nil]objectAtIndex:0];
    view.mBgkView.layer.masksToBounds = YES;
    view.mBgkView.layer.borderColor = [UIColor colorWithRed:0.890 green:0.882 blue:0.886 alpha:1].CGColor;
    view.mBgkView.layer.borderWidth = 0.75f;
    
    view.mHeaderImg.layer.masksToBounds = YES;
    view.mHeaderImg.layer.cornerRadius = view.mHeaderImg.mheight/2;
    view.mRemarkTextV.placeholder = @"点击输入个人介绍";
    view.mRemarkTextV.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.608 alpha:1];
    
    view.mSaveBtn.layer.masksToBounds = YES;
    view.mSaveBtn.layer.cornerRadius = 3;


    
    return view;
}

@end
