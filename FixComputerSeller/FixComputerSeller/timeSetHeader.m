//
//  timeSetHeader.m
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "timeSetHeader.h"

@implementation timeSetHeader

+ (timeSetHeader *)shareView{
    timeSetHeader *view = [[[NSBundle mainBundle]loadNibNamed:@"setHeaderView" owner:self options:nil]objectAtIndex:0];
    
    view.bgkView.layer.masksToBounds = YES;
    view.bgkView.layer.borderColor = [UIColor colorWithRed:0.890 green:0.886 blue:0.886 alpha:1].CGColor;
    view.bgkView.layer.borderWidth = 0.5;
    
    return view;
}

+ (timeSetHeader *)shareBottom{
    timeSetHeader *view = [[[NSBundle mainBundle]loadNibNamed:@"setBottomView" owner:self options:nil]objectAtIndex:0];
    
    view.okBtn.layer.masksToBounds = YES;
    view.okBtn.layer.cornerRadius = 4;
    
    return view;
}

+ (timeSetHeader *)shareContent{
    timeSetHeader *view = [[[NSBundle mainBundle]loadNibNamed:@"setWeek" owner:self options:nil]objectAtIndex:0];
    
    view.line.hidden = YES;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:0.875 green:0.867 blue:0.863 alpha:1];
    [view addSubview:line];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(0);
        make.right.equalTo(view).with.offset(0);
        make.bottom.equalTo(view).with.offset(0);
        make.height.offset(0.6);
        
    }];
    
    return view;
}
@end
