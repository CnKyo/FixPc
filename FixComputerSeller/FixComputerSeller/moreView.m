//
//  moreView.m
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "moreView.h"

@implementation moreView

+(moreView *)shareView{
    moreView *view = [[[NSBundle mainBundle]loadNibNamed:@"moreView" owner:self options:nil]objectAtIndex:0];
    
    view.mHeader.layer.masksToBounds = YES;
    view.mHeader.layer.cornerRadius = view.mHeader.mwidth/2;
    
    view.mLogOut.layer.masksToBounds = YES;
    view.mLogOut.layer.cornerRadius = 4;
    
    return view;
}
+(moreView *)shareTwo{
    moreView *view = [[[NSBundle mainBundle]loadNibNamed:@"moreTwoiView" owner:self options:nil]objectAtIndex:0];
    
    view.mHeader.layer.masksToBounds = YES;
    view.mHeader.layer.cornerRadius = view.mHeader.mwidth/2;
    
    view.mLogOut.layer.masksToBounds = YES;
    view.mLogOut.layer.cornerRadius = 4;
    
    return view;
}
@end
