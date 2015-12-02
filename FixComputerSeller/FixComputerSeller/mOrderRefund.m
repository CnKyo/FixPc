//
//  mOrderRefund.m
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/9.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "mOrderRefund.h"

@implementation mOrderRefund

+ (mOrderRefund *)shareView{
    mOrderRefund *view = [[[NSBundle mainBundle]loadNibNamed:@"mOrderRefundView1" owner:self options:nil]objectAtIndex:0];
    view.wkView1.layer.masksToBounds = YES;
    view.wkView1.layer.borderColor = [UIColor colorWithRed:0.871 green:0.855 blue:0.851 alpha:1].CGColor;
    view.wkView1.layer.borderWidth = 0.75f;
    
    view.wkView2.layer.masksToBounds = YES;
    view.wkView2.layer.borderColor = [UIColor colorWithRed:0.871 green:0.855 blue:0.851 alpha:1].CGColor;
    view.wkView2.layer.borderWidth = 0.75f;
    
    
    return view;
}

@end
