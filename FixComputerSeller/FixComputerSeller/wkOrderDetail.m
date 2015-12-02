//
//  wkOrderDetail.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "wkOrderDetail.h"

@implementation wkOrderDetail

+ (wkOrderDetail *)shareHeaderView{
    
    wkOrderDetail *view = [[[NSBundle mainBundle]loadNibNamed:@"wkOrderBottomView" owner:self options:nil]objectAtIndex:0];
    
    view.mHeader.layer.masksToBounds = YES;
    view.mHeader.layer.cornerRadius = 3;
    
    return view;
    
}
+ (wkOrderDetail *)shareOrderDetail{
    wkOrderDetail *view = [[[NSBundle mainBundle]loadNibNamed:@"orderDetailView" owner:self options:nil]objectAtIndex:0];
//    view.wkView1.layer.masksToBounds = YES;
//    view.wkView1.layer.borderColor = [UIColor colorWithRed:0.871 green:0.855 blue:0.851 alpha:1].CGColor;
//    view.wkView1.layer.borderWidth = 0.75f;
    
    view.wkView2.layer.masksToBounds = YES;
    view.wkView2.layer.borderColor = [UIColor colorWithRed:0.871 green:0.855 blue:0.851 alpha:1].CGColor;
    view.wkView2.layer.borderWidth = 0.75f;
    
    view.mConnection.layer.masksToBounds = YES;
    view.mConnection.layer.cornerRadius = 4;
    view.mConnection.layer.borderColor = M_CO.CGColor;
    view.mConnection.layer.borderWidth = 0.75;
    
    view.mNav.layer.masksToBounds = YES;
    view.mNav.layer.cornerRadius = 4;
    view.mNav.layer.borderColor = M_CO.CGColor;
    view.mNav.layer.borderWidth = 0.75;
    
    return view;
}
+ (wkOrderDetail *)shareCancelreason{
    wkOrderDetail *view = [[[NSBundle mainBundle]loadNibNamed:@"orderDetailView2" owner:self options:nil]objectAtIndex:0];
    
    return view;
}
@end
