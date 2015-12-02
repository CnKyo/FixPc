//
//  orderFeiyong.m
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/11.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "orderFeiyong.h"

@implementation orderFeiyong

+ (orderFeiyong *)shareBottom{

    orderFeiyong *view = [[[NSBundle mainBundle]loadNibNamed:@"orderFeiyong" owner:self options:nil]objectAtIndex:0];
    
    view.mNum.layer.masksToBounds = YES;
    view.mNum.layer.cornerRadius = view.mNum.mwidth/2;
    
    view.mDoneBtn.layer.masksToBounds = YES;
    view.mDoneBtn.layer.cornerRadius = 4;
    
    return view;
}

+ (orderFeiyong *)shareSearch{
    orderFeiyong *view = [[[NSBundle mainBundle]loadNibNamed:@"searchView" owner:self options:nil]objectAtIndex:0];
    
   
    view.mSearchView.layer.masksToBounds = YES;
    view.mSearchView.layer.borderColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1].CGColor;
    view.mSearchView.layer.borderWidth = 0.75;
    view.mSearchView.layer.cornerRadius = 4;
    
    return view;
}
+ (orderFeiyong *)shareJiesuan{
    orderFeiyong *view = [[[NSBundle mainBundle]loadNibNamed:@"jiesuanView" owner:self options:nil]objectAtIndex:0];

    view.mDoneBtn.layer.masksToBounds = YES;
    view.mDoneBtn.layer.cornerRadius = 4;
    
    return view;
}
@end
