//
//  wkOrderCell.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "wkOrderCell.h"
@implementation wkOrderCell
@synthesize cellHeight;
- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _wkAddress.text = _model.mAddress;
    _wkOrderName.text = _model.mReMark;
    _wkOrderStatus.text = _model.mReMark;
    
    [_wkPhone setTitle:_model.mReMark forState:0];
    
    CGFloat hh = [Util labelText:_model.mAddress fontSize:15 labelWidth:_wkAddress.mwidth];
    
    cellHeight = 148+hh-18;
    
    [_wkPhone addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark----导航按钮
- (void)navAction:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}
@end
