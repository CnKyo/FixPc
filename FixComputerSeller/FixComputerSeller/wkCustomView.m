//
//  wkCustomView.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "wkCustomView.h"

@implementation wkCustomView

+ (wkCustomView *)shareAddView{
    
    wkCustomView *view = [[[NSBundle mainBundle]loadNibNamed:@"wkCustomView" owner:self options:nil]objectAtIndex:0];
    
    return view;
    
}
+ (wkCustomView *)shareCustomBottomView{
    wkCustomView *view = [[[NSBundle mainBundle]loadNibNamed:@"wkCustomViewBottom" owner:self options:nil]objectAtIndex:0];
    
    return view;
}
@end
